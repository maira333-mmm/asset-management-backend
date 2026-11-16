const express = require('express');
const router = express.Router();
const assetController = require('../controllers/assetController');
const authMiddleware = require('../middleware/authMiddleware'); 
const checkRole = require('../middleware/roleMiddleware');

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
 *     summary: Create a new asset (Admin Only)
 *     tags: [Assets]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               asset_tag:
 *                 type: string
 *                 example: LAP-NEW-001
 *               serial_number:
 *                 type: string
 *                 example: SN-12345
 *               status:
 *                 type: string
 *                 example: Available
 *               purchase_date:
 *                 type: string
 *                 example: "2023-11-20"
 *               category_id:
 *                 type: string
 *                 format: uuid
 *               vendor_id:
 *                 type: string
 *                 format: uuid
 *               location_id:
 *                 type: string
 *                 format: uuid
 *               dept_id:
 *                 type: string
 *                 format: uuid
 *     responses:
 *       201:
 *         description: Asset created
 *   get:
 *     summary: Get all assets
 *     tags: [Assets]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of assets
 */
router.post('/', authMiddleware, checkRole('Admin'), assetController.createAsset);
router.get('/', authMiddleware, assetController.getAllAssets);

/**
 * @swagger
 * /api/assets/{id}:
 *   put:
 *     summary: Update an asset (Admin Only)
 *     tags: [Assets]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Asset ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               asset_tag:
 *                 type: string
 *               serial_number:
 *                 type: string
 *               status:
 *                 type: string
 *               purchase_date:
 *                 type: string
 *               category_id:
 *                 type: string
 *               vendor_id:
 *                 type: string
 *               location_id:
 *                 type: string
 *               dept_id:
 *                 type: string
 *     responses:
 *       200:
 *         description: Asset updated
 *   delete:
 *     summary: Delete an asset (Admin Only)
 *     tags: [Assets]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Asset ID
 *     responses:
 *       200:
 *         description: Asset deleted
 */
router.put('/:id', authMiddleware, checkRole('Admin'), assetController.updateAsset);
router.delete('/:id', authMiddleware, checkRole('Admin'), assetController.deleteAsset);

module.exports = router;