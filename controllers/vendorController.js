const pool = require('../config/db');

// @desc    Create a new vendor
// @route   POST /api/vendors
exports.createVendor = async (req, res) => {
  try {
    const { vendor_name, email, phone } = req.body;

    // Validation: Check if required field is empty
    if (!vendor_name) {
      return res.status(400).json({ message: "Vendor name is required" });
    }

    // Validation: Basic email format check (if provided)
    if (email && !email.includes('@')) {
      return res.status(400).json({ message: "Please provide a valid email address" });
    }

    const newVendor = await pool.query(
      'INSERT INTO vendors (vendor_name, email, phone) VALUES ($1, $2, $3) RETURNING *',
      [vendor_name, email || null, phone || null]
    );

    res.status(201).json({ 
      message: "Vendor created successfully", 
      data: newVendor.rows[0] 
    });
  } catch (err) {
    console.error("Error creating vendor:", err.message);
    
    // Handle duplicate vendor name error
    if (err.code === '23505') {
      return res.status(400).json({ message: "Vendor with this name already exists" });
    }
    
    res.status(500).json({ error: "Server Error" });
  }
};

// @desc    Get all vendors
// @route   GET /api/vendors
exports.getAllVendors = async (req, res) => {
  try {
    const allVendors = await pool.query('SELECT * FROM vendors ORDER BY vendor_name ASC');
    res.status(200).json(allVendors.rows);
  } catch (err) {
    console.error("Error fetching vendors:", err.message);
    res.status(500).json({ error: "Server Error" });
  }
};