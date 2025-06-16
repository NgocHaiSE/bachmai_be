const express = require('express');
const router = express.Router();
const {
  themBenhNhan,
  layTatCaBenhNhan,
  timKiemBenhNhan,
  layBenhNhanTheoID
} = require('../controllers/benhNhanController');

// Routes cho bệnh nhân
router.post('/', themBenhNhan);                    // POST /api/benh-nhan - Thêm bệnh nhân mới
router.get('/', layTatCaBenhNhan);                 // GET /api/benh-nhan - Lấy tất cả bệnh nhân
router.get('/search', timKiemBenhNhan);            // GET /api/benh-nhan/search?tuKhoa=xxx - Tìm kiếm bệnh nhân
router.get('/:id', layBenhNhanTheoID);             // GET /api/benh-nhan/:id - Lấy bệnh nhân theo ID

module.exports = router;