const prisma = require('../utils/prisma');

// Lấy chi tiết phiếu khám theo ID
const layChiTietPhieuKham = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await prisma.$queryRaw`
      EXEC sp_LayChiTietPhieuKham @idKhamBenh = ${id}
    `;
    
    if (result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy phiếu khám'
      });
    }
    
    res.json({
      success: true,
      data: result[0]
    });
  } catch (error) {
    console.error('Error in layChiTietPhieuKham:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thông tin phiếu khám',
      error: error.message
    });
  }
};

// Tìm kiếm phiếu khám
const timKiemPhieuKham = async (req, res) => {
  try {
    const { TuNgay, DenNgay, Keyword } = req.query;

    if (!TuNgay || !DenNgay) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập khoảng thời gian tìm kiếm'
      });
    }

    const result = await prisma.$queryRaw`
      EXEC sp_TimKiemPhieuKham 
        @TuNgay = ${TuNgay},
        @DenNgay = ${DenNgay},
        @Keyword = ${Keyword || null}
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in timKiemPhieuKham:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi tìm kiếm phiếu khám',
      error: error.message
    });
  }
};

module.exports = {
  layChiTietPhieuKham,
  timKiemPhieuKham
};