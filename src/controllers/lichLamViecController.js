const prisma = require('../utils/prisma');

// ============ HELPER FUNCTIONS ============

// Tạo ID tự động
const generateId = (prefix, length = 10) => {
  const timestamp = Date.now().toString().slice(-6);
  const random = Math.random().toString(36).substr(2, length - prefix.length - timestamp.length).toUpperCase();
  return prefix + timestamp + random;
};

// Format thời gian
const formatTime = (timeString) => {
  if (!timeString) return null;
  if (typeof timeString === 'string' && timeString.includes(':')) {
    return timeString;
  }
  return new Date(timeString).toTimeString().slice(0, 8);
};

// Escape SQL string
const escapeSqlString = (str) => {
  if (!str) return 'NULL';
  return `N'${str.replace(/'/g, "''")}'`;
};

// ============ LỊCH LÀM VIỆC ============

// Hiển thị lịch làm việc tuần
const layLichLamViecTuan = async (req, res) => {
  try {
    const { TuNgay, DenNgay, idKhoa, TrangThai, LoaiThoiGian, Tuan, Nam, Thang } = req.query;

    let whereConditions = ['1=1'];

    // Xử lý thời gian
    if (TuNgay && DenNgay) {
      whereConditions.push(`clv.NgayLamViec BETWEEN '${TuNgay}' AND '${DenNgay}'`);
    } else if (Tuan && Nam) {
      // Tính toán tuần
      const year = parseInt(Nam);
      const week = parseInt(Tuan);
      const startDate = new Date(year, 0, 1 + (week - 1) * 7);
      const endDate = new Date(startDate);
      endDate.setDate(startDate.getDate() + 6);
      
      whereConditions.push(`clv.NgayLamViec BETWEEN '${startDate.toISOString().split('T')[0]}' AND '${endDate.toISOString().split('T')[0]}'`);
    } else if (Thang && Nam) {
      const year = parseInt(Nam);
      const month = parseInt(Thang);
      const startDate = new Date(year, month - 1, 1);
      const endDate = new Date(year, month, 0);
      
      whereConditions.push(`clv.NgayLamViec BETWEEN '${startDate.toISOString().split('T')[0]}' AND '${endDate.toISOString().split('T')[0]}'`);
    }

    if (idKhoa) {
      whereConditions.push(`clv.idKhoa = '${idKhoa}'`);
    }

    if (TrangThai) {
      whereConditions.push(`clv.TrangThai = N'${TrangThai}'`);
    }

    const query = `
      SELECT 
        clv.*,
        nv.HoTen AS HoTenNguoiDung,
        k.TenKhoa,
        nd_tao.HoTen AS TenNguoiTao,
        nd_duyet.HoTen AS TenNguoiPheDuyet
      FROM CALAMVIEC clv
      LEFT JOIN NHANVIEN nv ON clv.idNhanVien = nv.idNhanVien
      LEFT JOIN KHOA k ON clv.idKhoa = k.idKhoa
      LEFT JOIN NGUOIDUNG nd_tao ON clv.idNguoiDung = nd_tao.idNguoiDung
      LEFT JOIN NGUOIDUNG nd_duyet ON clv.idNguoiPheDuyet = nd_duyet.idNguoiDung
      WHERE ${whereConditions.join(' AND ')}
      ORDER BY clv.NgayLamViec, clv.GioBD
    `;
    
    const result = await prisma.$queryRawUnsafe(query);
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layLichLamViecTuan:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy lịch làm việc',
      error: error.message
    });
  }
};

