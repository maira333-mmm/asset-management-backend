const express = require('express');
const router = express.Router();
const categoryController = require('../controllers/categoryController');
const authMiddleware = require('../middleware/authMiddleware');
const checkRole = require('../middleware/roleMiddleware');

/**
 * @swagger
 * tags:
 *   name: Categories
 *   description: Asset Category Management APIs
 */

/**
 * @swagger
 * /api/categories:
 *   post:
 *     summary: Create a new asset category (Admin Only)
 *     tags: [Categories]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - category_name
 *             properties:
 *               category_name:
 *                 type: string
 *                 example: Laptop
 *               parent_id:
 *                 type: string
 *                 format: uuid
 *                 description: Optional ID for parent category (for sub-categories)
 *     responses:
 *       201:
 *         description: Category created successfully
 *       400:
 *         description: Validation error or duplicate category
 *   get:
 *     summary: Get all categories
 *     tags: [Categories]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of categories
 */
router.post('/', authMiddleware, checkRole('Admin'), categoryController.createCategory);
router.get('/', authMiddleware, categoryController.getAllCategories);

module.exports = router;