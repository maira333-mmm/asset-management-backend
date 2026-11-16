const pool = require('../config/db');

// @desc    Create a new category
// @route   POST /api/categories
exports.createCategory = async (req, res) => {
  try {
    const { category_name, parent_id } = req.body;

    // Validation: Name is required
    if (!category_name) {
      return res.status(400).json({ message: "Category name is required" });
    }

    const newCategory = await pool.query(
      'INSERT INTO asset_categories (category_name, parent_id) VALUES ($1, $2) RETURNING *',
      [category_name, parent_id || null]
    );

    res.status(201).json({ 
      message: "Category created successfully", 
      data: newCategory.rows[0] 
    });
  } catch (err) {
    console.error("Error creating category:", err.message);
    
    // Handle duplicate category name
    if (err.code === '23505') {
      return res.status(400).json({ message: "Category with this name already exists" });
    }
    
    res.status(500).json({ error: "Server Error" });
  }
};

// @desc    Get all categories
// @route   GET /api/categories
exports.getAllCategories = async (req, res) => {
  try {
    const allCategories = await pool.query('SELECT * FROM asset_categories ORDER BY category_name ASC');
    res.status(200).json(allCategories.rows);
  } catch (err) {
    console.error("Error fetching categories:", err.message);
    res.status(500).json({ error: "Server Error" });
  }
};