// Lấy danh sách tất cả ca làm việc với filter
const layDanhSachCaLamViec = async (req, res) => {
  try {
    const { TuNgay, DenNgay, idKhoa, TrangThai, limit = 100 } = req.query;
    
    let whereConditions = ['1=1'];

    if (TuNgay && DenNgay) {
      whereConditions.push(`clv.NgayLamViec BETWEEN '${TuNgay}' AND '${DenNgay}'`);
    }
    
    if (idKhoa) {
      whereConditions.push(`clv.idKhoa = '${idKhoa}'`);
    }
    
    if (TrangThai) {
      whereConditions.push(`clv.TrangThai = N'${TrangThai}'`);
    }

    const query = `
      SELECT TOP ${parseInt(limit)}
        clv.*,
        nv.HoTen AS HoTenNguoiDung,
        k.TenKhoa,
        nd_tao.HoTen AS TenNguoiTao,
        nd_duyet.HoTen AS TenNguoiPheDuyet
      FROM CALAMVIEC clv
      LEFT JOIN NHANVIEN nv ON clv.idNhanVien = nv.idNhanVien
      LEFT JOIN KHOA k ON clv.idKhoa = k.idKhoa
      LEFT JOIN NGUOIDUNG nd_tao ON clv.idNguoiDung = nd_tao.idNguoiDung
      LEFT JOIN NGUOIDUNG nd_duyet ON clv.idNguoiPheDuyet = nd_duyet.idNguoiDung
      WHERE ${whereConditions.join(' AND ')}
      ORDER BY clv.NgayLamViec DESC, clv.GioBD
    `;
    
    const result = await prisma.$queryRawUnsafe(query);
    
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
    const { NgayBatDau, NgayKetThuc, idKhoa } = req.query;

    if (!NgayBatDau || !NgayKetThuc) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập đầy đủ thông tin: NgayBatDau, NgayKetThuc'
      });
    }

    let whereConditions = [`clv.NgayLamViec BETWEEN '${NgayBatDau}' AND '${NgayKetThuc}'`];

    if (idKhoa) {
      whereConditions.push(`clv.idKhoa = '${idKhoa}'`);
    }

    const query = `
      SELECT 
        COUNT(*) AS TongSoCa,
        COUNT(CASE WHEN clv.TrangThai = N'Đã duyệt' THEN 1 END) AS SoCaDaPheDuyet,
        COUNT(CASE WHEN clv.TrangThai = N'Chờ duyệt' THEN 1 END) AS SoCaChoDuyet,
        COUNT(CASE WHEN clv.LoaiCa = N'Ca sáng' THEN 1 END) AS SoCaSang,
        COUNT(CASE WHEN clv.LoaiCa = N'Ca chiều' THEN 1 END) AS SoCaChieu,
        COUNT(CASE WHEN clv.LoaiCa = N'Ca đêm' THEN 1 END) AS SoCaDem,
        k.TenKhoa
      FROM CALAMVIEC clv
      LEFT JOIN KHOA k ON clv.idKhoa = k.idKhoa
      WHERE ${whereConditions.join(' AND ')}
      GROUP BY k.idKhoa, k.TenKhoa
    `;
    
    const result = await prisma.$queryRawUnsafe(query);
    
    res.json({
      success: true,
      data: result
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

    console.log('Request body:', req.body);

    // Validation
    if (!idNhanVien || !NgayLamViec || !LoaiCa || !GioBD || !GioKT || !idKhoa) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập đầy đủ thông tin bắt buộc',
        missingFields: {
          idNhanVien: !idNhanVien,
          NgayLamViec: !NgayLamViec,
          LoaiCa: !LoaiCa,
          GioBD: !GioBD,
          GioKT: !GioKT,
          idKhoa: !idKhoa
        }
      });
    }

    // Format date
    const formattedDate = formatDateForSQL(NgayLamViec);
    if (!formattedDate) {
      return res.status(400).json({
        success: false,
        message: 'Ngày làm việc không hợp lệ'
      });
    }

    // Kiểm tra xung đột lịch
    const conflictQuery = `
      SELECT COUNT(*) as conflictCount
      FROM CALAMVIEC 
      WHERE idNhanVien = '${idNhanVien}' 
      AND NgayLamViec = '${formattedDate}'
      AND (
        (GioBD <= '${GioBD}' AND GioKT > '${GioBD}') OR
        (GioBD < '${GioKT}' AND GioKT >= '${GioKT}') OR
        (GioBD >= '${GioBD}' AND GioKT <= '${GioKT}')
      )
      AND TrangThai != N'Đã hủy'
    `;

    const conflictCheck = await prisma.$queryRawUnsafe(conflictQuery);

    if (conflictCheck[0]?.conflictCount > 0) {
      return res.status(400).json({
        success: false,
        message: 'Nhân viên đã có ca làm việc trùng thời gian trong ngày này'
      });
    }

    const idCaLamViec = generateId('CLV');
    
    const insertQuery = `
      INSERT INTO CALAMVIEC (
        idCaLamViec, NgayLamViec, LoaiCa, GioBD, GioKT, 
        TrangThai, LoaiCongViec, GhiChu, idNhanVien, 
        idKhoa, idLichTongThe
      ) VALUES (
        '${idCaLamViec}', 
        '${formattedDate}', 
        N'${LoaiCa}', 
        '${GioBD}', 
        '${GioKT}', 
        N'Chờ duyệt', 
        ${escapeSqlString(LoaiCongViec || 'Thường')}, 
        ${escapeSqlString(GhiChu)}, 
        '${idNhanVien}', 
        '${idKhoa}', 
        '${idLichTongThe || ''}'
      )
    `;

    console.log('Insert query:', insertQuery);
    await prisma.$executeRawUnsafe(insertQuery);

    res.status(201).json({
      success: true,
      message: 'Thêm ca làm việc thành công',
      data: { idCaLamViecMoi: idCaLamViec }
    });
  } catch (error) {
    console.error('Error in themCaLamViec:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi thêm ca làm việc',
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

    console.log('Update request - ID:', id);
    console.log('Update request - Body:', req.body);

    // Kiểm tra ca làm việc có tồn tại
    const existingSchedule = await prisma.$queryRawUnsafe(
      `SELECT * FROM CALAMVIEC WHERE idCaLamViec = '${id}'`
    );

    if (!existingSchedule.length) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy ca làm việc'
      });
    }

    // Format date nếu có thay đổi
    let formattedDate = null;
    if (NgayLamViec) {
      formattedDate = formatDateForSQL(NgayLamViec);
      if (!formattedDate) {
        return res.status(400).json({
          success: false,
          message: 'Ngày làm việc không hợp lệ'
        });
      }
    }

    // Kiểm tra xung đột nếu thay đổi nhân viên hoặc thời gian
    if (idNhanVien || NgayLamViec || GioBD || GioKT) {
      const targetEmployee = idNhanVien || existingSchedule[0].idNhanVien;
      const targetDate = formattedDate || formatDateForSQL(existingSchedule[0].NgayLamViec);
      const targetStartTime = GioBD || existingSchedule[0].GioBD;
      const targetEndTime = GioKT || existingSchedule[0].GioKT;

      const conflictQuery = `
        SELECT COUNT(*) as conflictCount
        FROM CALAMVIEC 
        WHERE idNhanVien = '${targetEmployee}' 
        AND NgayLamViec = '${targetDate}'
        AND idCaLamViec != '${id}'
        AND (
          (GioBD <= '${targetStartTime}' AND GioKT > '${targetStartTime}') OR
          (GioBD < '${targetEndTime}' AND GioKT >= '${targetEndTime}') OR
          (GioBD >= '${targetStartTime}' AND GioKT <= '${targetEndTime}')
        )
        AND TrangThai != N'Đã hủy'
      `;

      const conflictCheck = await prisma.$queryRawUnsafe(conflictQuery);

      if (conflictCheck[0]?.conflictCount > 0) {
        return res.status(400).json({
          success: false,
          message: 'Nhân viên đã có ca làm việc trùng thời gian trong ngày này'
        });
      }
    }

    // Cập nhật ca làm việc
    const updateFields = [];

    if (idNhanVien) updateFields.push(`idNhanVien = '${idNhanVien}'`);
    if (formattedDate) updateFields.push(`NgayLamViec = '${formattedDate}'`);
    if (LoaiCa) updateFields.push(`LoaiCa = N'${LoaiCa}'`);
    if (GioBD) updateFields.push(`GioBD = '${GioBD}'`);
    if (GioKT) updateFields.push(`GioKT = '${GioKT}'`);
    if (LoaiCongViec) updateFields.push(`LoaiCongViec = ${escapeSqlString(LoaiCongViec)}`);
    if (GhiChu !== undefined) updateFields.push(`GhiChu = ${escapeSqlString(GhiChu)}`);
    if (idKhoa) updateFields.push(`idKhoa = '${idKhoa}'`);

    if (updateFields.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Không có thông tin nào để cập nhật'
      });
    }

    const updateQuery = `
      UPDATE CALAMVIEC 
      SET ${updateFields.join(', ')}
      WHERE idCaLamViec = '${id}'
    `;

    console.log('Update query:', updateQuery);
    await prisma.$executeRawUnsafe(updateQuery);

    res.json({
      success: true,
      message: 'Cập nhật ca làm việc thành công'
    });
  } catch (error) {
    console.error('Error in suaCaLamViec:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi cập nhật ca làm việc',
      error: error.message
    });
  }
};

