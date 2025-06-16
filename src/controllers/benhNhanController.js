const prisma = require('../utils/prisma');

// Thêm bệnh nhân mới
const themBenhNhan = async (req, res) => {
  try {
    const {
      HoTen, NgaySinh, GioiTinh, NgheNghiep, DanToc, SDT, DiaChi,
      CCCD, BHYT, ThoiHanBHYT, DoiTuongUuTien, HoTenThanNhan,
      MoiQuanHe, SDTThanNhan, BenhManTinh, DiUng, PhauThuatDaLam,
      TrangThai, idLoaiBHYT
    } = req.body;

    const result = await prisma.$executeRaw`
      DECLARE @idBenhNhanMoi CHAR(10);
      EXEC sp_ThemBenhNhan 
        @HoTen = ${HoTen},
        @NgaySinh = ${NgaySinh},
        @GioiTinh = ${GioiTinh},
        @NgheNghiep = ${NgheNghiep},
        @DanToc = ${DanToc},
        @SDT = ${SDT},
        @DiaChi = ${DiaChi},
        @CCCD = ${CCCD},
        @BHYT = ${BHYT},
        @ThoiHanBHYT = ${ThoiHanBHYT},
        @DoiTuongUuTien = ${DoiTuongUuTien},
        @HoTenThanNhan = ${HoTenThanNhan},
        @MoiQuanHe = ${MoiQuanHe},
        @SDTThanNhan = ${SDTThanNhan},
        @BenhManTinh = ${BenhManTinh},
        @DiUng = ${DiUng},
        @PhauThuatDaLam = ${PhauThuatDaLam},
        @TrangThai = ${TrangThai},
        @idLoaiBHYT = ${idLoaiBHYT},
        @idBenhNhanMoi = @idBenhNhanMoi OUTPUT;
      SELECT @idBenhNhanMoi as idBenhNhanMoi;
    `;

    res.status(201).json({
      success: true,
      message: 'Thêm bệnh nhân thành công',
      data: result
    });
  } catch (error) {
    console.error('Error in themBenhNhan:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi thêm bệnh nhân',
      error: error.message
    });
  }
};

// Lấy tất cả bệnh nhân
const layTatCaBenhNhan = async (req, res) => {
  try {
    const result = await prisma.$queryRaw`EXEC sp_LayTatCaBenhNhan`;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layTatCaBenhNhan:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách bệnh nhân',
      error: error.message
    });
  }
};

// Tìm kiếm bệnh nhân
const timKiemBenhNhan = async (req, res) => {
  try {
    const { tuKhoa } = req.query;
    
    if (!tuKhoa) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập từ khóa tìm kiếm'
      });
    }

    const result = await prisma.$queryRaw`
      EXEC sp_TimKiemBenhNhan @TuKhoa = ${tuKhoa}
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in timKiemBenhNhan:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi tìm kiếm bệnh nhân',
      error: error.message
    });
  }
};

// Lấy bệnh nhân theo ID
const layBenhNhanTheoID = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_LayBenhNhanTheoID @idBenhNhan = ${id}
    `;
    
    if (result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy bệnh nhân'
      });
    }
    
    res.json({
      success: true,
      data: result[0]
    });
  } catch (error) {
    console.error('Error in layBenhNhanTheoID:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thông tin bệnh nhân',
      error: error.message
    });
  }
};

module.exports = {
  themBenhNhan,
  layTatCaBenhNhan,
  timKiemBenhNhan,
  layBenhNhanTheoID
};