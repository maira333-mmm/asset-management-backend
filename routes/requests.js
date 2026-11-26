const express = require('express');
const router = express.Router();
const pool = require('../config/db');
// 🌟 FIX: Changed from '../middleware/auth' to '../middleware/authMiddleware'
const authMiddleware = require('../middleware/authMiddleware');

// 1. POST: Employee nayi request bheje
router.post('/', authMiddleware, async (req, res) => {
  try {
    const { category_id, reason } = req.body;
    const employee_id = req.user.employee_id;

    const newRequest = await pool.query(
      `INSERT INTO asset_requests (employee_id, category_id, reason, request_date, status) 
       VALUES ($1, $2, $3, CURRENT_DATE, 'Pending') RETURNING *`,
      [employee_id, category_id, reason]
    );

    res.status(201).json({ message: "Request sent to manager", data: newRequest.rows[0] });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 2. GET: Manager apne team ki pending requests dekhe
router.get('/pending', authMiddleware, async (req, res) => {
  try {
    const manager_id = req.user.employee_id;
    const result = await pool.query(
      `SELECT ar.*, e.name as employee_name, ac.category_name 
       FROM asset_requests ar
       JOIN employees e ON ar.employee_id = e.employee_id
       JOIN asset_categories ac ON ar.category_id = ac.category_id
       WHERE e.manager_id = $1 AND ar.status = 'Pending'`,
      [manager_id]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 3. PUT: Manager request Approve/Reject kare
router.put('/:id/status', authMiddleware, async (req, res) => {
  try {
    const { status, asset_id } = req.body; // 'Approved' or 'Rejected'
    const request_id = req.params.id;
    const approved_by = req.user.user_id; // Manager's user_id

    // Update request status
    await pool.query(
      `UPDATE asset_requests SET status = $1 WHERE request_id = $2`,
      [status, request_id]
    );

    // Log the approval
    await pool.query(
      `INSERT INTO request_approvals (request_id, approved_by, approval_status, approved_on) 
       VALUES ($1, $2, $3, CURRENT_DATE)`,
      [request_id, approved_by, status]
    );

    // If Approved, assign the asset
    if (status === 'Approved' && asset_id) {
      const employeeRes = await pool.query(`SELECT employee_id FROM asset_requests WHERE request_id = $1`, [request_id]);
      const employee_id = employeeRes.rows[0].employee_id;

      await pool.query(
        `INSERT INTO asset_assignments (asset_id, employee_id, assigned_by, assigned_on) 
         VALUES ($1, $2, $3, CURRENT_DATE)`,
        [asset_id, employee_id, req.user.employee_id]
      );
      
      await pool.query(`UPDATE assets SET status = 'Assigned' WHERE asset_id = $1`, [asset_id]);
    }

    res.json({ message: `Request ${status} successfully` });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;