// Xác nhận ca làm việc
const xacNhanCaLamViec = async (req, res) => {
  try {
    const { id } = req.params;

    // Kiểm tra ca làm việc có tồn tại
    const existingSchedule = await prisma.$queryRawUnsafe(
      `SELECT * FROM CALAMVIEC WHERE idCaLamViec = '${id}'`
    );

    if (!existingSchedule.length) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy ca làm việc'
      });
    }

    await prisma.$executeRawUnsafe(`
      UPDATE CALAMVIEC 
      SET TrangThai = N'Đã duyệt', ThoiGianPheDuyet = GETDATE()
      WHERE idCaLamViec = '${id}'
    `);

    res.json({
      success: true,
      message: 'Xác nhận ca làm việc thành công'
    });
  } catch (error) {
    console.error('Error in xacNhanCaLamViec:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi xác nhận ca làm việc',
      error: error.message
    });
  }
};

// Xóa ca làm việc
const xoaCaLamViec = async (req, res) => {
  try {
    const { id } = req.params;

    // Kiểm tra ca làm việc có tồn tại
    const existingSchedule = await prisma.$queryRawUnsafe(
      `SELECT * FROM CALAMVIEC WHERE idCaLamViec = '${id}'`
    );

    if (!existingSchedule.length) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy ca làm việc'
      });
    }

    // Kiểm tra xem ca có đang được sử dụng trong yêu cầu chuyển ca không
    const transferCheck = await prisma.$queryRawUnsafe(`
      SELECT COUNT(*) as transferCount 
      FROM PYC_CHUYENCA 
      WHERE idCaLamViecGoc = '${id}' OR idCaLamViecMoi = '${id}' OR idCaLamViecBu = '${id}'
    `);

    if (transferCheck[0]?.transferCount > 0) {
      return res.status(400).json({
        success: false,
        message: 'Không thể xóa ca làm việc đang có yêu cầu chuyển ca'
      });
    }

    // Xóa các bản ghi liên quan trong bảng NGHIPHEP_ANHHUONGCA nếu có
    await prisma.$executeRawUnsafe(
      `DELETE FROM NGHIPHEP_ANHHUONGCA WHERE idCaLamViec = '${id}'`
    );

    // Xóa ca làm việc
    await prisma.$executeRawUnsafe(
      `DELETE FROM CALAMVIEC WHERE idCaLamViec = '${id}'`
    );

    res.json({
      success: true,
      message: 'Xóa ca làm việc thành công'
    });
  } catch (error) {
    console.error('Error in xoaCaLamViec:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi xóa ca làm việc',
      error: error.message
    });
  }
};

// Lấy chi tiết ca làm việc
const layChiTietCaLamViec = async (req, res) => {
  try {
    const { id } = req.params;
    const { idLichTongThe, NgayLamViec, idKhoa } = req.query;
    
    let whereConditions = [];

    if (id) whereConditions.push(`clv.idCaLamViec = '${id}'`);
    if (idLichTongThe) whereConditions.push(`clv.idLichTongThe = '${idLichTongThe}'`);
    if (NgayLamViec) whereConditions.push(`clv.NgayLamViec = '${NgayLamViec}'`);
    if (idKhoa) whereConditions.push(`clv.idKhoa = '${idKhoa}'`);

    if (whereConditions.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng cung cấp ít nhất một tham số để tìm kiếm'
      });
    }

    const query = `
      SELECT 
        clv.*,
        nv.HoTen AS HoTenNguoiDung,
        nv.GioiTinh,
        nv.SDT,
        nv.Email,
        k.TenKhoa,
        nd_tao.HoTen AS TenNguoiTao,
        nd_duyet.HoTen AS TenNguoiPheDuyet
      FROM CALAMVIEC clv
      LEFT JOIN NHANVIEN nv ON clv.idNhanVien = nv.idNhanVien
      LEFT JOIN KHOA k ON clv.idKhoa = k.idKhoa
      LEFT JOIN NGUOIDUNG nd_tao ON clv.idNguoiDung = nd_tao.idNguoiDung
      LEFT JOIN NGUOIDUNG nd_duyet ON clv.idNguoiPheDuyet = nd_duyet.idNguoiDung
      WHERE ${whereConditions.join(' AND ')}
    `;
    
    const result = await prisma.$queryRawUnsafe(query);
    
    if (result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy ca làm việc'
      });
    }
    
    res.json({
      success: true,
      data: result
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

// Kiểm tra xung đột lịch
const kiemTraXungDotLich = async (req, res) => {
  try {
    const { NgayBatDau, NgayKetThuc, idKhoa } = req.query;

    if (!NgayBatDau || !NgayKetThuc) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập đầy đủ thông tin: NgayBatDau, NgayKetThuc'
      });
    }

    let whereConditions = [`clv1.NgayLamViec BETWEEN '${NgayBatDau}' AND '${NgayKetThuc}'`];

    if (idKhoa) {
      whereConditions.push(`clv1.idKhoa = '${idKhoa}'`);
    }

    const query = `
      SELECT 
        clv1.idCaLamViec AS Ca1_ID,
        clv1.idNhanVien AS NhanVien_ID,
        nv.HoTen AS TenNhanVien,
        clv1.NgayLamViec,
        clv1.LoaiCa AS Ca1_LoaiCa,
        clv1.GioBD AS Ca1_GioBD,
        clv1.GioKT AS Ca1_GioKT,
        clv2.idCaLamViec AS Ca2_ID,
        clv2.LoaiCa AS Ca2_LoaiCa,
        clv2.GioBD AS Ca2_GioBD,
        clv2.GioKT AS Ca2_GioKT,
        k.TenKhoa
      FROM CALAMVIEC clv1
      INNER JOIN CALAMVIEC clv2 ON clv1.idNhanVien = clv2.idNhanVien 
        AND clv1.NgayLamViec = clv2.NgayLamViec 
        AND clv1.idCaLamViec != clv2.idCaLamViec
      LEFT JOIN NHANVIEN nv ON clv1.idNhanVien = nv.idNhanVien
      LEFT JOIN KHOA k ON clv1.idKhoa = k.idKhoa
      WHERE ${whereConditions.join(' AND ')}
        AND clv1.TrangThai != N'Đã hủy'
        AND clv2.TrangThai != N'Đã hủy'
        AND (
          (clv1.GioBD <= clv2.GioBD AND clv1.GioKT > clv2.GioBD) OR
          (clv1.GioBD < clv2.GioKT AND clv1.GioKT >= clv2.GioKT) OR
          (clv1.GioBD >= clv2.GioBD AND clv1.GioKT <= clv2.GioKT)
        )
      ORDER BY clv1.NgayLamViec, nv.HoTen
    `;
    
    const result = await prisma.$queryRawUnsafe(query);
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in kiemTraXungDotLich:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi kiểm tra xung đột lịch làm việc',
      error: error.message
    });
  }
};

