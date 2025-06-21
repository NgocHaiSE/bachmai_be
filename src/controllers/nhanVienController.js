const prisma = require('../utils/prisma');

// Lấy tất cả bệnh nhân
const layTatCaNhanVien = async (req, res) => {
  try {
    const result = await prisma.$queryRaw`EXEC sp_LayTatCaNhanVien`;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layTatCaNhanVien:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách nhân viên',
      error: error.message
    });
  }
};

module.exports = {
  layTatCaNhanVien,
};