// Validation middleware cho các endpoints

// Validate thêm bệnh nhân
const validateBenhNhan = (req, res, next) => {
  const { HoTen, NgaySinh, GioiTinh, SDT } = req.body;
  const errors = [];

  if (!HoTen || HoTen.trim().length < 2) {
    errors.push('Họ tên phải có ít nhất 2 ký tự');
  }

  if (!NgaySinh) {
    errors.push('Ngày sinh là bắt buộc');
  } else {
    const birthDate = new Date(NgaySinh);
    const today = new Date();
    if (birthDate > today) {
      errors.push('Ngày sinh không thể trong tương lai');
    }
  }

  if (!GioiTinh || !['Nam', 'Nữ', 'Khác'].includes(GioiTinh)) {
    errors.push('Giới tính phải là Nam, Nữ hoặc Khác');
  }

  if (SDT && !/^[0-9]{10,11}$/.test(SDT)) {
    errors.push('Số điện thoại phải có 10-11 chữ số');
  }

  if (errors.length > 0) {
    return res.status(400).json({
      success: false,
      message: 'Dữ liệu không hợp lệ',
      errors: errors
    });
  }

  next();
};

// Validate phiếu đăng ký khám
const validatePhieuDangKyKham = (req, res, next) => {
  const { LyDoKham, idBenhNhan, idKhoa } = req.body;
  const errors = [];

  if (!LyDoKham || LyDoKham.trim().length < 5) {
    errors.push('Lý do khám phải có ít nhất 5 ký tự');
  }

  if (!idBenhNhan) {
    errors.push('Mã bệnh nhân là bắt buộc');
  }

  if (!idKhoa) {
    errors.push('Mã khoa là bắt buộc');
  }

  if (errors.length > 0) {
    return res.status(400).json({
      success: false,
      message: 'Dữ liệu không hợp lệ',
      errors: errors
    });
  }

  next();
};

// Validate yêu cầu chuyển viện
const validateYeuCauChuyenVien = (req, res, next) => {
  const { LyDo, CoSoChuyenDen, NgayChuyen, idBenhNhan } = req.body;
  const errors = [];

  if (!LyDo || LyDo.trim().length < 10) {
    errors.push('Lý do chuyển viện phải có ít nhất 10 ký tự');
  }

  if (!CoSoChuyenDen || CoSoChuyenDen.trim().length < 5) {
    errors.push('Cơ sở chuyển đến phải có ít nhất 5 ký tự');
  }

  if (!NgayChuyen) {
    errors.push('Ngày chuyển là bắt buộc');
  } else {
    const transferDate = new Date(NgayChuyen);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    if (transferDate < today) {
      errors.push('Ngày chuyển không thể trong quá khứ');
    }
  }

  if (!idBenhNhan) {
    errors.push('Mã bệnh nhân là bắt buộc');
  }

  if (errors.length > 0) {
    return res.status(400).json({
      success: false,
      message: 'Dữ liệu không hợp lệ',
      errors: errors
    });
  }

  next();
};

// Validate đơn thuốc
const validateDonThuoc = (req, res, next) => {
  const { idKhamBenh } = req.body;
  const errors = [];

  if (!idKhamBenh) {
    errors.push('Mã khám bệnh là bắt buộc');
  }

  if (errors.length > 0) {
    return res.status(400).json({
      success: false,
      message: 'Dữ liệu không hợp lệ',
      errors: errors
    });
  }

  next();
};

// Validate chi tiết đơn thuốc
const validateChiTietDonThuoc = (req, res, next) => {
  const { idDonThuoc, idDuocPham, SoLuong, LieuDung } = req.body;
  const errors = [];

  if (!idDonThuoc) {
    errors.push('Mã đơn thuốc là bắt buộc');
  }

  if (!idDuocPham) {
    errors.push('Mã dược phẩm là bắt buộc');
  }

  if (!SoLuong || SoLuong <= 0) {
    errors.push('Số lượng phải lớn hơn 0');
  }

  if (!LieuDung || LieuDung.trim().length < 3) {
    errors.push('Liều dùng phải có ít nhất 3 ký tự');
  }

  if (errors.length > 0) {
    return res.status(400).json({
      success: false,
      message: 'Dữ liệu không hợp lệ',
      errors: errors
    });
  }

  next();
};