// ============ YÊU CẦU CHUYỂN CA ============

// Lấy danh sách yêu cầu chuyển ca
const layDanhSachYeuCauChuyenCa = async (req, res) => {
  try {
    const { TrangThai, TuNgay, DenNgay } = req.query;
    
    let whereConditions = ['1=1'];
    
    if (TrangThai) {
      whereConditions.push(`pyc.TrangThai = N'${TrangThai}'`);
    }
    
    if (TuNgay && DenNgay) {
      whereConditions.push(`pyc.NgayYeuCau BETWEEN '${TuNgay}' AND '${DenNgay}'`);
    }

    const query = `
      SELECT 
        pyc.*,
        nv_cu.HoTen AS TenNhanVienCu,
        nv_moi.HoTen AS TenNhanVienMoi,
        ca_goc.NgayLamViec, 
        ca_goc.LoaiCa, 
        ca_goc.GioBD, 
        ca_goc.GioKT,
        nd_tao.HoTen AS TenNguoiTao,
        nd_duyet.HoTen AS TenNguoiPheDuyet
      FROM PYC_CHUYENCA pyc
      LEFT JOIN NHANVIEN nv_cu ON pyc.idNhanVienCu = nv_cu.idNhanVien
      LEFT JOIN NHANVIEN nv_moi ON pyc.idNhanVienMoi = nv_moi.idNhanVien
      LEFT JOIN CALAMVIEC ca_goc ON pyc.idCaLamViecGoc = ca_goc.idCaLamViec
      LEFT JOIN NGUOIDUNG nd_tao ON pyc.idNguoiDung = nd_tao.idNguoiDung
      LEFT JOIN NGUOIDUNG nd_duyet ON pyc.idNguoiPheDuyet = nd_duyet.idNguoiDung
      WHERE ${whereConditions.join(' AND ')}
      ORDER BY pyc.NgayYeuCau DESC
    `;
    
    const result = await prisma.$queryRawUnsafe(query);
    
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

// Helper function để format date cho SQL Server
const formatDateForSQL = (dateString) => {
  if (!dateString) return null;
  
  try {
    // Nếu là string date (YYYY-MM-DD)
    if (typeof dateString === 'string' && dateString.includes('-')) {
      const date = new Date(dateString + 'T00:00:00.000Z');
      if (isNaN(date.getTime())) return null;
      return date.toISOString().split('T')[0]; // Return YYYY-MM-DD format
    }
    
    // Nếu là Date object
    if (dateString instanceof Date) {
      if (isNaN(dateString.getTime())) return null;
      return dateString.toISOString().split('T')[0];
    }
    
    return null;
  } catch (error) {
    console.error('Error formatting date:', error);
    return null;
  }
};

// Tạo yêu cầu chuyển ca
const taoYeuCauChuyenCa = async (req, res) => {
  try {
    const {
      idCaLamViecGoc, idNhanVienMoi, NgayChuyen, LyDo,
      CanBuCa, GhiChu
    } = req.body;

    console.log('Tạo yêu cầu chuyển ca - Request body:', req.body);

    if (!idCaLamViecGoc || !idNhanVienMoi || !LyDo) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập đầy đủ thông tin bắt buộc',
        missingFields: {
          idCaLamViecGoc: !idCaLamViecGoc,
          idNhanVienMoi: !idNhanVienMoi,
          LyDo: !LyDo
        }
      });
    }

    // Kiểm tra ca làm việc gốc có tồn tại
    const originalShift = await prisma.$queryRawUnsafe(
      `SELECT * FROM CALAMVIEC WHERE idCaLamViec = '${idCaLamViecGoc}'`
    );

    if (!originalShift.length) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy ca làm việc gốc'
      });
    }

    console.log('Original shift:', originalShift[0]);

    // Kiểm tra nhân viên mới có tồn tại
    const newEmployee = await prisma.$queryRawUnsafe(
      `SELECT * FROM NHANVIEN WHERE idNhanVien = '${idNhanVienMoi}'`
    );

    if (!newEmployee.length) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy nhân viên thay thế'
      });
    }

    // Format date cho NgayChuyen
    const formattedNgayChuyen = formatDateForSQL(NgayChuyen);
    const formattedOriginalDate = formatDateForSQL(originalShift[0].NgayLamViec);
    
    // Sử dụng ngày của ca gốc nếu NgayChuyen không có hoặc invalid
    const finalNgayChuyen = formattedNgayChuyen || formattedOriginalDate;
    
    console.log('Date formatting:', {
      NgayChuyen,
      formattedNgayChuyen,
      originalDate: originalShift[0].NgayLamViec,
      formattedOriginalDate,
      finalNgayChuyen
    });

    if (!finalNgayChuyen) {
      return res.status(400).json({
        success: false,
        message: 'Ngày chuyển ca không hợp lệ'
      });
    }

    // Kiểm tra xung đột lịch của nhân viên mới
    const conflictQuery = `
      SELECT COUNT(*) as conflictCount
      FROM CALAMVIEC 
      WHERE idNhanVien = '${idNhanVienMoi}' 
      AND NgayLamViec = '${formattedOriginalDate}'
      AND (
        (GioBD <= '${originalShift[0].GioBD}' AND GioKT > '${originalShift[0].GioBD}') OR
        (GioBD < '${originalShift[0].GioKT}' AND GioKT >= '${originalShift[0].GioKT}') OR
        (GioBD >= '${originalShift[0].GioBD}' AND GioKT <= '${originalShift[0].GioKT}')
      )
      AND TrangThai != N'Đã hủy'
    `;

    const conflictCheck = await prisma.$queryRawUnsafe(conflictQuery);

    if (conflictCheck[0]?.conflictCount > 0) {
      return res.status(400).json({
        success: false,
        message: 'Nhân viên thay thế đã có ca làm việc trùng thời gian'
      });
    }

    const idYeuCau = generateId('YCC');
    
    const insertQuery = `
      INSERT INTO PYC_CHUYENCA (
        idYeuCauChuyenCa, NgayChuyen, LyDo, TrangThai, NgayYeuCau,
        CanBuCa, GhiChu, idNhanVienCu, idNhanVienMoi, idCaLamViecGoc
      ) VALUES (
        '${idYeuCau}', 
        '${finalNgayChuyen}', 
        ${escapeSqlString(LyDo)}, 
        N'Chờ duyệt', 
        GETDATE(), 
        ${CanBuCa ? 1 : 0}, 
        ${escapeSqlString(GhiChu)}, 
        '${originalShift[0].idNhanVien}', 
        '${idNhanVienMoi}', 
        '${idCaLamViecGoc}'
      )
    `;

    console.log('Insert query:', insertQuery);
    await prisma.$executeRawUnsafe(insertQuery);

    res.status(201).json({
      success: true,
      message: 'Tạo yêu cầu chuyển ca thành công',
      data: { idYeuCauMoi: idYeuCau }
    });
  } catch (error) {
    console.error('Error in taoYeuCauChuyenCa:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi tạo yêu cầu chuyển ca',
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

    // Kiểm tra yêu cầu có tồn tại và chưa được xử lý
    const existingRequest = await prisma.$queryRawUnsafe(
      `SELECT * FROM PYC_CHUYENCA WHERE idYeuCauChuyenCa = '${id}'`
    );

    if (!existingRequest.length) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy yêu cầu chuyển ca'
      });
    }

    if (existingRequest[0].TrangThai !== 'Chờ duyệt') {
      return res.status(400).json({
        success: false,
        message: 'Chỉ có thể sửa yêu cầu chưa được xử lý'
      });
    }

    // Cập nhật thông tin
    const updateFields = [];

    if (idNhanVienMoi) updateFields.push(`idNhanVienMoi = '${idNhanVienMoi}'`);
    
    if (NgayChuyen) {
      const formattedNgayChuyen = formatDateForSQL(NgayChuyen);
      if (!formattedNgayChuyen) {
        return res.status(400).json({
          success: false,
          message: 'Ngày chuyển không hợp lệ'
        });
      }
      updateFields.push(`NgayChuyen = '${formattedNgayChuyen}'`);
    }
    
    if (LyDo) updateFields.push(`LyDo = ${escapeSqlString(LyDo)}`);
    if (CanBuCa !== undefined) updateFields.push(`CanBuCa = ${CanBuCa ? 1 : 0}`);
    if (GhiChu !== undefined) updateFields.push(`GhiChu = ${escapeSqlString(GhiChu)}`);

    if (updateFields.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Không có thông tin nào để cập nhật'
      });
    }

    const updateQuery = `
      UPDATE PYC_CHUYENCA 
      SET ${updateFields.join(', ')}
      WHERE idYeuCauChuyenCa = '${id}'
    `;

    await prisma.$executeRawUnsafe(updateQuery);

    res.json({
      success: true,
      message: 'Cập nhật yêu cầu chuyển ca thành công'
    });
  } catch (error) {
    console.error('Error in suaYeuCauChuyenCa:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi cập nhật yêu cầu chuyển ca',
      error: error.message
    });
  }
};

