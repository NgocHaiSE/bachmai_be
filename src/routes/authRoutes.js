const express = require('express');
const router = express.Router();
const {
  login,
  logout,
  checkAuth,
  changePassword
} = require('../controllers/authController');

// Routes xác thực
router.post('/login', login);           // POST /api/auth/login
router.post('/logout', logout);         // POST /api/auth/logout
router.get('/check', checkAuth);        // GET /api/auth/check
router.post('/change-password', changePassword); // POST /api/auth/change-password

module.exports = router;