// Validate ca làm việc
const validateCaLamViec = (req, res, next) => {
  const { idNhanVien, NgayLamViec, LoaiCa, GioBD, GioKT, idKhoa, idLichTongThe } = req.body;
  const errors = [];

  if (!idNhanVien) {
    errors.push('Mã nhân viên là bắt buộc');
  }

  if (!NgayLamViec) {
    errors.push('Ngày làm việc là bắt buộc');
  }

  if (!LoaiCa) {
    errors.push('Loại ca là bắt buộc');
  }

  if (!GioBD || !GioKT) {
    errors.push('Giờ bắt đầu và giờ kết thúc là bắt buộc');
  } else {
    const startTime = new Date(`1970-01-01T${GioBD}`);
    const endTime = new Date(`1970-01-01T${GioKT}`);
    if (startTime >= endTime) {
      errors.push('Giờ bắt đầu phải nhỏ hơn giờ kết thúc');
    }
  }

  if (!idKhoa) {
    errors.push('Mã khoa là bắt buộc');
  }

  if (!idLichTongThe) {
    errors.push('Mã lịch tổng thể là bắt buộc');
  }

  if (errors.length > 0) {
    return res.status(400).json({
      success: false,
      message: 'Dữ liệu không hợp lệ',
      errors: errors
    });
  }

  next();
};

// Validate đơn nghỉ phép
const validateDonNghiPhep = (req, res, next) => {
  const { LoaiPhep, NgayBD, NgayKT, TongNgayNghi, LyDo } = req.body;
  const errors = [];

  if (!LoaiPhep) {
    errors.push('Loại phép là bắt buộc');
  }

  if (!NgayBD || !NgayKT) {
    errors.push('Ngày bắt đầu và ngày kết thúc là bắt buộc');
  } else {
    const startDate = new Date(NgayBD);
    const endDate = new Date(NgayKT);
    if (startDate > endDate) {
      errors.push('Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc');
    }
  }

  if (!TongNgayNghi || TongNgayNghi <= 0) {
    errors.push('Tổng ngày nghỉ phải lớn hơn 0');
  }

  if (!LyDo || LyDo.trim().length < 5) {
    errors.push('Lý do nghỉ phép phải có ít nhất 5 ký tự');
  }

  if (errors.length > 0) {
    return res.status(400).json({
      success: false,
      message: 'Dữ liệu không hợp lệ',
      errors: errors
    });
  }

  next();
};

// Validate người dùng
const validateUser = (req, res, next) => {
  const { HoTen, TenDN, MatKhau, Email } = req.body;
  const errors = [];

  if (!HoTen || HoTen.trim().length < 2) {
    errors.push('Họ tên phải có ít nhất 2 ký tự');
  }

  if (!TenDN || TenDN.trim().length < 3) {
    errors.push('Tên đăng nhập phải có ít nhất 3 ký tự');
  }

  if (!MatKhau || MatKhau.length < 6) {
    errors.push('Mật khẩu phải có ít nhất 6 ký tự');
  }

  if (Email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(Email)) {
    errors.push('Email không hợp lệ');
  }

  if (errors.length > 0) {
    return res.status(400).json({
      success: false,
      message: 'Dữ liệu không hợp lệ',
      errors: errors
    });
  }

  next();
};

// Validate đăng nhập
const validateLogin = (req, res, next) => {
  const { TenDN, MatKhau } = req.body;
  const errors = [];

  if (!TenDN || TenDN.trim().length === 0) {
    errors.push('Tên đăng nhập là bắt buộc');
  }

  if (!MatKhau || MatKhau.length === 0) {
    errors.push('Mật khẩu là bắt buộc');
  }

  if (errors.length > 0) {
    return res.status(400).json({
      success: false,
      message: 'Thông tin đăng nhập không hợp lệ',
      errors: errors
    });
  }

  next();
};

// Validate query parameters cho tìm kiếm
const validateSearchQuery = (req, res, next) => {
  const { TuNgay, DenNgay } = req.query;
  const errors = [];

  if (TuNgay && DenNgay) {
    const startDate = new Date(TuNgay);
    const endDate = new Date(DenNgay);
    
    if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) {
      errors.push('Định dạng ngày không hợp lệ');
    } else if (startDate > endDate) {
      errors.push('Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc');
    }
  }

  if (errors.length > 0) {
    return res.status(400).json({
      success: false,
      message: 'Tham số tìm kiếm không hợp lệ',
      errors: errors
    });
  }

  next();
};

module.exports = {
  validateBenhNhan,
  validatePhieuDangKyKham,
  validateYeuCauChuyenVien,
  validateDonThuoc,
  validateChiTietDonThuoc,
  validateCaLamViec,
  validateDonNghiPhep,
  validateUser,
  validateLogin,
  validateSearchQuery
};