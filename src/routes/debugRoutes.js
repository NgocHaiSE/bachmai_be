// File: src/routes/debugRoutes.js
// Minimal routes chỉ để test basic functionality

const express = require('express');
const router = express.Router();

// Simple controller functions
const simpleController = (name) => (req, res) => {
  res.json({
    success: true,
    message: `${name} endpoint working`,
    method: req.method,
    path: req.path,
    timestamp: new Date().toISOString()
  });
};

// Basic routes without complex patterns
router.get('/', simpleController('Root'));
router.get('/test', simpleController('Test'));
router.post('/test', simpleController('Test POST'));

module.exports = router;