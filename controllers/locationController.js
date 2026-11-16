const pool = require('../config/db');

// @desc    Create a new location
// @route   POST /api/locations
exports.createLocation = async (req, res) => {
  try {
    const { building, floor, room } = req.body;

    // Validation: Check if building is provided
    if (!building) {
      return res.status(400).json({ message: "Building name is required" });
    }

    const newLocation = await pool.query(
      'INSERT INTO locations (building, floor, room) VALUES ($1, $2, $3) RETURNING *',
      [building, floor || null, room || null]
    );

    res.status(201).json({ 
      message: "Location created successfully", 
      data: newLocation.rows[0] 
    });
  } catch (err) {
    console.error("Error creating location:", err.message);
    res.status(500).json({ error: "Server Error" });
  }
};

// @desc    Get all locations
// @route   GET /api/locations
exports.getAllLocations = async (req, res) => {
  try {
    const allLocations = await pool.query('SELECT * FROM locations ORDER BY building ASC');
    res.status(200).json(allLocations.rows);
  } catch (err) {
    console.error("Error fetching locations:", err.message);
    res.status(500).json({ error: "Server Error" });
  }
};