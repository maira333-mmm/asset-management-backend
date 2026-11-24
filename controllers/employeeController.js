const pool = require('../config/db');
const bcrypt = require('bcryptjs');

// @desc    Create a new employee/manager
// @route   POST /api/employees
exports.createEmployee = async (req, res) => {
  try {
    const { 
      name, contact, cnic, joining_date, designation, address, emergency_contact,
      email, password, department_id, role_name, manager_id 
    } = req.body;

    // 1. Validation
    if (!name || !email || !password || !department_id || !cnic) {
      return res.status(400).json({ message: "Name, email, password, department, and CNIC are required" });
    }

    // 2. Check if email already exists
    const userExists = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
    if (userExists.rows.length > 0) {
      return res.status(400).json({ message: "User with this email already exists" });
    }

    // 3. Check if CNIC already exists
    const cnicExists = await pool.query('SELECT * FROM employees WHERE cnic = $1', [cnic]);
    if (cnicExists.rows.length > 0) {
      return res.status(400).json({ message: "Employee with this CNIC already exists" });
    }

    // 4. Create User Account (status = Active by default)
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);
    const newUser = await pool.query(
      'INSERT INTO users (email, password_hash, status) VALUES ($1, $2, $3) RETURNING user_id',
      [email, hashedPassword, 'Active']
    );
    const user_id = newUser.rows[0].user_id;

    // 5. Assign Role
    const roleResult = await pool.query('SELECT role_id FROM roles WHERE role_name = $1', [role_name || 'Employee']);
    if (roleResult.rows.length > 0) {
      await pool.query(
        'INSERT INTO user_roles (user_id, role_id) VALUES ($1, $2)',
        [user_id, roleResult.rows[0].role_id]
      );
    }

    // 6. Create Employee Profile
    const newEmployee = await pool.query(
      `INSERT INTO employees 
      (name, contact, cnic, joining_date, designation, address, emergency_contact, department_id, user_id, manager_id) 
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *`,
      [name, contact, cnic, joining_date, designation, address || null, emergency_contact || null, department_id, user_id, manager_id || null]
    );

    res.status(201).json({ 
      message: "Employee created successfully with full profile", 
      data: newEmployee.rows[0] 
    });

  } catch (err) {
    console.error("Error creating employee:", err.message);
    if (err.code === '23505') {
      return res.status(400).json({ error: "Email or CNIC already exists" });
    }
    res.status(500).json({ error: "Server Error" });
  }
};

// @desc    Get all employees
// @route   GET /api/employees
exports.getAllEmployees = async (req, res) => {
  try {
    const query = `
      SELECT e.*, u.email, u.status 
      FROM employees e
      JOIN users u ON e.user_id = u.user_id
      ORDER BY e.name ASC
    `;
    const allEmployees = await pool.query(query);
    res.status(200).json(allEmployees.rows);
  } catch (err) {
    console.error("Error fetching employees:", err.message);
    res.status(500).json({ error: "Server Error" });
  }
};

// @desc    Update an employee
// @route   PUT /api/employees/:id
exports.updateEmployee = async (req, res) => {
  try {
    const { id } = req.params;
    const { 
      name, contact, cnic, joining_date, designation, address, emergency_contact,
      department_id, role_name, manager_id 
    } = req.body;

    // 1. Update Employee Profile
    const updatedEmployee = await pool.query(
      `UPDATE employees 
       SET name = $1, contact = $2, cnic = $3, joining_date = $4, 
           designation = $5, address = $6, emergency_contact = $7, 
           department_id = $8, manager_id = $9
       WHERE employee_id = $10 RETURNING *`,
      [name, contact, cnic, joining_date, designation, address, emergency_contact, department_id, manager_id || null, id]
    );

    if (updatedEmployee.rows.length === 0) {
      return res.status(404).json({ message: "Employee not found" });
    }

    // 2. Update Role (if changed)
    if (role_name) {
      const empUserId = updatedEmployee.rows[0].user_id;
      const roleResult = await pool.query('SELECT role_id FROM roles WHERE role_name = $1', [role_name]);
      
      if (roleResult.rows.length > 0) {
        await pool.query('DELETE FROM user_roles WHERE user_id = $1', [empUserId]);
        await pool.query(
          'INSERT INTO user_roles (user_id, role_id) VALUES ($1, $2)',
          [empUserId, roleResult.rows[0].role_id]
        );
      }
    }

    res.status(200).json({ message: "Employee updated successfully", data: updatedEmployee.rows[0] });
  } catch (err) {
    console.error("Error updating employee:", err.message);
    res.status(500).json({ error: "Server Error" });
  }
};

// @desc    Suspend or Activate an employee
// @route   PUT /api/employees/:id/status
exports.updateEmployeeStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    if (!['Active', 'Suspended'].includes(status)) {
      return res.status(400).json({ message: "Status must be 'Active' or 'Suspended'" });
    }

    const emp = await pool.query('SELECT user_id FROM employees WHERE employee_id = $1', [id]);
    if (emp.rows.length === 0) {
      return res.status(404).json({ message: "Employee not found" });
    }

    const updated = await pool.query(
      'UPDATE users SET status = $1 WHERE user_id = $2 RETURNING user_id, email, status',
      [status, emp.rows[0].user_id]
    );

    res.status(200).json({
      message: `Employee ${status === 'Suspended' ? 'suspended' : 'activated'} successfully`,
      data: updated.rows[0]
    });
  } catch (err) {
    console.error("Error updating employee status:", err.message);
    res.status(500).json({ error: "Server Error" });
  }
};

// @desc    Delete an employee (Hard delete - only if no records)
// @route   DELETE /api/employees/:id
exports.deleteEmployee = async (req, res) => {
  try {
    const { id } = req.params;

    const emp = await pool.query('SELECT user_id FROM employees WHERE employee_id = $1', [id]);
    if (emp.rows.length === 0) {
      return res.status(404).json({ message: "Employee not found" });
    }

    // Check if employee has assignments or requests
    const assignments = await pool.query('SELECT 1 FROM asset_assignments WHERE employee_id = $1 LIMIT 1', [id]);
    const requests = await pool.query('SELECT 1 FROM asset_requests WHERE employee_id = $1 LIMIT 1', [id]);

    if (assignments.rows.length > 0 || requests.rows.length > 0) {
      return res.status(400).json({ 
        message: "Cannot delete employee with existing assignments or requests. Please suspend instead." 
      });
    }

    await pool.query('DELETE FROM employees WHERE employee_id = $1', [id]);
    await pool.query('DELETE FROM user_roles WHERE user_id = $1', [emp.rows[0].user_id]);
    await pool.query('DELETE FROM users WHERE user_id = $1', [emp.rows[0].user_id]);

    res.status(200).json({ message: "Employee deleted successfully" });
  } catch (err) {
    console.error("Error deleting employee:", err.message);
    res.status(500).json({ error: "Server Error" });
  }
};