const express = require('express');
const router = express.Router();
const employeeController = require('../controllers/employeeController');
const authMiddleware = require('../middleware/authMiddleware');
const checkRole = require('../middleware/roleMiddleware');

/**
 * @swagger
 * tags:
 *   name: Employees
 *   description: Employee & Manager Management APIs
 */

/**
 * @swagger
 * /api/employees:
 *   post:
 *     summary: Create a new Employee or Manager (Admin Only)
 *     tags: [Employees]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 example: Ali Khan
 *               contact:
 *                 type: string
 *                 example: "03001234567"
 *               cnic:
 *                 type: string
 *                 example: "42101-1234567-1"
 *               joining_date:
 *                 type: string
 *                 format: date
 *                 example: "2023-10-25"
 *               designation:
 *                 type: string
 *                 example: "Software Engineer"
 *               address:
 *                 type: string
 *                 example: "House 123, Street 4, Karachi"
 *               emergency_contact:
 *                 type: string
 *                 example: "03119876543"
 *               email:
 *                 type: string
 *                 example: ali@techavenue.com
 *               password:
 *                 type: string
 *                 example: "Employee@123"
 *               department_id:
 *                 type: string
 *                 format: uuid
 *               role_name:
 *                 type: string
 *                 example: Manager
 *               manager_id:
 *                 type: string
 *                 format: uuid
 *                 description: Optional (Assign a manager to this employee)
 *     responses:
 *       201:
 *         description: Employee created
 *   get:
 *     summary: Get all employees
 *     tags: [Employees]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of employees
 */
router.post('/', authMiddleware, checkRole('Admin'), employeeController.createEmployee);
router.get('/', authMiddleware, employeeController.getAllEmployees);

/**
 * @swagger
 * /api/employees/{id}:
 *   put:
 *     summary: Update an employee (Admin Only)
 *     tags: [Employees]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               contact:
 *                 type: string
 *               address:
 *                 type: string
 *               department_id:
 *                 type: string
 *               role_name:
 *                 type: string
 *     responses:
 *       200:
 *         description: Employee updated
 *   delete:
 *     summary: Delete an employee (Admin Only) - Only if no records
 *     tags: [Employees]
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
 *         description: Employee deleted
 *       400:
 *         description: Employee has records, suspend instead
 */
router.put('/:id', authMiddleware, checkRole('Admin'), employeeController.updateEmployee);

/**
 * @swagger
 * /api/employees/{id}/status:
 *   put:
 *     summary: Suspend or Activate an employee (Admin Only)
 *     tags: [Employees]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - status
 *             properties:
 *               status:
 *                 type: string
 *                 enum: [Active, Suspended]
 *                 example: Suspended
 *     responses:
 *       200:
 *         description: Employee status updated
 *       404:
 *         description: Employee not found
 */
router.put('/:id/status', authMiddleware, checkRole('Admin'), employeeController.updateEmployeeStatus);

router.delete('/:id', authMiddleware, checkRole('Admin'), employeeController.deleteEmployee);

module.exports = router;