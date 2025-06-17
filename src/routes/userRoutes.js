const express = require('express');
const router = express.Router();
const {
  getAllUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
  login,
  searchUsers
} = require('../controllers/userController');

// Routes cho người dùng - specific routes before /:id
router.get('/', getAllUsers);              // GET /api/users
router.get('/search', searchUsers);        // GET /api/users/search
router.post('/', createUser);              // POST /api/users
router.post('/login', login);              // POST /api/users/login
router.get('/:id', getUserById);           // GET /api/users/:id
router.put('/:id', updateUser);            // PUT /api/users/:id
router.delete('/:id', deleteUser);         // DELETE /api/users/:id

module.exports = router;