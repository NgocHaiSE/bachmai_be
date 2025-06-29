const express = require('express');
const router = express.Router();
const {
  // Lịch làm việc
  layLichLamViecTuan,
  layDanhSachCaLamViec,
  layThongKeLichLamViec,
  kiemTraXungDotLich,
  
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

// ============ LỊCH LÀM VIỆC ROUTES ============

// Lấy lịch làm việc tuần
router.get('/lich-tuan', layLichLamViecTuan);

// Lấy thống kê lịch làm việc
router.get('/thong-ke', layThongKeLichLamViec);

// Kiểm tra xung đột lịch
router.get('/xung-dot', kiemTraXungDotLich);

// ============ CA LÀM VIỆC ROUTES ============

// Lấy danh sách ca làm việc
router.get('/ca', layDanhSachCaLamViec);

// Lấy chi tiết ca làm việc
router.get('/ca/:id', layChiTietCaLamViec);

// Tạo ca làm việc mới
router.post('/ca', themCaLamViec);

// Cập nhật ca làm việc
router.put('/ca/:id', suaCaLamViec);

// Xác nhận ca làm việc
router.patch('/ca/:id/xac-nhan', xacNhanCaLamViec);

// Xóa ca làm việc
router.delete('/ca/:id', xoaCaLamViec);

// ============ YÊU CẦU CHUYỂN CA ROUTES ============

// Lấy danh sách yêu cầu chuyển ca
router.get('/chuyen-ca', layDanhSachYeuCauChuyenCa);

// Lấy chi tiết yêu cầu chuyển ca
router.get('/chuyen-ca/:id', layChiTietYeuCauChuyenCa);

// Tạo yêu cầu chuyển ca mới
router.post('/chuyen-ca', taoYeuCauChuyenCa);

// Cập nhật yêu cầu chuyển ca
router.put('/chuyen-ca/:id', suaYeuCauChuyenCa);

// Xử lý yêu cầu chuyển ca (phê duyệt/từ chối)
router.patch('/chuyen-ca/:id/xu-ly', xuLyYeuCauChuyenCa);

// Xóa yêu cầu chuyển ca
router.delete('/chuyen-ca/:id', xoaYeuCauChuyenCa);

// ============ ĐƠN NGHỈ PHÉP ROUTES ============

// Lấy danh sách đơn nghỉ phép
router.get('/nghi-phep', layDanhSachDonNghiPhep);

// Lấy chi tiết đơn nghỉ phép
router.get('/nghi-phep/:id', layChiTietDonNghiPhep);

// Lấy các ca bị ảnh hưởng bởi đơn nghỉ
router.get('/nghi-phep/:id/ca-anh-huong', layCacCaBiAnhHuong);

// Tạo đơn nghỉ phép mới
router.post('/nghi-phep', taoDonNghiPhep);

// Cập nhật đơn nghỉ phép
router.put('/nghi-phep/:id', suaDonNghiPhep);

// Xử lý đơn nghỉ phép (phê duyệt/từ chối)
router.patch('/nghi-phep/:id/xu-ly', xuLyDonNghiPhep);

// Xóa đơn nghỉ phép
router.delete('/nghi-phep/:id', xoaDonNghiPhep);

// ============ HELPER ROUTES ============

// Lấy danh sách nhân viên
router.get('/nhan-vien', layDanhSachNhanVien);

// Lấy danh sách khoa
router.get('/khoa', layDanhSachKhoa);

module.exports = router;