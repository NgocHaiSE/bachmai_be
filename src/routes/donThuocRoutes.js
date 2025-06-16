const express = require('express');
const router = express.Router();
const {
  themDonThuoc,
  suaDonThuoc,
  xoaDonThuoc,
  xacNhanThanhToanDonThuoc,
  layDonThuocTheoID,
  timKiemDonThuoc,
  themChiTietDonThuoc,
  layChiTietDonThuoc
} = require('../controllers/donThuocController');

// Routes cho đơn thuốc
router.get('/search', timKiemDonThuoc);
router.get('/:id/chi-tiet', layChiTietDonThuoc);
router.get('/:id', layDonThuocTheoID);
router.post('/', themDonThuoc);
router.put('/:id', suaDonThuoc);
router.delete('/:id', xoaDonThuoc);
router.patch('/:id/thanh-toan', xacNhanThanhToanDonThuoc);

// Chi tiết đơn thuốc
router.post('/chi-tiet', themChiTietDonThuoc);

module.exports = router;