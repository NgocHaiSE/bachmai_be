const express = require('express');
const router = express.Router();
const {
  // Yêu cầu chuyển viện
  themPhieuYeuCauChuyenVien,
  suaPhieuYeuCauChuyenVien,
  xuLyPhieuYeuCauChuyenVien,
  xoaPhieuYeuCauChuyenVien,
  layPhieuYeuCauChuyenVienTheoID,
  timKiemPhieuYeuCauChuyenVien,
  
  // Phiếu chuyển viện
  taoPhieuChuyenVien,
  suaPhieuChuyenVien,
  capNhatTrangThaiChuyenVien,
  xoaPhieuChuyenVien,
  layPhieuChuyenVienTheoID,
  timKiemPhieuChuyenVien
} = require('../controllers/chuyenVienController');

// ===== YÊU CẦU CHUYỂN VIỆN =====
// Routes cho yêu cầu chuyển viện
router.post('/yeu-cau', themPhieuYeuCauChuyenVien);                    // POST /api/chuyen-vien/yeu-cau - Thêm yêu cầu chuyển viện
router.put('/yeu-cau/:id', suaPhieuYeuCauChuyenVien);                  // PUT /api/chuyen-vien/yeu-cau/:id - Sửa yêu cầu chuyển viện
router.patch('/yeu-cau/:id/xu-ly', xuLyPhieuYeuCauChuyenVien);         // PATCH /api/chuyen-vien/yeu-cau/:id/xu-ly - Xử lý yêu cầu (duyệt/từ chối)
router.delete('/yeu-cau/:id', xoaPhieuYeuCauChuyenVien);               // DELETE /api/chuyen-vien/yeu-cau/:id - Xóa yêu cầu chuyển viện
router.get('/yeu-cau/search', timKiemPhieuYeuCauChuyenVien);           // GET /api/chuyen-vien/yeu-cau/search - Tìm kiếm yêu cầu chuyển viện
router.get('/yeu-cau/:id', layPhieuYeuCauChuyenVienTheoID);            // GET /api/chuyen-vien/yeu-cau/:id - Lấy yêu cầu chuyển viện theo ID

// ===== PHIẾU CHUYỂN VIỆN =====
// Routes cho phiếu chuyển viện
router.post('/phieu', taoPhieuChuyenVien);                             // POST /api/chuyen-vien/phieu - Tạo phiếu chuyển viện
router.put('/phieu/:id', suaPhieuChuyenVien);                          // PUT /api/chuyen-vien/phieu/:id - Sửa phiếu chuyển viện
router.patch('/phieu/:id/trang-thai', capNhatTrangThaiChuyenVien);     // PATCH /api/chuyen-vien/phieu/:id/trang-thai - Cập nhật trạng thái
router.delete('/phieu/:id', xoaPhieuChuyenVien);                       // DELETE /api/chuyen-vien/phieu/:id - Xóa phiếu chuyển viện
router.get('/phieu/search', timKiemPhieuChuyenVien);                   // GET /api/chuyen-vien/phieu/search - Tìm kiếm phiếu chuyển viện
router.get('/phieu/:id', layPhieuChuyenVienTheoID);                    // GET /api/chuyen-vien/phieu/:id - Lấy phiếu chuyển viện theo ID

module.exports = router;