const prisma = require('../utils/prisma');

const themPDKTiemChung = async (req, res) => {
  try {
    const { 
      idDKTiemChung,
      NgayLap,
      NgayTiem,
      HoTenNguoiLienHe,
      QuanHe,
      SDT_LienHe,
      Email,
      ThoiGianTiem,
      LieuTiem,
      GhiChu,
      TrangThai,
      idVacXin,
      idNguoiDung,
      idBenhNhan 
    } = req.body;

    await prisma.$executeRaw`
      EXEC ThemMoiPDKTiemChung 
        @idDKTiemChung = ${idDKTiemChung},
        @NgayLap = ${NgayLap},
        @NgayTiem = ${NgayTiem},
        @HoTenNguoiLienHe = ${HoTenNguoiLienHe},
        @QuanHe = ${QuanHe},
        @SDT_LienHe = ${SDT_LienHe},
        @Email = ${Email},
        @ThoiGianTiem = ${ThoiGianTiem},
        @LieuTiem = ${LieuTiem},
        @GhiChu = ${GhiChu},
        @TrangThai = ${TrangThai},
        @idVacXin = ${idVacXin},
        @idNguoiDung = ${idNguoiDung},
        @idBenhNhan = ${idBenhNhan}
    `;

    res.json({
      success: true,
      message: 'Thêm phiếu đăng ký tiêm chủng thành công'
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi thêm phiếu đăng ký tiêm chủng',
      error: error.message
    });
  }
};

// Lấy chi tiết phiếu đăng ký theo ID
const chiTietPDK = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC ChiTietPDKTiemChung @idDKTiemChung = ${id}
    `;
    
    if (result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy phiếu đăng ký'
      });
    }
    
    res.json({
      success: true,
      data: result[0]
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thông tin phiếu đăng ký',
      error: error.message
    });
  }
};

// Lấy tất cả phiếu đăng ký tiêm chủng
const layTatCaPDKTiemChung = async (req, res) => {
  try {
    const result = await prisma.$queryRaw`
      EXEC LayTatCaPDKTiemChung
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layTatCaPDKTiemChung:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách phiếu đăng ký tiêm chủng',
      error: error.message
    });
  }
};

const huyPDKTiemChung = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await prisma.$queryRaw`
      EXEC HuyPDKTiemChung @idDKTiemChung = ${id}
    `;
    res.json({
      success: true,
      message: 'Hủy phiếu đăng ký thành công',
      data: result
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi hủy phiếu đăng ký',
      error: error.message
    });
  }
};

const suaPDKTiemChung = async (req, res) => {
  try {
    const { id } = req.params;
    const { 
      NgayLap,
      NgayTiem,
      HoTenNguoiLienHe,
      QuanHe,
      SDT_LienHe,
      Email,
      ThoiGianTiem,
      LieuTiem,
      GhiChu,
      TrangThai,
      idVacXin,
      idNguoiDung,
      idBenhNhan 
    } = req.body;

    await prisma.$executeRaw`
      EXEC SuaPDKTiemChung 
        @idDKTiemChung = ${id},
        @NgayLap = ${NgayLap},
        @NgayTiem = ${NgayTiem},
        @HoTenNguoiLienHe = ${HoTenNguoiLienHe},
        @QuanHe = ${QuanHe},
        @SDT_LienHe = ${SDT_LienHe},
        @Email = ${Email},
        @ThoiGianTiem = ${ThoiGianTiem},
        @LieuTiem = ${LieuTiem},
        @GhiChu = ${GhiChu},
        @TrangThai = ${TrangThai},
        @idVacXin = ${idVacXin},
        @idNguoiDung = ${idNguoiDung},
        @idBenhNhan = ${idBenhNhan}
    `;

    res.json({
      success: true,
      message: 'Cập nhật phiếu đăng ký thành công'
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi cập nhật phiếu đăng ký',
      error: error.message
    });
  }
};

module.exports = {
  themPDKTiemChung,
  chiTietPDK,
  layTatCaPDKTiemChung,
  huyPDKTiemChung,
  suaPDKTiemChung
};