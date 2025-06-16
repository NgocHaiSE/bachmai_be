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

// Routes cho người dùng
router.get('/', getAllUsers);                    // GET /api/users - Lấy tất cả người dùng
router.get('/search', searchUsers);              // GET /api/users/search - Tìm kiếm người dùng
router.get('/:id', getUserById);                 // GET /api/users/:id - Lấy người dùng theo ID
router.post('/', createUser);                    // POST /api/users - Tạo người dùng mới
router.put('/:id', updateUser);                  // PUT /api/users/:id - Cập nhật người dùng
router.delete('/:id', deleteUser);               // DELETE /api/users/:id - Xóa người dùng

// Route đăng nhập
router.post('/login', login);                    // POST /api/users/login - Đăng nhập

module.exports = router;