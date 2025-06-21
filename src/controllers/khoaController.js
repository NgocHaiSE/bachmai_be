const prisma = require('../utils/prisma');

// Lấy tất cả khoa
const layTatCaKhoa = async (req, res) => {
  try {
    const result = await prisma.$queryRaw`
      SELECT idKhoa, TenKhoa, ViTri, MucTieu, NgayThanhLap, NgayHD, TrangThai, idLoaiKhoa
      FROM Khoa
      WHERE TrangThai = N'Đang hoạt động'
      ORDER BY TenKhoa
    `;

    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in layTatCaKhoa:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách khoa',
      error: error.message
    });
  }
};

// Lấy khoa theo ID
const layKhoaTheoID = async (req, res) => {
  try {
    const { id } = req.params;
    
    const result = await prisma.$queryRaw`
      SELECT idKhoa, TenKhoa, ViTri, MucTieu, NgayThanhLap, NgayHD, TrangThai, idLoaiKhoa
      FROM Khoa
      WHERE idKhoa = ${id}
    `;
    
    if (result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy khoa'
      });
    }
    
    res.json({
      success: true,
      data: result[0]
    });
  } catch (error) {
    console.error('Error in layKhoaTheoID:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thông tin khoa',
      error: error.message
    });
  }
};

// Tìm kiếm khoa
const timKiemKhoa = async (req, res) => {
  try {
    const { tuKhoa } = req.query;

    if (!tuKhoa) {
      return layTatCaKhoa(req, res);
    }

    const result = await prisma.$queryRaw`
      SELECT idKhoa, TenKhoa, ViTri, MucTieu, NgayThanhLap, NgayHD, TrangThai, idLoaiKhoa
      FROM Khoa
      WHERE (TenKhoa LIKE ${'%' + tuKhoa + '%'} OR idKhoa LIKE ${'%' + tuKhoa + '%'})
        AND TrangThai = N'Đang hoạt động'
      ORDER BY TenKhoa
    `;
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('Error in timKiemKhoa:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi tìm kiếm khoa',
      error: error.message
    });
  }
};

module.exports = {
  layTatCaKhoa,
  layKhoaTheoID,
  timKiemKhoa
};