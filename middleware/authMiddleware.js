const jwt = require('jsonwebtoken');

/**
 * Middleware to verify JWT Token
 * It checks if the request header contains a valid token.
 */
module.exports = function (req, res, next) {
  // 1. Get token from the request header
  const authHeader = req.header('Authorization');

  // 2. Check if token exists
  if (!authHeader) {
    return res.status(401).json({ message: 'Access Denied: No token provided' });
  }

  try {
    // 3. Extract token (Format is usually: "Bearer <token>")
    const token = authHeader.split(" ")[1];
    if (!token) {
      return res.status(401).json({ message: 'Access Denied: Invalid token format' });
    }

    // 4. Verify the token using the secret key
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // 5. Attach user info to request object for further use
    req.user = decoded;
    
    // 6. Proceed to the next middleware or controller
    next();
  } catch (err) {
    res.status(401).json({ message: 'Access Denied: Token is invalid or expired' });
  }
};