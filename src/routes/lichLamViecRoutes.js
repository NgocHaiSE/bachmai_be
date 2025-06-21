const express = require('express');
const router = express.Router();
const {
  // Lịch làm việc
  layLichLamViecTuan,
  layDanhSachCaLamViec,
  layThongKeLichLamViec,
  
  // Ca làm việc
  themCaLamViec,
  suaCaLamViec,
  xacNhanCaLamViec,
  xoaCaLamViec,
  layChiTietCaLamViec,
  
  // Yêu cầu chuyển ca
  layDanhSachYeuCauChuyenCa,
  taoYeuCauChuyenCa,
  suaYeuCauChuyenCa,
  xuLyYeuCauChuyenCa,
  xoaYeuCauChuyenCa,
  layChiTietYeuCauChuyenCa,
  
  // Đơn nghỉ phép
  layDanhSachDonNghiPhep,
  taoDonNghiPhep,
  suaDonNghiPhep,
  xuLyDonNghiPhep,
  xoaDonNghiPhep,
  layChiTietDonNghiPhep,
  layCacCaBiAnhHuong,
  
  // Helper functions
  layDanhSachNhanVien,
  layDanhSachKhoa
} = require('../controllers/lichLamViecController');

// ===== LỊCH LÀM VIỆC =====
router.get('/lich-tuan', layLichLamViecTuan);                         // GET /api/lich-lam-viec/lich-tuan
router.get('/thong-ke', layThongKeLichLamViec);                       // GET /api/lich-lam-viec/thong-ke

// ===== CA LÀM VIỆC =====
router.get('/ca', layDanhSachCaLamViec);                              // GET /api/lich-lam-viec/ca - Lấy danh sách ca làm việc
router.post('/ca', themCaLamViec);                                    // POST /api/lich-lam-viec/ca - Thêm ca làm việc
router.get('/ca/:id', layChiTietCaLamViec);                           // GET /api/lich-lam-viec/ca/:id - Lấy chi tiết ca làm việc
router.put('/ca/:id', suaCaLamViec);                                  // PUT /api/lich-lam-viec/ca/:id - Sửa ca làm việc
router.patch('/ca/:id/xac-nhan', xacNhanCaLamViec);                   // PATCH /api/lich-lam-viec/ca/:id/xac-nhan - Xác nhận ca làm việc
router.delete('/ca/:id', xoaCaLamViec);                               // DELETE /api/lich-lam-viec/ca/:id - Xóa ca làm việc

// ===== YÊU CẦU CHUYỂN CA =====
router.get('/chuyen-ca', layDanhSachYeuCauChuyenCa);                  // GET /api/lich-lam-viec/chuyen-ca - Lấy danh sách yêu cầu chuyển ca
router.post('/chuyen-ca', taoYeuCauChuyenCa);                         // POST /api/lich-lam-viec/chuyen-ca - Tạo yêu cầu chuyển ca
router.get('/chuyen-ca/:id', layChiTietYeuCauChuyenCa);               // GET /api/lich-lam-viec/chuyen-ca/:id - Lấy chi tiết yêu cầu chuyển ca
router.put('/chuyen-ca/:id', suaYeuCauChuyenCa);                      // PUT /api/lich-lam-viec/chuyen-ca/:id - Sửa yêu cầu chuyển ca
router.patch('/chuyen-ca/:id/xu-ly', xuLyYeuCauChuyenCa);             // PATCH /api/lich-lam-viec/chuyen-ca/:id/xu-ly - Xử lý yêu cầu chuyển ca
router.delete('/chuyen-ca/:id', xoaYeuCauChuyenCa);                   // DELETE /api/lich-lam-viec/chuyen-ca/:id - Xóa yêu cầu chuyển ca

// ===== ĐƠN NGHỈ PHÉP =====
router.get('/nghi-phep', layDanhSachDonNghiPhep);                     // GET /api/lich-lam-viec/nghi-phep - Lấy danh sách đơn nghỉ phép
router.post('/nghi-phep', taoDonNghiPhep);                            // POST /api/lich-lam-viec/nghi-phep - Tạo đơn nghỉ phép
router.get('/nghi-phep/:id', layChiTietDonNghiPhep);                  // GET /api/lich-lam-viec/nghi-phep/:id - Lấy chi tiết đơn nghỉ phép
router.put('/nghi-phep/:id', suaDonNghiPhep);                         // PUT /api/lich-lam-viec/nghi-phep/:id - Sửa đơn nghỉ phép
router.patch('/nghi-phep/:id/xu-ly', xuLyDonNghiPhep);                // PATCH /api/lich-lam-viec/nghi-phep/:id/xu-ly - Xử lý đơn nghỉ phép
router.delete('/nghi-phep/:id', xoaDonNghiPhep);                      // DELETE /api/lich-lam-viec/nghi-phep/:id - Xóa đơn nghỉ phép
router.get('/nghi-phep/:id/ca-anh-huong', layCacCaBiAnhHuong);        // GET /api/lich-lam-viec/nghi-phep/:id/ca-anh-huong - Lấy ca bị ảnh hưởng

// ===== HELPER ROUTES =====
router.get('/nhan-vien', layDanhSachNhanVien);                        // GET /api/lich-lam-viec/nhan-vien - Lấy danh sách nhân viên
router.get('/khoa', layDanhSachKhoa);                                 // GET /api/lich-lam-viec/khoa - Lấy danh sách khoa

module.exports = router;