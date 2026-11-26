const pool = require('../config/db');

// @desc    Create a new department
// @route   POST /api/departments
exports.createDepartment = async (req, res) => {
  try {
    const { department_name, location_id } = req.body;

    if (!department_name) {
      return res.status(400).json({ message: "Department name is required" });
    }

    const newDept = await pool.query(
      'INSERT INTO departments (department_name, location_id) VALUES ($1, $2) RETURNING *',
      [department_name, location_id || null]
    );

    res.status(201).json({ 
      message: "Department created successfully", 
      data: newDept.rows[0] 
    });
  } catch (err) {
    console.error("Error creating department:", err.message);
    res.status(500).json({ error: "Server Error" });
  }
};

// @desc    Get all departments
// @route   GET /api/departments
exports.getAllDepartments = async (req, res) => {
  try {
    const allDepts = await pool.query('SELECT * FROM departments ORDER BY department_name ASC');
    res.status(200).json(allDepts.rows);
  } catch (err) {
    console.error("Error fetching departments:", err.message);
    res.status(500).json({ error: "Server Error" });
  }
};

// @desc    Delete a department
// @route   DELETE /api/departments/:id
exports.deleteDepartment = async (req, res) => {
  try {
    const { id } = req.params;

    // 1. Check if department exists
    const deptExists = await pool.query('SELECT * FROM departments WHERE department_id = $1', [id]);
    if (deptExists.rows.length === 0) {
      return res.status(404).json({ message: "Department not found" });
    }

    // 2. Check if department is used by any employee
    const empExists = await pool.query('SELECT 1 FROM employees WHERE department_id = $1 LIMIT 1', [id]);
    if (empExists.rows.length > 0) {
      return res.status(400).json({ 
        message: "Cannot delete department. Employees are assigned to it. Reassign them first." 
      });
    }

    // 3. Check if department is used by any asset
    const assetExists = await pool.query('SELECT 1 FROM assets WHERE dept_id = $1 LIMIT 1', [id]);
    if (assetExists.rows.length > 0) {
      return res.status(400).json({ 
        message: "Cannot delete department. Assets are assigned to it. Reassign them first." 
      });
    }

    // 4. Delete department
    await pool.query('DELETE FROM departments WHERE department_id = $1', [id]);

    res.status(200).json({ message: "Department deleted successfully" });
  } catch (err) {
    console.error("Error deleting department:", err.message);
    res.status(500).json({ error: "Server Error" });
  }
};