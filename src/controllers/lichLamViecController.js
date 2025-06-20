const prisma = require('../utils/prisma');

// ============ LỊCH LÀM VIỆC ============

// Hiển thị lịch làm việc tuần
const layLichLamViecTuan = async (req, res) => {
  try {
    const { TuNgay, DenNgay, idKhoa } = req.query;

    if (!TuNgay || !DenNgay) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập đầy đủ thông tin: TuNgay, DenNgay'
      });
    }

    const result = await prisma.$queryRaw`
      EXEC sp_LayLichLamViecTuan 
        @TuNgay = ${TuNgay},
        @DenNgay = ${DenNgay},
        @idKhoa = ${idKhoa || null}
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layLichLamViecTuan:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy lịch làm việc tuần',
      error: error.message
    });
  }
};

// Lấy danh sách tất cả ca làm việc với filter
const layDanhSachCaLamViec = async (req, res) => {
  try {
    const { TuNgay, DenNgay, idKhoa, TrangThai } = req.query;
    
    let whereClause = [];
    let params = [];

    if (TuNgay && DenNgay) {
      whereClause.push(`NgayLamViec BETWEEN ? AND ?`);
      params.push(TuNgay, DenNgay);
    }
    
    if (idKhoa) {
      whereClause.push(`idKhoa = ?`);
      params.push(idKhoa);
    }
    
    if (TrangThai) {
      whereClause.push(`TrangThai = ?`);
      params.push(TrangThai);
    }

    const whereStatement = whereClause.length > 0 ? `WHERE ${whereClause.join(' AND ')}` : '';
    
    const result = await prisma.$queryRawUnsafe(`
      SELECT 
        clv.*,
        nv.HoTen AS TenNhanVien,
        k.TenKhoa,
        nd_tao.HoTen AS TenNguoiTao,
        nd_duyet.HoTen AS TenNguoiPheDuyet
      FROM CALAMVIEC clv
      LEFT JOIN NGUOIDUNG nv ON clv.idNhanVien = nv.idNguoiDung  
      LEFT JOIN KHOA k ON clv.idKhoa = k.idKhoa
      LEFT JOIN NGUOIDUNG nd_tao ON clv.idNguoiDung = nd_tao.idNguoiDung
      LEFT JOIN NGUOIDUNG nd_duyet ON clv.idNguoiPheDuyet = nd_duyet.idNguoiDung
      ${whereStatement}
      ORDER BY clv.NgayLamViec DESC, clv.GioBD
    `, ...params);
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layDanhSachCaLamViec:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách ca làm việc',
      error: error.message
    });
  }
};

// Lấy thống kê lịch làm việc
const layThongKeLichLamViec = async (req, res) => {
  try {
    const { thang } = req.query; // Format: YYYY-MM

    const result = await prisma.$queryRaw`
      EXEC sp_LayThongKeLichLamViec @Thang = ${thang || null}
    `;
    
    res.json({
      success: true,
      data: result[0]
    });
  } catch (error) {
    console.error('Error in layThongKeLichLamViec:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thống kê lịch làm việc',
      error: error.message
    });
  }
};

// ============ CA LÀM VIỆC ============

// Thêm ca làm việc
const themCaLamViec = async (req, res) => {
  try {
    const {
      idNhanVien, NgayLamViec, LoaiCa, GioBD, GioKT,
      LoaiCongViec, GhiChu, idKhoa, idLichTongThe
    } = req.body;

    // Validation
    if (!idNhanVien || !NgayLamViec || !LoaiCa || !GioBD || !GioKT || !idKhoa) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập đầy đủ thông tin bắt buộc'
      });
    }

    const result = await prisma.$queryRaw`
      DECLARE @idCaLamViecMoi CHAR(10);
      EXEC sp_ThemCaLamViec 
        @idNhanVien = ${idNhanVien},
        @NgayLamViec = ${NgayLamViec},
        @LoaiCa = ${LoaiCa},
        @GioBD = ${GioBD},
        @GioKT = ${GioKT},
        @LoaiCongViec = ${LoaiCongViec},
        @GhiChu = ${GhiChu},
        @idKhoa = ${idKhoa},
        @idLichTongThe = ${idLichTongThe},
        @idCaLamViecMoi = @idCaLamViecMoi OUTPUT;
      SELECT @idCaLamViecMoi as idCaLamViecMoi;
    `;

    res.status(201).json({
      success: true,
      message: 'Thêm ca làm việc thành công',
      data: { idCaLamViecMoi: result[0]?.idCaLamViecMoi }
    });
  } catch (error) {
    console.error('Error in themCaLamViec:', error);
    res.status(500).json({
      success: false,
      message: error.message.includes('Lỗi:') ? error.message : 'Lỗi khi thêm ca làm việc',
      error: error.message
    });
  }
};

// Sửa ca làm việc
const suaCaLamViec = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      idNhanVien, NgayLamViec, LoaiCa, GioBD, GioKT,
      LoaiCongViec, GhiChu, idKhoa
    } = req.body;

    await prisma.$executeRaw`
      EXEC sp_SuaCaLamViec 
        @idCaLamViec = ${id},
        @idNhanVien = ${idNhanVien},
        @NgayLamViec = ${NgayLamViec},
        @LoaiCa = ${LoaiCa},
        @GioBD = ${GioBD},
        @GioKT = ${GioKT},
        @LoaiCongViec = ${LoaiCongViec},
        @GhiChu = ${GhiChu},
        @idKhoa = ${idKhoa}
    `;

    res.json({
      success: true,
      message: 'Cập nhật ca làm việc thành công'
    });
  } catch (error) {
    console.error('Error in suaCaLamViec:', error);
    res.status(500).json({
      success: false,
      message: error.message.includes('Lỗi:') ? error.message : 'Lỗi khi cập nhật ca làm việc',
      error: error.message
    });
  }
};

// Xác nhận ca làm việc
const xacNhanCaLamViec = async (req, res) => {
  try {
    const { id } = req.params;

    await prisma.$executeRaw`
      EXEC sp_XacNhanCaLamViec @idCaLamViec = ${id}
    `;

    res.json({
      success: true,
      message: 'Xác nhận ca làm việc thành công'
    });
  } catch (error) {
    console.error('Error in xacNhanCaLamViec:', error);
    res.status(500).json({
      success: false,
      message: error.message.includes('Lỗi:') ? error.message : 'Lỗi khi xác nhận ca làm việc',
      error: error.message
    });
  }
};

// Xóa ca làm việc
const xoaCaLamViec = async (req, res) => {
  try {
    const { id } = req.params;

    await prisma.$executeRaw`
      EXEC sp_XoaCaLamViec @idCaLamViec = ${id}
    `;

    res.json({
      success: true,
      message: 'Xóa ca làm việc thành công'
    });
  } catch (error) {
    console.error('Error in xoaCaLamViec:', error);
    res.status(500).json({
      success: false,
      message: error.message.includes('Lỗi:') ? error.message : 'Lỗi khi xóa ca làm việc',
      error: error.message
    });
  }
};

// Lấy chi tiết ca làm việc
const layChiTietCaLamViec = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_LayChiTietCaLamViec @idCaLamViec = ${id}
    `;
    
    if (result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy ca làm việc'
      });
    }
    
    res.json({
      success: true,
      data: result[0]
    });
  } catch (error) {
    console.error('Error in layChiTietCaLamViec:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thông tin ca làm việc',
      error: error.message
    });
  }
};

