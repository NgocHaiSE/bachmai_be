const express = require('express');
const router = express.Router();
const {
  themPhieuDangKyKham,
  suaPhieuDangKyKham,
  capNhatTrangThaiPhieuKham,
  xoaPhieuDangKyKham,
  layPhieuDangKyKhamTheoID,
  timKiemPhieuDangKyKham,
  layPhieuDangKyKham
} = require('../controllers/pdkKhamController');

// Routes cho phiếu đăng ký khám - /search must come before /:id
router.get('/search', timKiemPhieuDangKyKham);           // GET /api/pdk-kham/search
router.post('/', themPhieuDangKyKham);                   // POST /api/pdk-kham
router.get('/', layPhieuDangKyKham)
router.get('/:id', layPhieuDangKyKhamTheoID);            // GET /api/pdk-kham/:id
router.put('/:id', suaPhieuDangKyKham);                  // PUT /api/pdk-kham/:id
router.patch('/:id/trang-thai', capNhatTrangThaiPhieuKham); // PATCH /api/pdk-kham/:id/trang-thai
router.delete('/:id', xoaPhieuDangKyKham);               // DELETE /api/pdk-kham/:id

module.exports = router;