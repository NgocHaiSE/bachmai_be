const prisma = require('../utils/prisma');

// Tìm kiếm vắc xin
const timKiemVacXin = async (req, res) => {
  try {
    const { 
      Keyword, 
      idLoaiVX, 
      idNCC, 
      KiemTraTonKho, 
      KiemTraHanSuDung 
    } = req.query;

    const result = await prisma.$queryRaw`
      EXEC sp_TimKiemVacXin 
        @Keyword = ${Keyword || null},
        @idLoaiVX = ${idLoaiVX || null},
        @idNCC = ${idNCC || null},
        @KiemTraTonKho = ${KiemTraTonKho ? parseInt(KiemTraTonKho) : null},
        @KiemTraHanSuDung = ${KiemTraHanSuDung ? parseInt(KiemTraHanSuDung) : null}
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in timKiemVacXin:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi tìm kiếm vắc xin',
      error: error.message
    });
  }
};

// Lấy chi tiết vắc xin theo ID
const layChiTietVacXin = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_LayChiTietVacXin @idVacXin = ${id}
    `;
    
    if (result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy vắc xin'
      });
    }
    
    res.json({
      success: true,
      data: result[0]
    });
  } catch (error) {
    console.error('Error in layChiTietVacXin:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thông tin vắc xin',
      error: error.message
    });
  }
};

// Lấy tất cả vắc xin (sử dụng tìm kiếm với tham số trống)
const layTatCaVacXin = async (req, res) => {
  try {
    const result = await prisma.$queryRaw`
      EXEC sp_TimKiemVacXin 
        @Keyword = NULL,
        @idLoaiVX = NULL,
        @idNCC = NULL,
        @KiemTraTonKho = NULL,
        @KiemTraHanSuDung = NULL
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layTatCaVacXin:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách vắc xin',
      error: error.message
    });
  }
};

// Lấy vắc xin còn hàng
const layVacXinConHang = async (req, res) => {
  try {
    const result = await prisma.$queryRaw`
      EXEC sp_TimKiemVacXin 
        @Keyword = NULL,
        @idLoaiVX = NULL,
        @idNCC = NULL,
        @KiemTraTonKho = 1,
        @KiemTraHanSuDung = NULL
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layVacXinConHang:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách vắc xin còn hàng',
      error: error.message
    });
  }
};

// Lấy vắc xin hết hạn
const layVacXinHetHan = async (req, res) => {
  try {
    const result = await prisma.$queryRaw`
      EXEC sp_TimKiemVacXin 
        @Keyword = NULL,
        @idLoaiVX = NULL,
        @idNCC = NULL,
        @KiemTraTonKho = NULL,
        @KiemTraHanSuDung = 0
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layVacXinHetHan:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách vắc xin hết hạn',
      error: error.message
    });
  }
};

// Lấy vắc xin theo loại
const layVacXinTheoLoai = async (req, res) => {
  try {
    const { idLoaiVX } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_TimKiemVacXin 
        @Keyword = NULL,
        @idLoaiVX = ${idLoaiVX},
        @idNCC = NULL,
        @KiemTraTonKho = NULL,
        @KiemTraHanSuDung = NULL
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layVacXinTheoLoai:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy vắc xin theo loại',
      error: error.message
    });
  }
};

// Lấy vắc xin theo nhà cung cấp
const layVacXinTheoNCC = async (req, res) => {
  try {
    const { idNCC } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_TimKiemVacXin 
        @Keyword = NULL,
        @idLoaiVX = NULL,
        @idNCC = ${idNCC},
        @KiemTraTonKho = NULL,
        @KiemTraHanSuDung = NULL
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layVacXinTheoNCC:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy vắc xin theo nhà cung cấp',
      error: error.message
    });
  }
};

module.exports = {
  timKiemVacXin,
  layChiTietVacXin,
  layTatCaVacXin,
  layVacXinConHang,
  layVacXinHetHan,
  layVacXinTheoLoai,
  layVacXinTheoNCC
};