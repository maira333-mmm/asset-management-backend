const express = require('express');
const router = express.Router();
const pool = require('../config/db');
const authMiddleware = require('../middleware/authMiddleware');

// 1. POST: Employee asset return ki request bheje
router.post('/', authMiddleware, async (req, res) => {
  try {
    const { asset_id, condition, reason } = req.body;
    const employee_id = req.user.employee_id;

    const newReturn = await pool.query(
      `INSERT INTO asset_returns (asset_id, employee_id, condition, reason, return_date, status) 
       VALUES ($1, $2, $3, $4, CURRENT_DATE, 'Pending') RETURNING *`,
      [asset_id, employee_id, condition, reason]
    );

    res.status(201).json({ message: "Return request sent to manager", data: newReturn.rows[0] });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 2. GET: Manager pending return requests dekhe
router.get('/pending', authMiddleware, async (req, res) => {
  try {
    const manager_id = req.user.employee_id;
    const result = await pool.query(
      `SELECT ar.*, e.name as employee_name, a.asset_tag, a.serial_number, c.category_name
       FROM asset_returns ar
       JOIN employees e ON ar.employee_id = e.employee_id
       JOIN assets a ON ar.asset_id = a.asset_id
       JOIN asset_categories c ON a.category_id = c.category_id
       WHERE e.manager_id = $1 AND ar.status = 'Pending'`,
      [manager_id]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 🌟 3. GET: Manager apni saari return history dekhe (Approved/Rejected)
router.get('/history', authMiddleware, async (req, res) => {
  try {
    const manager_id = req.user.employee_id;
    const result = await pool.query(
      `SELECT ar.*, e.name as employee_name, a.asset_tag, a.serial_number, c.category_name
       FROM asset_returns ar
       JOIN employees e ON ar.employee_id = e.employee_id
       JOIN assets a ON ar.asset_id = a.asset_id
       JOIN asset_categories c ON a.category_id = c.category_id
       WHERE e.manager_id = $1 AND ar.status != 'Pending'
       ORDER BY ar.return_date DESC`,
      [manager_id]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 4. PUT: Manager return accept/reject kare
router.put('/:id/status', authMiddleware, async (req, res) => {
  try {
    // 🌟 manager_action receive karein ('Available', 'Under Maintenance', 'Retired')
    const { status, manager_comment, manager_action } = req.body;
    const return_id = req.params.id;

    await pool.query(
      `UPDATE asset_returns 
       SET status = $1, manager_comment = $2, manager_action = $3 
       WHERE return_id = $4`,
      [status, manager_comment || null, manager_action || null, return_id]
    );

    if (status === 'Approved') {
      const returnData = await pool.query(`SELECT asset_id, employee_id FROM asset_returns WHERE return_id = $1`, [return_id]);
      const { asset_id, employee_id } = returnData.rows[0];

      // 🌟 Decide the new asset status based on manager's action
      let newAssetStatus = 'Available';
      if (manager_action === 'Under Maintenance') newAssetStatus = 'Under Maintenance';
      if (manager_action === 'Retired') newAssetStatus = 'Retired';

      // Update Asset Status
      await pool.query(`UPDATE assets SET status = $1 WHERE asset_id = $2`, [newAssetStatus, asset_id]);
      
      // Remove assignment (Asset is no longer with employee)
      await pool.query(`DELETE FROM asset_assignments WHERE asset_id = $1 AND employee_id = $2`, [asset_id, employee_id]);
    }

    res.json({ message: `Return request ${status} successfully` });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 5. GET: Employee apni return requests dekhe
router.get('/my-returns', authMiddleware, async (req, res) => {
  try {
    const employee_id = req.user.employee_id;
    const result = await pool.query(
      `SELECT ar.*, a.asset_tag, a.serial_number, c.category_name
       FROM asset_returns ar
       JOIN assets a ON ar.asset_id = a.asset_id
       JOIN asset_categories c ON a.category_id = c.category_id
       WHERE ar.employee_id = $1
       ORDER BY ar.return_date DESC`,
      [employee_id]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;