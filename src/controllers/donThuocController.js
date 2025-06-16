const prisma = require('../utils/prisma');

// ============ ĐƠN THUỐC ============

// Thêm đơn thuốc
const themDonThuoc = async (req, res) => {
  try {
    const { idKhamBenh, GhiChu } = req.body;

    const result = await prisma.$executeRaw`
      DECLARE @idDonThuocMoi CHAR(10);
      EXEC sp_ThemDonThuoc 
        @idKhamBenh = ${idKhamBenh},
        @GhiChu = ${GhiChu},
        @idDonThuocMoi = @idDonThuocMoi OUTPUT;
      SELECT @idDonThuocMoi as idDonThuocMoi;
    `;

    res.status(201).json({
      success: true,
      message: 'Tạo đơn thuốc thành công',
      data: result
    });
  } catch (error) {
    console.error('Error in themDonThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi tạo đơn thuốc',
      error: error.message
    });
  }
};

// Sửa đơn thuốc
const suaDonThuoc = async (req, res) => {
  try {
    const { id } = req.params;
    const { GhiChu } = req.body;

    await prisma.$executeRaw`
      EXEC sp_SuaDonThuoc 
        @idDonThuoc = ${id},
        @GhiChu = ${GhiChu}
    `;

    res.json({
      success: true,
      message: 'Cập nhật đơn thuốc thành công'
    });
  } catch (error) {
    console.error('Error in suaDonThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi cập nhật đơn thuốc',
      error: error.message
    });
  }
};

// Xóa đơn thuốc
const xoaDonThuoc = async (req, res) => {
  try {
    const { id } = req.params;

    await prisma.$executeRaw`
      EXEC sp_XoaCungDonThuoc @idDonThuoc = ${id}
    `;

    res.json({
      success: true,
      message: 'Xóa đơn thuốc thành công'
    });
  } catch (error) {
    console.error('Error in xoaDonThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi xóa đơn thuốc',
      error: error.message
    });
  }
};

// Xác nhận thanh toán đơn thuốc
const xacNhanThanhToanDonThuoc = async (req, res) => {
  try {
    const { id } = req.params;

    await prisma.$executeRaw`
      EXEC sp_XacNhanThanhToanDonThuoc @idDonThuoc = ${id}
    `;

    res.json({
      success: true,
      message: 'Xác nhận thanh toán đơn thuốc thành công'
    });
  } catch (error) {
    console.error('Error in xacNhanThanhToanDonThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi xác nhận thanh toán đơn thuốc',
      error: error.message
    });
  }
};

// Lấy đơn thuốc theo ID
const layDonThuocTheoID = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_LayDonThuocTheoID @idDonThuoc = ${id}
    `;
    
    if (result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy đơn thuốc'
      });
    }
    
    res.json({
      success: true,
      data: result[0]
    });
  } catch (error) {
    console.error('Error in layDonThuocTheoID:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thông tin đơn thuốc',
      error: error.message
    });
  }
};

// Tìm kiếm đơn thuốc
const timKiemDonThuoc = async (req, res) => {
  try {
    const { TuNgay, DenNgay, TrangThai, Keyword } = req.query;

    if (!TuNgay || !DenNgay) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập khoảng thời gian tìm kiếm'
      });
    }

    const result = await prisma.$queryRaw`
      EXEC sp_TimKiemDonThuoc 
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
    console.error('Error in timKiemDonThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi tìm kiếm đơn thuốc',
      error: error.message
    });
  }
};

// ============ CHI TIẾT ĐƠN THUỐC ============

// Thêm chi tiết đơn thuốc
const themChiTietDonThuoc = async (req, res) => {
  try {
    const {
      idDonThuoc, idDuocPham, SoLuong, LieuDung, DuongDung, GhiChu
    } = req.body;

    await prisma.$executeRaw`
      EXEC sp_ThemChiTietDonThuoc 
        @idDonThuoc = ${idDonThuoc},
        @idDuocPham = ${idDuocPham},
        @SoLuong = ${SoLuong},
        @LieuDung = ${LieuDung},
        @DuongDung = ${DuongDung},
        @GhiChu = ${GhiChu}
    `;

    res.status(201).json({
      success: true,
      message: 'Thêm dược phẩm vào đơn thuốc thành công'
    });
  } catch (error) {
    console.error('Error in themChiTietDonThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi thêm dược phẩm vào đơn thuốc',
      error: error.message
    });
  }
};

// Sửa chi tiết đơn thuốc
const suaChiTietDonThuoc = async (req, res) => {
  try {
    const { idDonThuoc, idDuocPham } = req.params;
    const { SoLuong, LieuDung, DuongDung, GhiChu } = req.body;

    await prisma.$executeRaw`
      EXEC sp_SuaChiTietDonThuoc 
        @idDonThuoc = ${idDonThuoc},
        @idDuocPham = ${idDuocPham},
        @SoLuong = ${SoLuong},
        @LieuDung = ${LieuDung},
        @DuongDung = ${DuongDung},
        @GhiChu = ${GhiChu}
    `;

    res.json({
      success: true,
      message: 'Cập nhật chi tiết đơn thuốc thành công'
    });
  } catch (error) {
    console.error('Error in suaChiTietDonThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi cập nhật chi tiết đơn thuốc',
      error: error.message
    });
  }
};

// Xóa chi tiết đơn thuốc
const xoaChiTietDonThuoc = async (req, res) => {
  try {
    const { idDonThuoc, idDuocPham } = req.params;

    await prisma.$executeRaw`
      EXEC sp_XoaChiTietDonThuoc 
        @idDonThuoc = ${idDonThuoc},
        @idDuocPham = ${idDuocPham}
    `;

    res.json({
      success: true,
      message: 'Xóa dược phẩm khỏi đơn thuốc thành công'
    });
  } catch (error) {
    console.error('Error in xoaChiTietDonThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi xóa dược phẩm khỏi đơn thuốc',
      error: error.message
    });
  }
};

// Lấy chi tiết đơn thuốc
const layChiTietDonThuoc = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_LayChiTietDonThuoc @idDonThuoc = ${id}
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layChiTietDonThuoc:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy chi tiết đơn thuốc',
      error: error.message
    });
  }
};

module.exports = {
  // Đơn thuốc
  themDonThuoc,
  suaDonThuoc,
  xoaDonThuoc,
  xacNhanThanhToanDonThuoc,
  layDonThuocTheoID,
  timKiemDonThuoc,
  
  // Chi tiết đơn thuốc
  themChiTietDonThuoc,
  suaChiTietDonThuoc,
  xoaChiTietDonThuoc,
  layChiTietDonThuoc
};