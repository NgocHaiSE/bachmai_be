const prisma = require('../utils/prisma');

// Lấy tất cả người dùng
const getAllUsers = async (req, res) => {
  try {
    const users = await prisma.nGUOIDUNG.findMany({
      include: {
        NHOM_NGUOIDUNG: {
          include: {
            QUYEN: true
          }
        }
      }
    });
    
    res.json({
      success: true,
      data: users
    });
  } catch (error) {
    console.error('Error getting users:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách người dùng',
      error: error.message
    });
  }
};

// Lấy người dùng theo ID
const getUserById = async (req, res) => {
  try {
    const { id } = req.params;
    const user = await prisma.nGUOIDUNG.findUnique({
      where: { idNguoiDung: id },
      include: {
        NHOM_NGUOIDUNG: {
          include: {
            QUYEN: true
          }
        }
      }
    });
    
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy người dùng'
      });
    }
    
    res.json({
      success: true,
      data: user
    });
  } catch (error) {
    console.error('Error getting user by ID:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thông tin người dùng',
      error: error.message
    });
  }
};

// Tạo người dùng mới
const createUser = async (req, res) => {
  try {
    const {
      idNguoiDung, HoTen, SDT, TenDN, MatKhau, ChucVu,
      idNhom, GioiTinh, NgaySinh, Email, HeSoLuong
    } = req.body;

    // Kiểm tra tên đăng nhập đã tồn tại chưa
    const existingUser = await prisma.nGUOIDUNG.findFirst({
      where: { TenDN: TenDN }
    });

    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: 'Tên đăng nhập đã tồn tại'
      });
    }

    const user = await prisma.nGUOIDUNG.create({
      data: {
        idNguoiDung,
        HoTen,
        SDT,
        TenDN,
        MatKhau,
        ChucVu,
        idNhom,
        GioiTinh,
        NgaySinh: NgaySinh ? new Date(NgaySinh) : null,
        Email,
        HeSoLuong
      },
      include: {
        NHOM_NGUOIDUNG: {
          include: {
            QUYEN: true
          }
        }
      }
    });

    res.status(201).json({
      success: true,
      message: 'Tạo người dùng thành công',
      data: user
    });
  } catch (error) {
    console.error('Error creating user:', error);
    res.status(400).json({
      success: false,
      message: 'Lỗi khi tạo người dùng',
      error: error.message
    });
  }
};

// Cập nhật người dùng
const updateUser = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      HoTen, SDT, TenDN, MatKhau, ChucVu,
      idNhom, GioiTinh, NgaySinh, Email, HeSoLuong
    } = req.body;

    // Kiểm tra người dùng có tồn tại không
    const existingUser = await prisma.nGUOIDUNG.findUnique({
      where: { idNguoiDung: id }
    });

    if (!existingUser) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy người dùng'
      });
    }

    // Kiểm tra tên đăng nhập có bị trùng với người khác không
    if (TenDN && TenDN !== existingUser.TenDN) {
      const duplicateUser = await prisma.nGUOIDUNG.findFirst({
        where: { 
          TenDN: TenDN,
          idNguoiDung: { not: id }
        }
      });

      if (duplicateUser) {
        return res.status(400).json({
          success: false,
          message: 'Tên đăng nhập đã tồn tại'
        });
      }
    }

    const user = await prisma.nGUOIDUNG.update({
      where: { idNguoiDung: id },
      data: {
        ...(HoTen && { HoTen }),
        ...(SDT && { SDT }),
        ...(TenDN && { TenDN }),
        ...(MatKhau && { MatKhau }),
        ...(ChucVu && { ChucVu }),
        ...(idNhom && { idNhom }),
        ...(GioiTinh !== undefined && { GioiTinh }),
        ...(NgaySinh && { NgaySinh: new Date(NgaySinh) }),
        ...(Email && { Email }),
        ...(HeSoLuong && { HeSoLuong })
      },
      include: {
        NHOM_NGUOIDUNG: {
          include: {
            QUYEN: true
          }
        }
      }
    });

    res.json({
      success: true,
      message: 'Cập nhật người dùng thành công',
      data: user
    });
  } catch (error) {
    console.error('Error updating user:', error);
    res.status(400).json({
      success: false,
      message: 'Lỗi khi cập nhật người dùng',
      error: error.message
    });
  }
};

// Xóa người dùng
const deleteUser = async (req, res) => {
  try {
    const { id } = req.params;

    // Kiểm tra người dùng có tồn tại không
    const existingUser = await prisma.nGUOIDUNG.findUnique({
      where: { idNguoiDung: id }
    });

    if (!existingUser) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy người dùng'
      });
    }

    await prisma.nGUOIDUNG.delete({
      where: { idNguoiDung: id }
    });

    res.json({
      success: true,
      message: 'Xóa người dùng thành công'
    });
  } catch (error) {
    console.error('Error deleting user:', error);
    res.status(400).json({
      success: false,
      message: 'Lỗi khi xóa người dùng',
      error: error.message
    });
  }
};

// Đăng nhập
const login = async (req, res) => {
  try {
    const { TenDN, MatKhau } = req.body;

    if (!TenDN || !MatKhau) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập tên đăng nhập và mật khẩu'
      });
    }

    const user = await prisma.nGUOIDUNG.findFirst({
      where: {
        TenDN: TenDN,
        MatKhau: MatKhau // Trong thực tế nên hash mật khẩu
      },
      include: {
        NHOM_NGUOIDUNG: {
          include: {
            QUYEN: true
          }
        }
      }
    });

    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Tên đăng nhập hoặc mật khẩu không đúng'
      });
    }

    // Loại bỏ mật khẩu khỏi response
    const { MatKhau: _, ...userWithoutPassword } = user;

    res.json({
      success: true,
      message: 'Đăng nhập thành công',
      data: userWithoutPassword
    });
  } catch (error) {
    console.error('Error during login:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi đăng nhập',
      error: error.message
    });
  }
};

// Tìm kiếm người dùng
const searchUsers = async (req, res) => {
  try {
    const { keyword, chucVu, idNhom } = req.query;

    const whereCondition = {};

    if (keyword) {
      whereCondition.OR = [
        { HoTen: { contains: keyword } },
        { TenDN: { contains: keyword } },
        { Email: { contains: keyword } }
      ];
    }

    if (chucVu) {
      whereCondition.ChucVu = { contains: chucVu };
    }

    if (idNhom) {
      whereCondition.idNhom = idNhom;
    }

    const users = await prisma.nGUOIDUNG.findMany({
      where: whereCondition,
      include: {
        NHOM_NGUOIDUNG: {
          include: {
            QUYEN: true
          }
        }
      },
      orderBy: {
        HoTen: 'asc'
      }
    });

    res.json({
      success: true,
      data: users
    });
  } catch (error) {
    console.error('Error searching users:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi tìm kiếm người dùng',
      error: error.message
    });
  }
};

module.exports = {
  getAllUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
  login,
  searchUsers
};