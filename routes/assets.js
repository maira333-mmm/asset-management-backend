/**
 * @swagger
 * tags:
 *   name: Assets
 *   description: Asset Management APIs
 */

/**
 * @swagger
 * /api/assets:
 *   post:
 *     summary: Register a new asset in the system
 *     tags: [Assets]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - asset_tag
 *               - serial_number
 *             properties:
 *               asset_tag:
 *                 type: string
 *                 example: LAP-001
 *               serial_number:
 *                 type: string
 *                 example: SN-998877
 *               status:
 *                 type: string
 *                 example: Available
 *               purchase_date:
 *                 type: string
 *                 format: date
 *                 example: "2023-10-25"
 *               category_id:
 *                 type: string
 *                 format: uuid
 *                 description: Foreign Key to AssetCategory
 *               vendor_id:
 *                 type: string
 *                 format: uuid
 *                 description: Foreign Key to Vendor
 *               location_id:
 *                 type: string
 *                 format: uuid
 *                 description: Foreign Key to Location
 *               dept_id:
 *                 type: string
 *                 format: uuid
 *                 description: Foreign Key to Department
 *     responses:
 *       201:
 *         description: Asset created successfully
 *       401:
 *         description: Unauthorized (Invalid or missing token)
 *       500:
 *         description: Internal Server Error
 * 
 *   get:
 *     summary: Get a list of all assets
 *     tags: [Assets]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: A JSON array of assets
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Server Error
 */

const express = require('express');
const router = express.Router();
const assetController = require('../controllers/assetController');
const authMiddleware = require('../middleware/authMiddleware'); // Standard variable name

// @route   POST /api/assets
// @desc    Create a new asset record
// @access  Private (Requires JWT Token)
router.post('/', authMiddleware, assetController.createAsset);

// @route   GET /api/assets
// @desc    Retrieve all asset records
// @access  Private (Requires JWT Token)
router.get('/', authMiddleware, assetController.getAllAssets);

module.exports = router;