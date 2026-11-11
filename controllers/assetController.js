const pool = require('../config/db');

// @desc    Create a new asset
// @route   POST /api/assets
exports.createAsset = async (req, res) => {
  try {
    const { 
      asset_tag, 
      serial_number, 
      status, 
      purchase_date, 
      category_id, 
      vendor_id, 
      location_id, 
      dept_id 
    } = req.body;
    
    // SQL Query to insert a new asset
    const newAsset = await pool.query(
      `INSERT INTO assets 
      (asset_tag, serial_number, status, purchase_date, category_id, vendor_id, location_id, dept_id) 
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *`,
      [asset_tag, serial_number, status, purchase_date, category_id, vendor_id, location_id, dept_id]
    );

    res.status(201).json({ 
      message: "Asset created successfully", 
      data: newAsset.rows[0] 
    });
  } catch (err) {
    console.error("Error creating asset:", err.message);
    res.status(500).json({ error: "Server Error", details: err.message });
  }
};

// @desc    Get all assets
// @route   GET /api/assets
exports.getAllAssets = async (req, res) => {
  try {
    // SQL Query to fetch all assets
    const allAssets = await pool.query('SELECT * FROM assets');
    res.status(200).json(allAssets.rows);
  } catch (err) {
    console.error("Error fetching assets:", err.message);
    res.status(500).json({ error: "Server Error" });
  }
};