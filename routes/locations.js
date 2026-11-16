const express = require('express');
const router = express.Router();
const locationController = require('../controllers/locationController');
const authMiddleware = require('../middleware/authMiddleware');
const checkRole = require('../middleware/roleMiddleware');

/**
 * @swagger
 * tags:
 *   name: Locations
 *   description: Location Management APIs
 */

/**
 * @swagger
 * /api/locations:
 *   post:
 *     summary: Create a new location (Admin Only)
 *     tags: [Locations]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - building
 *             properties:
 *               building:
 *                 type: string
 *                 example: Main HQ
 *               floor:
 *                 type: string
 *                 example: 2nd Floor
 *               room:
 *                 type: string
 *                 example: Room 201
 *     responses:
 *       201:
 *         description: Location created successfully
 *       400:
 *         description: Validation error
 *   get:
 *     summary: Get all locations
 *     tags: [Locations]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of locations
 */
router.post('/', authMiddleware, checkRole('Admin'), locationController.createLocation);
router.get('/', authMiddleware, locationController.getAllLocations);

module.exports = router;