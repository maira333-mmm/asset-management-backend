const express = require('express');
const router = express.Router();
const departmentController = require('../controllers/departmentController');
const authMiddleware = require('../middleware/authMiddleware');
const checkRole = require('../middleware/roleMiddleware');

/**
 * @swagger
 * tags:
 *   name: Departments
 *   description: Department Management APIs
 */

/**
 * @swagger
 * /api/departments:
 *   get:
 *     summary: Get all departments
 *     tags: [Departments]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of departments
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
 *     responses:
 *       201:
 *         description: Department created
 */
router.get('/', authMiddleware, departmentController.getAllDepartments);
router.post('/', authMiddleware, checkRole('Admin'), departmentController.createDepartment);

/**
 * @swagger
 * /api/departments/{id}:
 *   delete:
 *     summary: Delete a department (Admin Only)
 *     tags: [Departments]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Department deleted
 *       400:
 *         description: Cannot delete if employees or assets are assigned
 *       404:
 *         description: Department not found
 */
router.delete('/:id', authMiddleware, checkRole('Admin'), departmentController.deleteDepartment);

module.exports = router;