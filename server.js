const express = require('express');
const cors = require('cors');
const pool = require('./config/db');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./swagger');
require('dotenv').config();

const app = express();

// --- Middleware ---
app.use(cors()); // Allows frontend to make requests
app.use(express.json()); // Parses incoming JSON requests

// --- Swagger Documentation Setup ---
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// --- Import Routes ---
const authRoutes = require('./routes/auth');
const assetRoutes = require('./routes/assets');

// --- Use Routes ---
app.use('/api/auth', authRoutes);
app.use('/api/assets', assetRoutes);

// --- Test Route for Database Connection ---
app.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.json({ 
      message: "Asset Management API is running perfectly!", 
      db_time: result.rows[0].now 
    });
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Database connection error");
  }
});

// --- Start Server ---
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`Swagger Docs available at http://localhost:${PORT}/api-docs`);
});