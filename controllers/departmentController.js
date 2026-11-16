const pool = require('../config/db');

// @desc    Create a new department
// @route   POST /api/departments
exports.createDepartment = async (req, res) => {
  try {
    const { department_name, location_id } = req.body;

    // Validation
    if (!department_name) {
      return res.status(400).json({ message: "Department name is required" });
    }

    // Insert into database
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