const express = require('express');
const router = express.Router();
const {
  layTatCaKhoa,
  layKhoaTheoID,
  timKiemKhoa
} = require('../controllers/khoaController');

// Routes cho khoa - /search must come before /:id
router.get('/search', timKiemKhoa);        // GET /api/khoa/search?tuKhoa=xxx
router.get('/', layTatCaKhoa);             // GET /api/khoa
router.get('/:id', layKhoaTheoID);         // GET /api/khoa/:id

module.exports = router;