// Xử lý yêu cầu chuyển ca
const xuLyYeuCauChuyenCa = async (req, res) => {
  try {
    const { id } = req.params;
    const { IsApproved, GhiChuPheDuyet } = req.body;

    // Kiểm tra yêu cầu có tồn tại
    const request = await prisma.$queryRawUnsafe(
      `SELECT * FROM PYC_CHUYENCA WHERE idYeuCauChuyenCa = '${id}'`
    );

    if (!request.length) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy yêu cầu chuyển ca'
      });
    }

    if (request[0].TrangThai !== 'Chờ duyệt') {
      return res.status(400).json({
        success: false,
        message: 'Yêu cầu đã được xử lý trước đó'
      });
    }

    const newStatus = IsApproved ? 'Đã duyệt' : 'Từ chối';

    // Cập nhật trạng thái yêu cầu
    await prisma.$executeRawUnsafe(`
      UPDATE PYC_CHUYENCA 
      SET TrangThai = N'${newStatus}', NgayPheDuyet = GETDATE(), GhiChuPheDuyet = ${escapeSqlString(GhiChuPheDuyet)}
      WHERE idYeuCauChuyenCa = '${id}'
    `);

    // Nếu được phê duyệt, cập nhật ca làm việc
    if (IsApproved) {
      await prisma.$executeRawUnsafe(`
        UPDATE CALAMVIEC 
        SET idNhanVien = '${request[0].idNhanVienMoi}'
        WHERE idCaLamViec = '${request[0].idCaLamViecGoc}'
      `);

      // Nếu cần bù ca, tạo ca bù cho nhân viên cũ
      if (request[0].CanBuCa) {
        const idCaBu = generateId('CLV');
        const originalShift = await prisma.$queryRawUnsafe(
          `SELECT * FROM CALAMVIEC WHERE idCaLamViec = '${request[0].idCaLamViecGoc}'`
        );

        if (originalShift.length) {
          // Format date cho ca bù
          const formattedBuDate = formatDateForSQL(request[0].NgayChuyen) || formatDateForSQL(originalShift[0].NgayLamViec);

          await prisma.$executeRawUnsafe(`
            INSERT INTO CALAMVIEC (
              idCaLamViec, NgayLamViec, LoaiCa, GioBD, GioKT,
              TrangThai, LoaiCongViec, GhiChu, idNhanVien, idKhoa
            ) VALUES (
              '${idCaBu}', 
              '${formattedBuDate}',
              N'${originalShift[0].LoaiCa}', 
              '${originalShift[0].GioBD}', 
              '${originalShift[0].GioKT}',
              N'Chờ duyệt', 
              N'Ca bù', 
              N'Ca bù cho chuyển ca', 
              '${request[0].idNhanVienCu}', 
              '${originalShift[0].idKhoa}'
            )
          `);

          // Cập nhật ID ca bù trong yêu cầu
          await prisma.$executeRawUnsafe(`
            UPDATE PYC_CHUYENCA SET idCaLamViecBu = '${idCaBu}' WHERE idYeuCauChuyenCa = '${id}'
          `);
        }
      }
    }

    res.json({
      success: true,
      message: `${IsApproved ? 'Phê duyệt' : 'Từ chối'} yêu cầu chuyển ca thành công`
    });
  } catch (error) {
    console.error('Error in xuLyYeuCauChuyenCa:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi xử lý yêu cầu chuyển ca',
      error: error.message
    });
  }
};

