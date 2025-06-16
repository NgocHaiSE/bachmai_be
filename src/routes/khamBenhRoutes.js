const express = require('express');
const router = express.Router();
const {
  layChiTietPhieuKham,
  timKiemPhieuKham
} = require('../controllers/khamBenhController');

// Routes cho phiếu khám bệnh
router.get('/search', timKiemPhieuKham);                             // GET /api/kham-benh/search - Tìm kiếm phiếu khám
router.get('/:id', layChiTietPhieuKham);                             // GET /api/kham-benh/:id - Lấy chi tiết phiếu khám theo ID

module.exports = router;