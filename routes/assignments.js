const express = require('express');
const router = express.Router();
const pool = require('../config/db');
const authMiddleware = require('../middleware/authMiddleware'); 

// 1. GET: Manager apne department ke available assets dekhe
router.get('/available-assets', authMiddleware, async (req, res) => {
  try {
    const deptId = req.user.department_id; 
    const result = await pool.query(
      `SELECT * FROM assets 
       WHERE status = 'Available' AND dept_id = $1`, 
      [deptId]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 2. POST: Manager direct assign kare
router.post('/assign', authMiddleware, async (req, res) => {
  try {
    const { asset_id, employee_id } = req.body;
    const manager_id = req.user.employee_id;

    const newAssignment = await pool.query(
      `INSERT INTO asset_assignments (asset_id, employee_id, assigned_by, assigned_on) 
       VALUES ($1, $2, $3, CURRENT_DATE) RETURNING *`,
      [asset_id, employee_id, manager_id]
    );

    await pool.query(
      `UPDATE assets SET status = 'Assigned' WHERE asset_id = $1`,
      [asset_id]
    );

    res.status(201).json({ message: "Asset assigned successfully", data: newAssignment.rows[0] });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 3. GET: Employee apne assigned assets dekhe
router.get('/my-assets', authMiddleware, async (req, res) => {
  try {
    const employee_id = req.user.employee_id;
    const result = await pool.query(
      `SELECT aa.*, a.asset_tag, a.serial_number 
       FROM asset_assignments aa
       JOIN assets a ON aa.asset_id = a.asset_id
       WHERE aa.employee_id = $1 AND aa.returned_on IS NULL`,
      [employee_id]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 🌟 NAYA ROUTE: Manager apni assignments dekhe (History ke liye)
router.get('/my-assignments', authMiddleware, async (req, res) => {
  try {
    const manager_id = req.user.employee_id;
    const result = await pool.query(
      `SELECT aa.*, 
              e.name as employee_name, 
              a.asset_tag, 
              a.serial_number,
              c.category_name
       FROM asset_assignments aa
       JOIN employees e ON aa.employee_id = e.employee_id
       JOIN assets a ON aa.asset_id = a.asset_id
       LEFT JOIN asset_categories c ON a.category_id = c.category_id
       WHERE aa.assigned_by = $1 AND aa.returned_on IS NULL
       ORDER BY aa.assigned_on DESC`,
      [manager_id]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;