// ============ YÊU CẦU CHUYỂN CA ============

// Lấy danh sách yêu cầu chuyển ca
const layDanhSachYeuCauChuyenCa = async (req, res) => {
  try {
    const { TrangThai, TuNgay, DenNgay } = req.query;
    
    let whereClause = [];
    let params = [];

    if (TrangThai) {
      whereClause.push(`pyc.TrangThai = ?`);
      params.push(TrangThai);
    }
    
    if (TuNgay && DenNgay) {
      whereClause.push(`pyc.NgayYeuCau BETWEEN ? AND ?`);
      params.push(TuNgay, DenNgay);
    }

    const whereStatement = whereClause.length > 0 ? `WHERE ${whereClause.join(' AND ')}` : '';
    
    const result = await prisma.$queryRawUnsafe(`
      SELECT 
        pyc.*,
        nv_cu.HoTen AS TenNhanVienCu,
        nv_moi.HoTen AS TenNhanVienMoi,
        ca_goc.NgayLamViec, ca_goc.LoaiCa, ca_goc.GioBD, ca_goc.GioKT,
        nd_tao.HoTen AS TenNguoiTao,
        nd_duyet.HoTen AS TenNguoiPheDuyet
      FROM PYC_CHUYENCA pyc
      LEFT JOIN NHANVIEN nv_cu ON pyc.idNhanVienCu = nv_cu.idNhanVien
      LEFT JOIN NHANVIEN nv_moi ON pyc.idNhanVienMoi = nv_moi.idNhanVien
      LEFT JOIN CALAMVIEC ca_goc ON pyc.idCaLamViecGoc = ca_goc.idCaLamViec
      LEFT JOIN NGUOIDUNG nd_tao ON pyc.idNguoiDung = nd_tao.idNguoiDung
      LEFT JOIN NGUOIDUNG nd_duyet ON pyc.idNguoiPheDuyet = nd_duyet.idNguoiDung
      ${whereStatement}
      ORDER BY pyc.NgayYeuCau DESC
    `, ...params);
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layDanhSachYeuCauChuyenCa:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách yêu cầu chuyển ca',
      error: error.message
    });
  }
};

