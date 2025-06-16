const express = require('express');
const router = express.Router();
const {
  // Lịch làm việc
  layLichLamViecTuan,
  
  // Ca làm việc
  themCaLamViec,
  suaCaLamViec,
  xacNhanCaLamViec,
  xoaCaLamViec,
  layChiTietCaLamViec,
  
  // Yêu cầu chuyển ca
  taoYeuCauChuyenCa,
  suaYeuCauChuyenCa,
  xuLyYeuCauChuyenCa,
  xoaYeuCauChuyenCa,
  layChiTietYeuCauChuyenCa,
  
  // Đơn nghỉ phép
  taoDonNghiPhep,
  suaDonNghiPhep,
  xuLyDonNghiPhep,
  xoaDonNghiPhep,
  layChiTietDonNghiPhep,
  layCacCaBiAnhHuong
} = require('../controllers/lichLamViecController');

// ===== LỊCH LÀM VIỆC =====
router.get('/lich-tuan', layLichLamViecTuan);                         // GET /api/lich-lam-viec/lich-tuan - Lấy lịch làm việc tuần

// ===== CA LÀM VIỆC =====
// Routes cho ca làm việc
router.post('/ca', themCaLamViec);                                    // POST /api/lich-lam-viec/ca - Thêm ca làm việc
router.put('/ca/:id', suaCaLamViec);                                  // PUT /api/lich-lam-viec/ca/:id - Sửa ca làm việc
router.patch('/ca/:id/xac-nhan', xacNhanCaLamViec);                   // PATCH /api/lich-lam-viec/ca/:id/xac-nhan - Xác nhận ca làm việc
router.delete('/ca/:id', xoaCaLamViec);                               // DELETE /api/lich-lam-viec/ca/:id - Xóa ca làm việc
router.get('/ca/:id', layChiTietCaLamViec);                           // GET /api/lich-lam-viec/ca/:id - Lấy chi tiết ca làm việc

// ===== YÊU CẦU CHUYỂN CA =====
// Routes cho yêu cầu chuyển ca
router.post('/chuyen-ca', taoYeuCauChuyenCa);                         // POST /api/lich-lam-viec/chuyen-ca - Tạo yêu cầu chuyển ca
router.put('/chuyen-ca/:id', suaYeuCauChuyenCa);                      // PUT /api/lich-lam-viec/chuyen-ca/:id - Sửa yêu cầu chuyển ca
router.patch('/chuyen-ca/:id/xu-ly', xuLyYeuCauChuyenCa);             // PATCH /api/lich-lam-viec/chuyen-ca/:id/xu-ly - Xử lý yêu cầu chuyển ca
router.delete('/chuyen-ca/:id', xoaYeuCauChuyenCa);                   // DELETE /api/lich-lam-viec/chuyen-ca/:id - Xóa yêu cầu chuyển ca
router.get('/chuyen-ca/:id', layChiTietYeuCauChuyenCa);               // GET /api/lich-lam-viec/chuyen-ca/:id - Lấy chi tiết yêu cầu chuyển ca

// ===== ĐƠN NGHỈ PHÉP =====
// Routes cho đơn nghỉ phép
router.post('/nghi-phep', taoDonNghiPhep);                            // POST /api/lich-lam-viec/nghi-phep - Tạo đơn nghỉ phép
router.put('/nghi-phep/:id', suaDonNghiPhep);                         // PUT /api/lich-lam-viec/nghi-phep/:id - Sửa đơn nghỉ phép
router.patch('/nghi-phep/:id/xu-ly', xuLyDonNghiPhep);                // PATCH /api/lich-lam-viec/nghi-phep/:id/xu-ly - Xử lý đơn nghỉ phép
router.delete('/nghi-phep/:id', xoaDonNghiPhep);                      // DELETE /api/lich-lam-viec/nghi-phep/:id - Xóa đơn nghỉ phép
router.get('/nghi-phep/:id', layChiTietDonNghiPhep);                  // GET /api/lich-lam-viec/nghi-phep/:id - Lấy chi tiết đơn nghỉ phép
router.get('/nghi-phep/:id/ca-anh-huong', layCacCaBiAnhHuong);        // GET /api/lich-lam-viec/nghi-phep/:id/ca-anh-huong - Lấy ca bị ảnh hưởng

module.exports = router;