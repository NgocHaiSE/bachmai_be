const express = require('express');
const router = express.Router();
const {
  themPhieuDangKyKham,
  suaPhieuDangKyKham,
  capNhatTrangThaiPhieuKham,
  xoaPhieuDangKyKham,
  layPhieuDangKyKhamTheoID,
  timKiemPhieuDangKyKham
} = require('../controllers/pdkKhamController');

// Routes cho phiếu đăng ký khám
router.post('/', themPhieuDangKyKham);                           // POST /api/pdk-kham - Thêm phiếu đăng ký khám
router.put('/:id', suaPhieuDangKyKham);                          // PUT /api/pdk-kham/:id - Sửa phiếu đăng ký khám
router.patch('/:id/trang-thai', capNhatTrangThaiPhieuKham);      // PATCH /api/pdk-kham/:id/trang-thai - Cập nhật trạng thái
router.delete('/:id', xoaPhieuDangKyKham);                       // DELETE /api/pdk-kham/:id - Xóa phiếu đăng ký khám
router.get('/search', timKiemPhieuDangKyKham);                   // GET /api/pdk-kham/search - Tìm kiếm phiếu đăng ký khám
router.get('/:id', layPhieuDangKyKhamTheoID);                    // GET /api/pdk-kham/:id - Lấy phiếu đăng ký khám theo ID

module.exports = router;