// Tạo yêu cầu chuyển ca
const taoYeuCauChuyenCa = async (req, res) => {
  try {
    const {
      idCaLamViecGoc, idNhanVienMoi, NgayChuyen, LyDo,
      CanBuCa, GhiChu
    } = req.body;

    if (!idCaLamViecGoc || !idNhanVienMoi || !LyDo) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập đầy đủ thông tin bắt buộc'
      });
    }

    const result = await prisma.$queryRaw`
      DECLARE @idYeuCauMoi CHAR(10);
      EXEC sp_TaoYeuCauChuyenCa 
        @idCaLamViecGoc = ${idCaLamViecGoc},
        @idNhanVienMoi = ${idNhanVienMoi},
        @NgayChuyen = ${NgayChuyen},
        @LyDo = ${LyDo},
        @CanBuCa = ${CanBuCa || false},
        @GhiChu = ${GhiChu},
        @idYeuCauMoi = @idYeuCauMoi OUTPUT;
      SELECT @idYeuCauMoi as idYeuCauMoi;
    `;

    res.status(201).json({
      success: true,
      message: 'Tạo yêu cầu chuyển ca thành công',
      data: { idYeuCauMoi: result[0]?.idYeuCauMoi }
    });
  } catch (error) {
    console.error('Error in taoYeuCauChuyenCa:', error);
    res.status(500).json({
      success: false,
      message: error.message.includes('Lỗi:') ? error.message : 'Lỗi khi tạo yêu cầu chuyển ca',
      error: error.message
    });
  }
};