// Xóa yêu cầu chuyển ca
const xoaYeuCauChuyenCa = async (req, res) => {
  try {
    const { id } = req.params;

    // Kiểm tra yêu cầu có tồn tại
    const existingRequest = await prisma.$queryRawUnsafe(
      `SELECT * FROM PYC_CHUYENCA WHERE idYeuCauChuyenCa = '${id}'`
    );

    if (!existingRequest.length) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy yêu cầu chuyển ca'
      });
    }

    if (existingRequest[0].TrangThai === 'Đã duyệt') {
      return res.status(400).json({
        success: false,
        message: 'Không thể xóa yêu cầu đã được phê duyệt'
      });
    }

    await prisma.$executeRawUnsafe(
      `DELETE FROM PYC_CHUYENCA WHERE idYeuCauChuyenCa = '${id}'`
    );

    res.json({
      success: true,
      message: 'Xóa yêu cầu chuyển ca thành công'
    });
  } catch (error) {
    console.error('Error in xoaYeuCauChuyenCa:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi xóa yêu cầu chuyển ca',
      error: error.message
    });
  }
};

// Lấy chi tiết yêu cầu chuyển ca
const layChiTietYeuCauChuyenCa = async (req, res) => {
  try {
    const { id } = req.params;
    
    const query = `
      SELECT 
        pyc.*,
        nv_cu.HoTen AS TenNhanVienCu,
        nv_cu.SDT AS SDTNhanVienCu,
        nv_moi.HoTen AS TenNhanVienMoi,
        nv_moi.SDT AS SDTNhanVienMoi,
        ca_goc.NgayLamViec, 
        ca_goc.LoaiCa, 
        ca_goc.GioBD, 
        ca_goc.GioKT,
        ca_goc.LoaiCongViec,
        k.TenKhoa,
        nd_tao.HoTen AS TenNguoiTao,
        nd_duyet.HoTen AS TenNguoiPheDuyet
      FROM PYC_CHUYENCA pyc
      LEFT JOIN NHANVIEN nv_cu ON pyc.idNhanVienCu = nv_cu.idNhanVien
      LEFT JOIN NHANVIEN nv_moi ON pyc.idNhanVienMoi = nv_moi.idNhanVien
      LEFT JOIN CALAMVIEC ca_goc ON pyc.idCaLamViecGoc = ca_goc.idCaLamViec
      LEFT JOIN KHOA k ON ca_goc.idKhoa = k.idKhoa
      LEFT JOIN NGUOIDUNG nd_tao ON pyc.idNguoiDung = nd_tao.idNguoiDung
      LEFT JOIN NGUOIDUNG nd_duyet ON pyc.idNguoiPheDuyet = nd_duyet.idNguoiDung
      WHERE pyc.idYeuCauChuyenCa = '${id}'
    `;
    
    const result = await prisma.$queryRawUnsafe(query);
    
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
    
    let whereConditions = ['1=1'];
    
    if (TrangThai) {
      whereConditions.push(`dnp.TrangThai = N'${TrangThai}'`);
    }
    
    if (TuNgay && DenNgay) {
      whereConditions.push(`dnp.NgayLap BETWEEN '${TuNgay}' AND '${DenNgay}'`);
    }

    const query = `
      SELECT 
        dnp.*,
        nv.HoTen AS TenNhanVien,
        nd_duyet.HoTen AS TenNguoiPheDuyet,
        nv_thaythe.HoTen AS TenNhanVienThayThe
      FROM DON_NGHIPHEP dnp
      LEFT JOIN NHANVIEN nv ON dnp.idNhanVien = nv.idNhanVien
      LEFT JOIN NGUOIDUNG nd_duyet ON dnp.idNguoiPheDuyet = nd_duyet.idNguoiDung
      LEFT JOIN NHANVIEN nv_thaythe ON dnp.idNhanVienThayThe = nv_thaythe.idNhanVien
      WHERE ${whereConditions.join(' AND ')}
      ORDER BY dnp.NgayLap DESC
    `;
    
    const result = await prisma.$queryRawUnsafe(query);
    
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

    console.log('Tạo đơn nghỉ phép - Request body:', req.body);

    if (!LoaiPhep || !NgayBD || !NgayKT || !LyDo) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập đầy đủ thông tin bắt buộc',
        missingFields: {
          LoaiPhep: !LoaiPhep,
          NgayBD: !NgayBD,
          NgayKT: !NgayKT,
          LyDo: !LyDo
        }
      });
    }

    // Format dates
    const formattedNgayBD = formatDateForSQL(NgayBD);
    const formattedNgayKT = formatDateForSQL(NgayKT);

    if (!formattedNgayBD || !formattedNgayKT) {
      return res.status(400).json({
        success: false,
        message: 'Ngày bắt đầu hoặc ngày kết thúc không hợp lệ'
      });
    }

    // Kiểm tra ngày hợp lệ
    if (new Date(formattedNgayKT) < new Date(formattedNgayBD)) {
      return res.status(400).json({
        success: false,
        message: 'Ngày kết thúc phải sau ngày bắt đầu'
      });
    }

    const idNghiPhep = generateId('DNP');
    
    const insertQuery = `
      INSERT INTO DON_NGHIPHEP (
        idNghiPhep, LoaiPhep, NgayBD, NgayKT, GioBD, GioKT,
        NghiCaNgay, TongNgayNghi, LyDo, TrangThai, NgayLap,
        HoTenNguoiLienHe, SDTNguoiLienHe, MoiQuanHe, GhiChu, idNhanVienThayThe
      ) VALUES (
        '${idNghiPhep}', 
        N'${LoaiPhep}', 
        '${formattedNgayBD}', 
        '${formattedNgayKT}', 
        '${GioBD || ''}', 
        '${GioKT || ''}',
        ${NghiCaNgay ? 1 : 0}, 
        ${TongNgayNghi || 1}, 
        ${escapeSqlString(LyDo)}, 
        N'Chờ duyệt', 
        GETDATE(),
        ${escapeSqlString(HoTenNguoiLienHe)}, 
        ${escapeSqlString(SDTNguoiLienHe)}, 
        ${escapeSqlString(MoiQuanHe)}, 
        ${escapeSqlString(GhiChu)}, 
        '${idNhanVienThayThe || ''}'
      )
    `;

    console.log('Insert query:', insertQuery);
    await prisma.$executeRawUnsafe(insertQuery);

    res.status(201).json({
      success: true,
      message: 'Tạo đơn nghỉ phép thành công',
      data: { idNghiPhepMoi: idNghiPhep }
    });
  } catch (error) {
    console.error('Error in taoDonNghiPhep:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi tạo đơn nghỉ phép',
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

    // Kiểm tra đơn có tồn tại và chưa được xử lý
    const existingLeave = await prisma.$queryRawUnsafe(
      `SELECT * FROM DON_NGHIPHEP WHERE idNghiPhep = '${id}'`
    );

    if (!existingLeave.length) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy đơn nghỉ phép'
      });
    }

    if (existingLeave[0].TrangThai !== 'Chờ duyệt') {
      return res.status(400).json({
        success: false,
        message: 'Chỉ có thể sửa đơn chưa được xử lý'
      });
    }

    // Cập nhật thông tin
    const updateFields = [];

    if (LoaiPhep) updateFields.push(`LoaiPhep = N'${LoaiPhep}'`);
    
    if (NgayBD) {
      const formattedNgayBD = formatDateForSQL(NgayBD);
      if (!formattedNgayBD) {
        return res.status(400).json({
          success: false,
          message: 'Ngày bắt đầu không hợp lệ'
        });
      }
      updateFields.push(`NgayBD = '${formattedNgayBD}'`);
    }
    
    if (NgayKT) {
      const formattedNgayKT = formatDateForSQL(NgayKT);
      if (!formattedNgayKT) {
        return res.status(400).json({
          success: false,
          message: 'Ngày kết thúc không hợp lệ'
        });
      }
      updateFields.push(`NgayKT = '${formattedNgayKT}'`);
    }
    
    if (GioBD) updateFields.push(`GioBD = '${GioBD}'`);
    if (GioKT) updateFields.push(`GioKT = '${GioKT}'`);
    if (NghiCaNgay !== undefined) updateFields.push(`NghiCaNgay = ${NghiCaNgay ? 1 : 0}`);
    if (TongNgayNghi) updateFields.push(`TongNgayNghi = ${TongNgayNghi}`);
    if (LyDo) updateFields.push(`LyDo = ${escapeSqlString(LyDo)}`);
    if (HoTenNguoiLienHe !== undefined) updateFields.push(`HoTenNguoiLienHe = ${escapeSqlString(HoTenNguoiLienHe)}`);
    if (SDTNguoiLienHe !== undefined) updateFields.push(`SDTNguoiLienHe = ${escapeSqlString(SDTNguoiLienHe)}`);
    if (MoiQuanHe !== undefined) updateFields.push(`MoiQuanHe = ${escapeSqlString(MoiQuanHe)}`);
    if (GhiChu !== undefined) updateFields.push(`GhiChu = ${escapeSqlString(GhiChu)}`);
    if (idNhanVienThayThe !== undefined) updateFields.push(`idNhanVienThayThe = '${idNhanVienThayThe}'`);

    if (updateFields.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Không có thông tin nào để cập nhật'
      });
    }

    const updateQuery = `
      UPDATE DON_NGHIPHEP 
      SET ${updateFields.join(', ')}
      WHERE idNghiPhep = '${id}'
    `;

    await prisma.$executeRawUnsafe(updateQuery);

    res.json({
      success: true,
      message: 'Cập nhật đơn nghỉ phép thành công'
    });
  } catch (error) {
    console.error('Error in suaDonNghiPhep:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi cập nhật đơn nghỉ phép',
      error: error.message
    });
  }
};

