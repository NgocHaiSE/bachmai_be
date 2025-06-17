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
// IMPORTANT: /search routes must come BEFORE /:id routes
router.get('/yeu-cau/search', timKiemPhieuYeuCauChuyenVien);
router.post('/yeu-cau', themPhieuYeuCauChuyenVien);
router.get('/yeu-cau/:id', layPhieuYeuCauChuyenVienTheoID);
router.put('/yeu-cau/:id', suaPhieuYeuCauChuyenVien);
router.patch('/yeu-cau/:id/xu-ly', xuLyPhieuYeuCauChuyenVien);
router.delete('/yeu-cau/:id', xoaPhieuYeuCauChuyenVien);

// ===== PHIẾU CHUYỂN VIỆN =====
// IMPORTANT: /search routes must come BEFORE /:id routes
router.get('/phieu/search', timKiemPhieuChuyenVien);
router.post('/phieu', taoPhieuChuyenVien);
router.get('/phieu/:id', layPhieuChuyenVienTheoID);
router.put('/phieu/:id', suaPhieuChuyenVien);
router.patch('/phieu/:id/trang-thai', capNhatTrangThaiChuyenVien);
router.delete('/phieu/:id', xoaPhieuChuyenVien);

module.exports = router;