// Sửa yêu cầu chuyển ca
const suaYeuCauChuyenCa = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      idNhanVienMoi, NgayChuyen, LyDo, CanBuCa, GhiChu
    } = req.body;

    await prisma.$executeRaw`
      EXEC sp_SuaYeuCauChuyenCa 
        @idYeuCauChuyenCa = ${id},
        @idNhanVienMoi = ${idNhanVienMoi},
        @NgayChuyen = ${NgayChuyen},
        @LyDo = ${LyDo},
        @CanBuCa = ${CanBuCa},
        @GhiChu = ${GhiChu}
    `;

    res.json({
      success: true,
      message: 'Cập nhật yêu cầu chuyển ca thành công'
    });
  } catch (error) {
    console.error('Error in suaYeuCauChuyenCa:', error);
    res.status(500).json({
      success: false,
      message: error.message.includes('Lỗi:') ? error.message : 'Lỗi khi cập nhật yêu cầu chuyển ca',
      error: error.message
    });
  }
};

// Xử lý yêu cầu chuyển ca
const xuLyYeuCauChuyenCa = async (req, res) => {
  try {
    const { id } = req.params;
    const { IsApproved, GhiChuPheDuyet } = req.body;

    await prisma.$executeRaw`
      EXEC sp_XuLyYeuCauChuyenCa 
        @idYeuCauChuyenCa = ${id},
        @IsApproved = ${IsApproved},
        @GhiChuPheDuyet = ${GhiChuPheDuyet}
    `;

    res.json({
      success: true,
      message: `${IsApproved ? 'Phê duyệt' : 'Từ chối'} yêu cầu chuyển ca thành công`
    });
  } catch (error) {
    console.error('Error in xuLyYeuCauChuyenCa:', error);
    res.status(500).json({
      success: false,
      message: error.message.includes('Lỗi:') ? error.message : 'Lỗi khi xử lý yêu cầu chuyển ca',
      error: error.message
    });
  }
};

// Xóa yêu cầu chuyển ca
const xoaYeuCauChuyenCa = async (req, res) => {
  try {
    const { id } = req.params;

    await prisma.$executeRaw`
      EXEC sp_XoaYeuCauChuyenCa @idYeuCauChuyenCa = ${id}
    `;

    res.json({
      success: true,
      message: 'Xóa yêu cầu chuyển ca thành công'
    });
  } catch (error) {
    console.error('Error in xoaYeuCauChuyenCa:', error);
    res.status(500).json({
      success: false,
      message: error.message.includes('Lỗi:') ? error.message : 'Lỗi khi xóa yêu cầu chuyển ca',
      error: error.message
    });
  }
};

