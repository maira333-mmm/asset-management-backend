const pool = require('../config/db');

// @desc    Create a new asset
// @route   POST /api/assets
exports.createAsset = async (req, res) => {
  try {
    const { 
      asset_tag, serial_number, status, purchase_date, 
      category_id, vendor_id, location_id, dept_id 
    } = req.body;
    
    const newAsset = await pool.query(
      `INSERT INTO assets 
      (asset_tag, serial_number, status, purchase_date, category_id, vendor_id, location_id, dept_id) 
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *`,
      [asset_tag, serial_number, status, purchase_date, category_id, vendor_id, location_id, dept_id]
    );

    res.status(201).json({ message: "Asset created successfully", data: newAsset.rows[0] });
  } catch (err) {
    console.error("Error creating asset:", err.message);
    if (err.code === '23505') {
      return res.status(400).json({ error: "Asset with this tag already exists. Please use a different tag." });
    }
    res.status(500).json({ error: "Server Error", details: err.message });
  }
};

// @desc    Get all assets
// @route   GET /api/assets
exports.getAllAssets = async (req, res) => {
  try {
    const allAssets = await pool.query('SELECT * FROM assets');
    res.status(200).json(allAssets.rows);
  } catch (err) {
    console.error("Error fetching assets:", err.message);
    res.status(500).json({ error: "Server Error" });
  }
};

// @desc    Update an asset
// @route   PUT /api/assets/:id
exports.updateAsset = async (req, res) => {
  try {
    const { id } = req.params;
    const { 
      asset_tag, serial_number, status, purchase_date, 
      category_id, vendor_id, location_id, dept_id 
    } = req.body;

    // Check if asset exists
    const assetExists = await pool.query('SELECT * FROM assets WHERE asset_id = $1', [id]);
    if (assetExists.rows.length === 0) {
      return res.status(404).json({ message: "Asset not found" });
    }

    const updatedAsset = await pool.query(
      `UPDATE assets 
       SET asset_tag = $1, serial_number = $2, status = $3, purchase_date = $4, 
           category_id = $5, vendor_id = $6, location_id = $7, dept_id = $8
       WHERE asset_id = $9 RETURNING *`,
      [asset_tag, serial_number, status, purchase_date, category_id, vendor_id, location_id, dept_id, id]
    );

    res.status(200).json({ message: "Asset updated successfully", data: updatedAsset.rows[0] });
  } catch (err) {
    console.error("Error updating asset:", err.message);
    if (err.code === '23505') {
      return res.status(400).json({ error: "Asset tag already exists." });
    }
    res.status(500).json({ error: "Server Error" });
  }
};

// @desc    Delete an asset
// @route   DELETE /api/assets/:id
exports.deleteAsset = async (req, res) => {
  try {
    const { id } = req.params;

    const deletedAsset = await pool.query('DELETE FROM assets WHERE asset_id = $1 RETURNING *', [id]);

    if (deletedAsset.rows.length === 0) {
      return res.status(404).json({ message: "Asset not found" });
    }

    res.status(200).json({ message: "Asset deleted successfully" });
  } catch (err) {
    console.error("Error deleting asset:", err.message);
    res.status(500).json({ error: "Server Error" });
  }
};