const express = require('express');
const router = express.Router();
const vendorController = require('../controllers/vendorController');
const authMiddleware = require('../middleware/authMiddleware');
const checkRole = require('../middleware/roleMiddleware');

/**
 * @swagger
 * tags:
 *   name: Vendors
 *   description: Vendor Management APIs
 */

/**
 * @swagger
 * /api/vendors:
 *   post:
 *     summary: Create a new vendor (Admin Only)
 *     tags: [Vendors]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - vendor_name
 *             properties:
 *               vendor_name:
 *                 type: string
 *                 example: Tech Solutions Ltd
 *               email:
 *                 type: string
 *                 example: contact@techsolutions.com
 *               phone:
 *                 type: string
 *                 example: "03001234567"
 *     responses:
 *       201:
 *         description: Vendor created successfully
 *       400:
 *         description: Validation error or duplicate vendor
 *   get:
 *     summary: Get all vendors
 *     tags: [Vendors]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of vendors
 */
router.post('/', authMiddleware, checkRole('Admin'), vendorController.createVendor);
router.get('/', authMiddleware, vendorController.getAllVendors);

module.exports = router;