const express = require('express');
const router = express.Router();
const {
  // Đơn thuốc
  themDonThuoc,
  suaDonThuoc,
  xoaDonThuoc,
  xacNhanThanhToanDonThuoc,
  layDonThuocTheoID,
  timKiemDonThuoc,
  
  // Chi tiết đơn thuốc
  themChiTietDonThuoc,
  suaChiTietDonThuoc,
  xoaChiTietDonThuoc,
  layChiTietDonThuoc
} = require('../controllers/donThuocController');

// ===== ĐƠN THUỐC =====
// Routes cho đơn thuốc
router.post('/', themDonThuoc);                                        // POST /api/don-thuoc - Thêm đơn thuốc
router.put('/:id', suaDonThuoc);                                       // PUT /api/don-thuoc/:id - Sửa đơn thuốc
router.delete('/:id', xoaDonThuoc);                                    // DELETE /api/don-thuoc/:id - Xóa đơn thuốc
router.patch('/:id/thanh-toan', xacNhanThanhToanDonThuoc);             // PATCH /api/don-thuoc/:id/thanh-toan - Xác nhận thanh toán
router.get('/search', timKiemDonThuoc);                                // GET /api/don-thuoc/search - Tìm kiếm đơn thuốc
router.get('/:id', layDonThuocTheoID);                                 // GET /api/don-thuoc/:id - Lấy đơn thuốc theo ID

// ===== CHI TIẾT ĐƠN THUỐC =====
// Routes cho chi tiết đơn thuốc
router.post('/chi-tiet', themChiTietDonThuoc);                         // POST /api/don-thuoc/chi-tiet - Thêm chi tiết đơn thuốc
router.put('/chi-tiet/:idDonThuoc/:idDuocPham', suaChiTietDonThuoc);   // PUT /api/don-thuoc/chi-tiet/:idDonThuoc/:idDuocPham - Sửa chi tiết
router.delete('/chi-tiet/:idDonThuoc/:idDuocPham', xoaChiTietDonThuoc); // DELETE /api/don-thuoc/chi-tiet/:idDonThuoc/:idDuocPham - Xóa chi tiết
router.get('/:id/chi-tiet', layChiTietDonThuoc);                       // GET /api/don-thuoc/:id/chi-tiet - Lấy chi tiết đơn thuốc

module.exports = router;