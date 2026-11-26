const express = require('express');
const router = express.Router();
const pool = require('../config/db');

router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM system_settings ORDER BY id ASC LIMIT 1');
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.put('/', async (req, res) => {
  const { primary_color, accent_color, bg_color, logo_url } = req.body;
  try {
    const result = await pool.query(
      `UPDATE system_settings 
       SET primary_color=$1, accent_color=$2, bg_color=$3, logo_url=$4, updated_at=CURRENT_TIMESTAMP 
       WHERE id=(SELECT id FROM system_settings ORDER BY id ASC LIMIT 1) RETURNING *`,
      [primary_color, accent_color, bg_color, logo_url]
    );
    res.json(result.rows[0]);
  } catch (err) {
    console.error("Database Error:", err.message);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;