// Lấy chi tiết yêu cầu chuyển ca
const layChiTietYeuCauChuyenCa = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_LayChiTietYeuCauChuyenCa @idYeuCauChuyenCa = ${id}
    `;
    
    if (result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy yêu cầu chuyển ca'
      });
    }
    
    res.json({
      success: true,
      data: result[0]
    });
  } catch (error) {
    console.error('Error in layChiTietYeuCauChuyenCa:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thông tin yêu cầu chuyển ca',
      error: error.message
    });
  }
};

// ============ ĐƠN NGHỈ PHÉP ============

// Lấy danh sách đơn nghỉ phép
const layDanhSachDonNghiPhep = async (req, res) => {
  try {
    const { TrangThai, TuNgay, DenNgay } = req.query;
    
    let whereClause = [];
    let params = [];

    if (TrangThai) {
      whereClause.push(`dnp.TrangThai = ?`);
      params.push(TrangThai);
    }
    
    if (TuNgay && DenNgay) {
      whereClause.push(`dnp.NgayLap BETWEEN ? AND ?`);
      params.push(TuNgay, DenNgay);
    }

    const whereStatement = whereClause.length > 0 ? `WHERE ${whereClause.join(' AND ')}` : '';
    
    const result = await prisma.$queryRawUnsafe(`
      SELECT 
        dnp.*,
        nv.HoTen AS TenNhanVien,
        nd_duyet.HoTen AS TenNguoiPheDuyet,
        nv_thaythe.HoTen AS TenNhanVienThayThe
      FROM DON_NGHIPHEP dnp
      LEFT JOIN NHANVIEN nv ON dnp.idNhanVien = nv.idNhanVien
      LEFT JOIN NGUOIDUNG nd_duyet ON dnp.idNguoiPheDuyet = nd_duyet.idNguoiDung
      LEFT JOIN NHANVIEN nv_thaythe ON dnp.idNhanVienThayThe = nv_thaythe.idNhanVien
      ${whereStatement}
      ORDER BY dnp.NgayLap DESC
    `, ...params);
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layDanhSachDonNghiPhep:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách đơn nghỉ phép',
      error: error.message
    });
  }
};

// Tạo đơn nghỉ phép
const taoDonNghiPhep = async (req, res) => {
  try {
    const {
      LoaiPhep, NgayBD, NgayKT, GioBD, GioKT, NghiCaNgay,
      TongNgayNghi, LyDo, HoTenNguoiLienHe, SDTNguoiLienHe,
      MoiQuanHe, GhiChu, idNhanVienThayThe
    } = req.body;

    if (!LoaiPhep || !NgayBD || !NgayKT || !LyDo) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập đầy đủ thông tin bắt buộc'
      });
    }

    const result = await prisma.$queryRaw`
      DECLARE @idNghiPhepMoi CHAR(10);
      EXEC sp_TaoDonNghiPhep 
        @LoaiPhep = ${LoaiPhep},
        @NgayBD = ${NgayBD},
        @NgayKT = ${NgayKT},
        @GioBD = ${GioBD},
        @GioKT = ${GioKT},
        @NghiCaNgay = ${NghiCaNgay || true},
        @TongNgayNghi = ${TongNgayNghi},
        @LyDo = ${LyDo},
        @HoTenNguoiLienHe = ${HoTenNguoiLienHe},
        @SDTNguoiLienHe = ${SDTNguoiLienHe},
        @MoiQuanHe = ${MoiQuanHe},
        @GhiChu = ${GhiChu},
        @idNhanVienThayThe = ${idNhanVienThayThe},
        @idNghiPhepMoi = @idNghiPhepMoi OUTPUT;
      SELECT @idNghiPhepMoi as idNghiPhepMoi;
    `;

    res.status(201).json({
      success: true,
      message: 'Tạo đơn nghỉ phép thành công',
      data: { idNghiPhepMoi: result[0]?.idNghiPhepMoi }
    });
  } catch (error) {
    console.error('Error in taoDonNghiPhep:', error);
    res.status(500).json({
      success: false,
      message: error.message.includes('Lỗi:') ? error.message : 'Lỗi khi tạo đơn nghỉ phép',
      error: error.message
    });
  }
};

// Sửa đơn nghỉ phép
const suaDonNghiPhep = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      LoaiPhep, NgayBD, NgayKT, GioBD, GioKT, NghiCaNgay,
      TongNgayNghi, LyDo, HoTenNguoiLienHe, SDTNguoiLienHe,
      MoiQuanHe, GhiChu, idNhanVienThayThe
    } = req.body;

    await prisma.$executeRaw`
      EXEC sp_SuaDonNghiPhep 
        @idNghiPhep = ${id},
        @LoaiPhep = ${LoaiPhep},
        @NgayBD = ${NgayBD},
        @NgayKT = ${NgayKT},
        @GioBD = ${GioBD},
        @GioKT = ${GioKT},
        @NghiCaNgay = ${NghiCaNgay},
        @TongNgayNghi = ${TongNgayNghi},
        @LyDo = ${LyDo},
        @HoTenNguoiLienHe = ${HoTenNguoiLienHe},
        @SDTNguoiLienHe = ${SDTNguoiLienHe},
        @MoiQuanHe = ${MoiQuanHe},
        @GhiChu = ${GhiChu},
        @idNhanVienThayThe = ${idNhanVienThayThe}
    `;

    res.json({
      success: true,
      message: 'Cập nhật đơn nghỉ phép thành công'
    });
  } catch (error) {
    console.error('Error in suaDonNghiPhep:', error);
    res.status(500).json({
      success: false,
      message: error.message.includes('Lỗi:') ? error.message : 'Lỗi khi cập nhật đơn nghỉ phép',
      error: error.message
    });
  }
};

// Xử lý đơn nghỉ phép
const xuLyDonNghiPhep = async (req, res) => {
  try {
    const { id } = req.params;
    const { IsApproved, GhiChuPheDuyet } = req.body;

    await prisma.$executeRaw`
      EXEC sp_XuLyDonNghiPhep 
        @idNghiPhep = ${id},
        @IsApproved = ${IsApproved},
        @GhiChuPheDuyet = ${GhiChuPheDuyet}
    `;

    res.json({
      success: true,
      message: `${IsApproved ? 'Phê duyệt' : 'Từ chối'} đơn nghỉ phép thành công`
    });
  } catch (error) {
    console.error('Error in xuLyDonNghiPhep:', error);
    res.status(500).json({
      success: false,
      message: error.message.includes('Lỗi:') ? error.message : 'Lỗi khi xử lý đơn nghỉ phép',
      error: error.message
    });
  }
};

// Xóa đơn nghỉ phép
const xoaDonNghiPhep = async (req, res) => {
  try {
    const { id } = req.params;

    await prisma.$executeRaw`
      EXEC sp_XoaDonNghiPhep @idNghiPhep = ${id}
    `;

    res.json({
      success: true,
      message: 'Xóa đơn nghỉ phép thành công'
    });
  } catch (error) {
    console.error('Error in xoaDonNghiPhep:', error);
    res.status(500).json({
      success: false,
      message: error.message.includes('Lỗi:') ? error.message : 'Lỗi khi xóa đơn nghỉ phép',
      error: error.message
    });
  }
};

// Lấy chi tiết đơn nghỉ phép
const layChiTietDonNghiPhep = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_LayChiTietDonNghiPhep @idNghiPhep = ${id}
    `;
    
    if (result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy đơn nghỉ phép'
      });
    }
    
    res.json({
      success: true,
      data: result[0]
    });
  } catch (error) {
    console.error('Error in layChiTietDonNghiPhep:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thông tin đơn nghỉ phép',
      error: error.message
    });
  }
};