// Xử lý đơn nghỉ phép
const xuLyDonNghiPhep = async (req, res) => {
  try {
    const { id } = req.params;
    const { IsApproved, GhiChuPheDuyet } = req.body;

    // Kiểm tra đơn có tồn tại
    const leave = await prisma.$queryRawUnsafe(
      `SELECT * FROM DON_NGHIPHEP WHERE idNghiPhep = '${id}'`
    );

    if (!leave.length) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy đơn nghỉ phép'
      });
    }

    if (leave[0].TrangThai !== 'Chờ duyệt') {
      return res.status(400).json({
        success: false,
        message: 'Đơn nghỉ phép đã được xử lý trước đó'
      });
    }

    const newStatus = IsApproved ? 'Đã duyệt' : 'Từ chối';

    // Cập nhật trạng thái đơn nghỉ phép
    await prisma.$executeRawUnsafe(`
      UPDATE DON_NGHIPHEP 
      SET TrangThai = N'${newStatus}', NgayPheDuyet = GETDATE(), GhiChuPheDuyet = ${escapeSqlString(GhiChuPheDuyet)}
      WHERE idNghiPhep = '${id}'
    `);

    // Nếu được phê duyệt, tìm và cập nhật các ca làm việc bị ảnh hưởng
    if (IsApproved) {
      // Format dates để tìm ca bị ảnh hưởng
      const formattedNgayBD = formatDateForSQL(leave[0].NgayBD);
      const formattedNgayKT = formatDateForSQL(leave[0].NgayKT);

      if (formattedNgayBD && formattedNgayKT) {
        const affectedShifts = await prisma.$queryRawUnsafe(`
          SELECT idCaLamViec 
          FROM CALAMVIEC 
          WHERE idNhanVien = '${leave[0].idNhanVien}' 
          AND NgayLamViec BETWEEN '${formattedNgayBD}' AND '${formattedNgayKT}'
          AND TrangThai != N'Đã hủy'
        `);

        // Ghi nhận các ca bị ảnh hưởng
        for (const shift of affectedShifts) {
          await prisma.$executeRawUnsafe(`
            INSERT INTO NGHIPHEP_ANHHUONGCA (idNghiPhep, idCaLamViec)
            VALUES ('${id}', '${shift.idCaLamViec}')
          `);
        }

        // Cập nhật trạng thái các ca bị ảnh hưởng
        if (affectedShifts.length > 0) {
          const shiftIds = affectedShifts.map(s => `'${s.idCaLamViec}'`).join(',');
          await prisma.$executeRawUnsafe(`
            UPDATE CALAMVIEC 
            SET TrangThai = N'Nghỉ phép', GhiChu = CONCAT(ISNULL(GhiChu, ''), N' - Nghỉ phép: ${id}')
            WHERE idCaLamViec IN (${shiftIds})
          `);
        }
      }
    }

    res.json({
      success: true,
      message: `${IsApproved ? 'Phê duyệt' : 'Từ chối'} đơn nghỉ phép thành công`
    });
  } catch (error) {
    console.error('Error in xuLyDonNghiPhep:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi xử lý đơn nghỉ phép',
      error: error.message
    });
  }
};

