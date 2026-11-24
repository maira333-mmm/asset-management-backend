const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { body, validationResult } = require('express-validator');
const pool = require('../config/db');

/**
 * @swagger
 * tags:
 *   name: Auth
 *   description: User Authentication APIs
 */

/**
 * @swagger
 * /api/auth/signup:
 *   post:
 *     summary: Register a new user
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - password
 *             properties:
 *               email:
 *                 type: string
 *                 example: maira@test.com
 *               password:
 *                 type: string
 *                 example: Admin@123
 *     responses:
 *       201:
 *         description: User registered successfully
 *       400:
 *         description: Validation error or user already exists
 *       500:
 *         description: Internal Server Error
 */
router.post('/signup', 
  [
    // 1. Email Validation
    body('email')
      .isEmail().withMessage('Please provide a valid email address')
      .normalizeEmail(),
      
    // 2. Password Validation (8 chars, 1 uppercase, 1 number, 1 special char)
    body('password')
      .isLength({ min: 8 }).withMessage('Password must be at least 8 characters long')
      .matches(/[A-Z]/).withMessage('Password must contain at least one uppercase letter')
      .matches(/[0-9]/).withMessage('Password must contain at least one number')
      .matches(/[!@#$%^&*(),.?":{}|<>]/).withMessage('Password must contain at least one special character')
  ],
  async (req, res) => {
    // Check if validation failed
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    try {
      const { email, password } = req.body;

      // Check if email already exists in DB
      const userExists = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
      if (userExists.rows.length > 0) {
        return res.status(400).json({ message: "User with this email already exists" });
      }

      // Hash password and insert (default status = Active)
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(password, salt);
      const newUser = await pool.query(
        'INSERT INTO users (email, password_hash, status) VALUES ($1, $2, $3) RETURNING user_id, email, status',
        [email, hashedPassword, 'Active']
      );

      res.status(201).json({ message: "User registered successfully", user: newUser.rows[0] });
    } catch (err) {
      console.error(err.message);
      res.status(500).json({ error: "Server Error" });
    }
});

/**
 * @swagger
 * /api/auth/login:
 *   post:
 *     summary: Login a user and get a JWT token
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - password
 *             properties:
 *               email:
 *                 type: string
 *                 example: maira@test.com
 *               password:
 *                 type: string
 *                 example: Admin@123
 *     responses:
 *       200:
 *         description: Logged in successfully, returns JWT token
 *       400:
 *         description: Invalid credentials
 *       403:
 *         description: Account suspended
 *       500:
 *         description: Internal Server Error
 */
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ message: "Email and password are required" });
    }

    const user = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
    if (user.rows.length === 0) return res.status(400).json({ message: "Invalid credentials" });

    const validPassword = await bcrypt.compare(password, user.rows[0].password_hash);
    if (!validPassword) return res.status(400).json({ message: "Invalid credentials" });

    // ✅ Suspended account check
    if (user.rows[0].status === 'Suspended') {
      return res.status(403).json({ message: "Your account has been suspended. Contact Admin." });
    }

    const token = jwt.sign(
      { user_id: user.rows[0].user_id, email: user.rows[0].email },
      process.env.JWT_SECRET,
      { expiresIn: "1h" }
    );

    res.status(200).json({ message: "Logged in successfully", token });
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ error: "Server Error" });
  }
});

module.exports = router;