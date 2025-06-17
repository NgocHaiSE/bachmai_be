const prisma = require('../utils/prisma');

// Thêm phiếu đăng ký khám
const themPhieuDangKyKham = async (req, res) => {
  try {
    const {
      LyDoKham, ThoiGianBatDauTrieuChung, PhongKhamSo,
      TienSuBenhLyBanThan, TienSuBenhLyGiaDinh, ThuocDangSuDung,
      KhamBHYT, idBenhNhan, idKhoa
    } = req.body;
    console.log(req.body);

    const result = await prisma.$executeRaw`
      DECLARE @idDKKhambenhMoi CHAR(10);
      EXEC sp_ThemPhieuDangKyKham 
        @LyDoKham = ${LyDoKham},
        @ThoiGianBatDauTrieuChung = ${ThoiGianBatDauTrieuChung},
        @PhongKhamSo = ${PhongKhamSo},
        @TienSuBenhLyBanThan = ${TienSuBenhLyBanThan},
        @TienSuBenhLyGiaDinh = ${TienSuBenhLyGiaDinh},
        @ThuocDangSuDung = ${ThuocDangSuDung},
        @KhamBHYT = ${KhamBHYT},
        @idBenhNhan = ${idBenhNhan},
        @idKhoa = ${idKhoa},
        @idDKKhambenhMoi = @idDKKhambenhMoi OUTPUT;
      SELECT @idDKKhambenhMoi as idDKKhambenhMoi;
    `;

    res.status(201).json({
      success: true,
      message: 'Lập phiếu đăng ký khám thành công',
      data: result
    });
  } catch (error) {
    console.error('Error in themPhieuDangKyKham:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lập phiếu đăng ký khám',
      error: error.message
    });
  }
};

// Sửa phiếu đăng ký khám
const suaPhieuDangKyKham = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      LyDoKham, ThoiGianBatDauTrieuChung, PhongKhamSo,
      TienSuBenhLyBanThan, TienSuBenhLyGiaDinh, ThuocDangSuDung,
      KhamBHYT, idKhoa
    } = req.body;

    await prisma.$executeRaw`
      EXEC sp_SuaPhieuDangKyKham 
        @idDKKhambenh = ${id},
        @LyDoKham = ${LyDoKham},
        @ThoiGianBatDauTrieuChung = ${ThoiGianBatDauTrieuChung},
        @PhongKhamSo = ${PhongKhamSo},
        @TienSuBenhLyBanThan = ${TienSuBenhLyBanThan},
        @TienSuBenhLyGiaDinh = ${TienSuBenhLyGiaDinh},
        @ThuocDangSuDung = ${ThuocDangSuDung},
        @KhamBHYT = ${KhamBHYT},
        @idKhoa = ${idKhoa}
    `;

    res.json({
      success: true,
      message: 'Cập nhật phiếu đăng ký khám thành công'
    });
  } catch (error) {
    console.error('Error in suaPhieuDangKyKham:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi cập nhật phiếu đăng ký khám',
      error: error.message
    });
  }
};

// Cập nhật trạng thái phiếu khám
const capNhatTrangThaiPhieuKham = async (req, res) => {
  try {
    const { id } = req.params;
    const { TrangThaiMoi } = req.body;

    await prisma.$executeRaw`
      EXEC sp_CapNhatTrangThaiPhieuKham 
        @idDKKhambenh = ${id},
        @TrangThaiMoi = ${TrangThaiMoi}
    `;

    res.json({
      success: true,
      message: 'Cập nhật trạng thái phiếu khám thành công'
    });
  } catch (error) {
    console.error('Error in capNhatTrangThaiPhieuKham:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi cập nhật trạng thái phiếu khám',
      error: error.message
    });
  }
};

// Xóa phiếu đăng ký khám
const xoaPhieuDangKyKham = async (req, res) => {
  try {
    const { id } = req.params;

    await prisma.$executeRaw`
      EXEC sp_XoaCungPhieuDangKyKham @idDKKhambenh = ${id}
    `;

    res.json({
      success: true,
      message: 'Xóa phiếu đăng ký khám thành công'
    });
  } catch (error) {
    console.error('Error in xoaPhieuDangKyKham:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi xóa phiếu đăng ký khám',
      error: error.message
    });
  }
};

const layPhieuDangKyKham = async (req, res) => {
  try {
    const result = await prisma.$queryRaw`
      EXEC sp_PDK_KhamBenh_GetAll
    `;

    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layPhieuDangKyKham:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách phiếu đăng ký khám',
      error: error.message
    });
  }
}

// Lấy phiếu đăng ký khám theo ID
const layPhieuDangKyKhamTheoID = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_LayPhieuDangKyKhamTheoID @idDKKhambenh = ${id}
    `;
    
    if (result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy phiếu đăng ký khám'
      });
    }
    
    res.json({
      success: true,
      data: result[0]
    });
  } catch (error) {
    console.error('Error in layPhieuDangKyKhamTheoID:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thông tin phiếu đăng ký khám',
      error: error.message
    });
  }
};

// Tìm kiếm phiếu đăng ký khám
const timKiemPhieuDangKyKham = async (req, res) => {
  try {
    const { TuNgay, DenNgay, TrangThai, Keyword } = req.query;

    if (!TuNgay || !DenNgay) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập khoảng thời gian tìm kiếm'
      });
    }

    const result = await prisma.$queryRaw`
      EXEC sp_TimKiemPhieuDangKyKham 
        @TuNgay = ${TuNgay},
        @DenNgay = ${DenNgay},
        @TrangThai = ${TrangThai || null},
        @Keyword = ${Keyword || null}
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in timKiemPhieuDangKyKham:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi tìm kiếm phiếu đăng ký khám',
      error: error.message
    });
  }
};

module.exports = {
  themPhieuDangKyKham,
  suaPhieuDangKyKham,
  capNhatTrangThaiPhieuKham,
  xoaPhieuDangKyKham,
  layPhieuDangKyKham,
  layPhieuDangKyKhamTheoID,
  timKiemPhieuDangKyKham
};