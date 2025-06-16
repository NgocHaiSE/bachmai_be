const express = require('express');
const router = express.Router();
const {
  layChiTietDuocPham,
  timKiemDuocPham,
  layTatCaDuocPham,
  layDuocPhamConHang,
  layDuocPhamHetHan,
  layDuocPhamTheoLoai,
  layDuocPhamTheoNCC
} = require('../controllers/duocPhamController');

// Routes cho dược phẩm
router.get('/', layTatCaDuocPham);                                   // GET /api/duoc-pham - Lấy tất cả dược phẩm
router.get('/search', timKiemDuocPham);                              // GET /api/duoc-pham/search - Tìm kiếm dược phẩm
router.get('/con-hang', layDuocPhamConHang);                         // GET /api/duoc-pham/con-hang - Lấy dược phẩm còn hàng
router.get('/het-han', layDuocPhamHetHan);                           // GET /api/duoc-pham/het-han - Lấy dược phẩm hết hạn
router.get('/loai/:idLoaiDuocPham', layDuocPhamTheoLoai);            // GET /api/duoc-pham/loai/:idLoaiDuocPham - Lấy dược phẩm theo loại
router.get('/ncc/:idNCC', layDuocPhamTheoNCC);                       // GET /api/duoc-pham/ncc/:idNCC - Lấy dược phẩm theo nhà cung cấp
router.get('/:id', layChiTietDuocPham);                              // GET /api/duoc-pham/:id - Lấy chi tiết dược phẩm theo ID

module.exports = router;