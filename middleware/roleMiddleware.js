const pool = require('../config/db');

/**
 * Middleware to check if the authenticated user has the required role.
 * @param {string} requiredRole - The role needed to access the route (e.g., 'Admin')
 */
const checkRole = (requiredRole) => {
  return async (req, res, next) => {
    try {
      // req.user.user_id comes from the authMiddleware (JWT token)
      const userId = req.user.user_id;

      // SQL Query to get the user's role from the database
      const query = `
        SELECT r.role_name 
        FROM users u
        JOIN user_roles ur ON u.user_id = ur.user_id
        JOIN roles r ON ur.role_id = r.role_id
        WHERE u.user_id = $1
      `;
      
      const result = await pool.query(query, [userId]);

      // If user has no role assigned
      if (result.rows.length === 0) {
        return res.status(403).json({ message: "Access Denied: No role assigned to this user" });
      }

      const userRole = result.rows[0].role_name;

      // Check if the user's role matches the required role
      if (userRole !== requiredRole) {
        return res.status(403).json({ message: `Access Denied: Requires ${requiredRole} role` });
      }

      // User has the correct role, proceed to the next handler
      next(); 
    } catch (err) {
      console.error("Role Middleware Error:", err.message);
      res.status(500).json({ error: "Server Error in Role Verification" });
    }
  };
};

module.exports = checkRole;