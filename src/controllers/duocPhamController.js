const prisma = require('../utils/prisma');

// Lấy chi tiết dược phẩm theo ID
const layChiTietDuocPham = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_LayChiTietDuocPham @idDuocPham = ${id}
    `;
    
    if (result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy dược phẩm'
      });
    }
    
    res.json({
      success: true,
      data: result[0]
    });
  } catch (error) {
    console.error('Error in layChiTietDuocPham:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thông tin dược phẩm',
      error: error.message
    });
  }
};

// Tìm kiếm dược phẩm
const timKiemDuocPham = async (req, res) => {
  try {
    const { 
      Keyword, 
      idLoaiDuocPham, 
      idNCC, 
      KiemTraTonKho, 
      KiemTraHanSuDung 
    } = req.query;

    const result = await prisma.$queryRaw`
      EXEC sp_TimKiemDuocPham 
        @Keyword = ${Keyword || null},
        @idLoaiDuocPham = ${idLoaiDuocPham || null},
        @idNCC = ${idNCC || null},
        @KiemTraTonKho = ${KiemTraTonKho ? parseInt(KiemTraTonKho) : null},
        @KiemTraHanSuDung = ${KiemTraHanSuDung ? parseInt(KiemTraHanSuDung) : null}
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in timKiemDuocPham:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi tìm kiếm dược phẩm',
      error: error.message
    });
  }
};

// Lấy tất cả dược phẩm (sử dụng tìm kiếm với tham số trống)
const layTatCaDuocPham = async (req, res) => {
  try {
    const result = await prisma.$queryRaw`
      EXEC sp_TimKiemDuocPham 
        @Keyword = NULL,
        @idLoaiDuocPham = NULL,
        @idNCC = NULL,
        @KiemTraTonKho = NULL,
        @KiemTraHanSuDung = NULL
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layTatCaDuocPham:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách dược phẩm',
      error: error.message
    });
  }
};

// Lấy dược phẩm còn hàng
const layDuocPhamConHang = async (req, res) => {
  try {
    const result = await prisma.$queryRaw`
      EXEC sp_TimKiemDuocPham 
        @Keyword = NULL,
        @idLoaiDuocPham = NULL,
        @idNCC = NULL,
        @KiemTraTonKho = 1,
        @KiemTraHanSuDung = NULL
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layDuocPhamConHang:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách dược phẩm còn hàng',
      error: error.message
    });
  }
};

// Lấy dược phẩm hết hạn
const layDuocPhamHetHan = async (req, res) => {
  try {
    const result = await prisma.$queryRaw`
      EXEC sp_TimKiemDuocPham 
        @Keyword = NULL,
        @idLoaiDuocPham = NULL,
        @idNCC = NULL,
        @KiemTraTonKho = NULL,
        @KiemTraHanSuDung = 0
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layDuocPhamHetHan:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách dược phẩm hết hạn',
      error: error.message
    });
  }
};

// Lấy dược phẩm theo loại
const layDuocPhamTheoLoai = async (req, res) => {
  try {
    const { idLoaiDuocPham } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_TimKiemDuocPham 
        @Keyword = NULL,
        @idLoaiDuocPham = ${idLoaiDuocPham},
        @idNCC = NULL,
        @KiemTraTonKho = NULL,
        @KiemTraHanSuDung = NULL
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layDuocPhamTheoLoai:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy dược phẩm theo loại',
      error: error.message
    });
  }
};

// Lấy dược phẩm theo nhà cung cấp
const layDuocPhamTheoNCC = async (req, res) => {
  try {
    const { idNCC } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_TimKiemDuocPham 
        @Keyword = NULL,
        @idLoaiDuocPham = NULL,
        @idNCC = ${idNCC},
        @KiemTraTonKho = NULL,
        @KiemTraHanSuDung = NULL
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layDuocPhamTheoNCC:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy dược phẩm theo nhà cung cấp',
      error: error.message
    });
  }
};

module.exports = {
  layChiTietDuocPham,
  timKiemDuocPham,
  layTatCaDuocPham,
  layDuocPhamConHang,
  layDuocPhamHetHan,
  layDuocPhamTheoLoai,
  layDuocPhamTheoNCC
};