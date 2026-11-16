const express = require('express');
const router = express.Router();
const departmentController = require('../controllers/departmentController');
const authMiddleware = require('../middleware/authMiddleware');
const checkRole = require('../middleware/roleMiddleware');

/**
 * @swagger
 * tags:
 *   name: Departments
 *   description: Organization Management APIs
 */

/**
 * @swagger
 * /api/departments:
 *   post:
 *     summary: Create a new department (Admin Only)
 *     tags: [Departments]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - department_name
 *             properties:
 *               department_name:
 *                 type: string
 *                 example: IT Department
 *               location_id:
 *                 type: string
 *                 format: uuid
 *                 description: Optional Foreign Key to Location
 *     responses:
 *       201:
 *         description: Department created
 *       403:
 *         description: Forbidden (Requires Admin)
 * 
 *   get:
 *     summary: Get all departments
 *     tags: [Departments]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of departments
 */
router.post('/', authMiddleware, checkRole('Admin'), departmentController.createDepartment);
router.get('/', authMiddleware, departmentController.getAllDepartments);

module.exports = router;