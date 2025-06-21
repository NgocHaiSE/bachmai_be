// src/routes/donThuocRoutes.js - Updated
const express = require('express');
const router = express.Router();
const {
  timKiemDonThuoc,
  layTatCaDonThuoc,
  layDonThuocTheoID,
  themDonThuoc,
  suaDonThuoc,
  xoaDonThuoc,
  xacNhanThanhToanDonThuoc,
  layChiTietDonThuoc,
  themChiTietDonThuoc,
  layDanhSachBacSi,
  layDanhSachBenhNhan
} = require('../controllers/donThuocController');

// Routes cho đơn thuốc
router.get('/', layTatCaDonThuoc);                               // GET /api/don-thuoc - Lấy tất cả đơn thuốc
router.get('/search', timKiemDonThuoc);                          // GET /api/don-thuoc/search - Tìm kiếm đơn thuốc
router.get('/bac-si', layDanhSachBacSi);                         // GET /api/don-thuoc/bac-si - Lấy danh sách bác sĩ
router.get('/benh-nhan', layDanhSachBenhNhan);                   // GET /api/don-thuoc/benh-nhan - Lấy danh sách bệnh nhân
router.get('/:id/chi-tiet', layChiTietDonThuoc);                 // GET /api/don-thuoc/:id/chi-tiet - Lấy chi tiết đơn thuốc
router.get('/:id', layDonThuocTheoID);                           // GET /api/don-thuoc/:id - Lấy đơn thuốc theo ID
router.post('/', themDonThuoc);                                  // POST /api/don-thuoc - Tạo đơn thuốc mới
router.put('/:id', suaDonThuoc);                                 // PUT /api/don-thuoc/:id - Sửa đơn thuốc
router.delete('/:id', xoaDonThuoc);                              // DELETE /api/don-thuoc/:id - Xóa đơn thuốc
router.patch('/:id/thanh-toan', xacNhanThanhToanDonThuoc);       // PATCH /api/don-thuoc/:id/thanh-toan - Xác nhận thanh toán

// Chi tiết đơn thuốc
router.post('/chi-tiet', themChiTietDonThuoc);                   // POST /api/don-thuoc/chi-tiet - Thêm chi tiết đơn thuốc

module.exports = router;