// Xóa đơn nghỉ phép
const xoaDonNghiPhep = async (req, res) => {
  try {
    const { id } = req.params;

    // Kiểm tra đơn có tồn tại
    const existingLeave = await prisma.$queryRawUnsafe(
      `SELECT * FROM DON_NGHIPHEP WHERE idNghiPhep = '${id}'`
    );

    if (!existingLeave.length) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy đơn nghỉ phép'
      });
    }

    if (existingLeave[0].TrangThai === 'Đã duyệt') {
      return res.status(400).json({
        success: false,
        message: 'Không thể xóa đơn nghỉ phép đã được phê duyệt'
      });
    }

    // Xóa các bản ghi liên quan
    await prisma.$executeRawUnsafe(
      `DELETE FROM NGHIPHEP_ANHHUONGCA WHERE idNghiPhep = '${id}'`
    );

    // Xóa đơn nghỉ phép
    await prisma.$executeRawUnsafe(
      `DELETE FROM DON_NGHIPHEP WHERE idNghiPhep = '${id}'`
    );

    res.json({
      success: true,
      message: 'Xóa đơn nghỉ phép thành công'
    });
  } catch (error) {
    console.error('Error in xoaDonNghiPhep:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi xóa đơn nghỉ phép',
      error: error.message
    });
  }
};

// Lấy chi tiết đơn nghỉ phép
const layChiTietDonNghiPhep = async (req, res) => {
  try {
    const { id } = req.params;
    
    const query = `
      SELECT 
        dnp.*,
        nv.HoTen AS TenNhanVien,
        nv.SDT AS SDTNhanVien,
        nv.Email AS EmailNhanVien,
        nd_duyet.HoTen AS TenNguoiPheDuyet,
        nv_thaythe.HoTen AS TenNhanVienThayThe,
        nv_thaythe.SDT AS SDTNhanVienThayThe
      FROM DON_NGHIPHEP dnp
      LEFT JOIN NHANVIEN nv ON dnp.idNhanVien = nv.idNhanVien
      LEFT JOIN NGUOIDUNG nd_duyet ON dnp.idNguoiPheDuyet = nd_duyet.idNguoiDung
      LEFT JOIN NHANVIEN nv_thaythe ON dnp.idNhanVienThayThe = nv_thaythe.idNhanVien
      WHERE dnp.idNghiPhep = '${id}'
    `;
    
    const result = await prisma.$queryRawUnsafe(query);
    
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
    
    const query = `
      SELECT 
        clv.*,
        nv.HoTen AS HoTenNguoiDung,
        k.TenKhoa
      FROM NGHIPHEP_ANHHUONGCA nac
      INNER JOIN CALAMVIEC clv ON nac.idCaLamViec = clv.idCaLamViec
      LEFT JOIN NHANVIEN nv ON clv.idNhanVien = nv.idNhanVien
      LEFT JOIN KHOA k ON clv.idKhoa = k.idKhoa
      WHERE nac.idNghiPhep = '${id}'
      ORDER BY clv.NgayLamViec, clv.GioBD
    `;
    
    const result = await prisma.$queryRawUnsafe(query);
    
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
    
    let whereConditions = ['1=1'];
    
    if (idKhoa) {
      whereConditions.push(`nv.idKhoa = '${idKhoa}'`);
    }
    
    const query = `
      SELECT 
        nv.*,
        k.TenKhoa AS department
      FROM NHANVIEN nv
      LEFT JOIN KHOA k ON nv.idKhoa = k.idKhoa
      WHERE ${whereConditions.join(' AND ')}
      ORDER BY nv.HoTen
    `;
    
    const result = await prisma.$queryRawUnsafe(query);
    
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
    const query = `
      SELECT idKhoa, TenKhoa, ViTri, TruongKhoa
      FROM KHOA 
      WHERE TrangThai = N'Đang Hoạt động' 
      ORDER BY TenKhoa
    `;
    
    const result = await prisma.$queryRawUnsafe(query);
    
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
};