const express = require('express');
const cors = require('cors');
const pool = require('./config/db');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./swagger');
const departmentRoutes = require('./routes/departments'); 
const vendorRoutes = require('./routes/vendors');
const categoryRoutes = require('./routes/categories');
const locationRoutes = require('./routes/locations');
const employeeRoutes = require('./routes/employees'); 
const settingsRoutes = require('./routes/settings'); 

require('dotenv').config();

const app = express();

// --- Middleware ---
app.use(cors()); 
app.use(express.json()); 

// --- Swagger Documentation Setup ---
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// --- Import Routes ---
const authRoutes = require('./routes/auth');
const assetRoutes = require('./routes/assets');

// --- Use Routes ---
app.use('/api/auth', authRoutes);
app.use('/api/assets', assetRoutes);
app.use('/api/departments', departmentRoutes); 
app.use('/api/vendors', vendorRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/locations', locationRoutes);
app.use('/api/employees', employeeRoutes);
app.use('/api/assignments', require('./routes/assignments'));
app.use('/api/requests', require('./routes/requests'));
app.use('/api/settings', settingsRoutes); // 🌟 YEH NAYI LINE ADD KI HAI
app.use(express.json({ limit: '50mb' })); // Pehle sirf app.use(express.json()) tha
app.use(express.urlencoded({ limit: '50mb', extended: true }));
app.use('/api/returns', require('./routes/returns'));

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