// Lấy các ca bị ảnh hưởng bởi đơn nghỉ
const layCacCaBiAnhHuong = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_LayCacCaBiAnhHuongBoiDonNghi @idNghiPhep = ${id}
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layCacCaBiAnhHuong:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy các ca bị ảnh hưởng',
      error: error.message
    });
  }
};

// ============ HELPER FUNCTIONS ============

// Lấy danh sách nhân viên
const layDanhSachNhanVien = async (req, res) => {
  try {
    const { idKhoa } = req.query;
    
    let whereClause = '';
    let params = [];
    
    if (idKhoa) {
      whereClause = 'WHERE nv.idKhoa = ?';
      params.push(idKhoa);
    }
    
    const result = await prisma.$queryRawUnsafe(`
      SELECT 
        nv.idNhanVien as _id,
        nv.HoTen,
        nv.ChucVu,
        k.TenKhoa as department,
        nv.HoTen as firstName,
        '' as lastName
      FROM NHANVIEN nv
      LEFT JOIN KHOA k ON nv.idKhoa = k.idKhoa
      ${whereClause}
      ORDER BY nv.HoTen
    `, ...params);
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layDanhSachNhanVien:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách nhân viên',
      error: error.message
    });
  }
};

// Lấy danh sách khoa
const layDanhSachKhoa = async (req, res) => {
  try {
    const result = await prisma.$queryRaw`
      SELECT idKhoa, TenKhoa FROM KHOA WHERE TrangThai = N'Hoạt động' ORDER BY TenKhoa
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layDanhSachKhoa:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách khoa',
      error: error.message
    });
  }
};

module.exports = {
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
};