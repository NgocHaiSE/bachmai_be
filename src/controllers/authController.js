const prisma = require('../utils/prisma');

// Đăng nhập
const login = async (req, res) => {
  try {
    const { TenDN, MatKhau } = req.body;

    // Validate input
    if (!TenDN || !MatKhau) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập tên đăng nhập và mật khẩu'
      });
    }

    // Tìm user theo tên đăng nhập
    const user = await prisma.nGUOIDUNG.findFirst({
      where: { TenDN: TenDN },
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

    // Kiểm tra mật khẩu
    if (MatKhau !== user.MatKhau) {
      return res.status(401).json({
        success: false,
        message: 'Tên đăng nhập hoặc mật khẩu không đúng'
      });
    }

    // Loại bỏ mật khẩu khỏi response
    const { MatKhau: _, ...userWithoutPassword } = user;

    // Lưu thông tin user vào session (nếu sử dụng session)
    if (req.session) {
      req.session.user = userWithoutPassword;
    }

    res.json({
      success: true,
      message: 'Đăng nhập thành công',
      data: userWithoutPassword
    });

  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi server khi đăng nhập',
      error: error.message
    });
  }
};

const logout = async (req, res) => {
  try {
    // Xóa session nếu có
    if (req.session) {
      req.session.destroy((err) => {
        if (err) {
          console.error('Session destroy error:', err);
        }
      });
    }

    res.json({
      success: true,
      message: 'Đăng xuất thành công'
    });
  } catch (error) {
    console.error('Logout error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi đăng xuất',
      error: error.message
    });
  }
};

// Kiểm tra trạng thái đăng nhập
const checkAuth = async (req, res) => {
  try {
    if (req.session && req.session.user) {
      res.json({
        success: true,
        isAuthenticated: true,
        data: req.session.user
      });
    } else {
      res.json({
        success: true,
        isAuthenticated: false,
        data: null
      });
    }
  } catch (error) {
    console.error('Check auth error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi kiểm tra trạng thái đăng nhập',
      error: error.message
    });
  }
};

// Đổi mật khẩu
const changePassword = async (req, res) => {
  try {
    const { idNguoiDung, oldPassword, newPassword } = req.body;

    if (!idNguoiDung || !oldPassword || !newPassword) {
      return res.status(400).json({
        success: false,
        message: 'Vui lòng nhập đầy đủ thông tin'
      });
    }

    // Tìm user
    const user = await prisma.nGUOIDUNG.findUnique({
      where: { idNguoiDung: idNguoiDung }
    });

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy người dùng'
      });
    }

    // Kiểm tra mật khẩu cũ
    if (oldPassword !== user.MatKhau) {
      return res.status(401).json({
        success: false,
        message: 'Mật khẩu cũ không đúng'
      });
    }

    // Cập nhật mật khẩu mới
    await prisma.nGUOIDUNG.update({
      where: { idNguoiDung: idNguoiDung },
      data: { MatKhau: newPassword }
    });

    res.json({
      success: true,
      message: 'Đổi mật khẩu thành công'
    });

  } catch (error) {
    console.error('Change password error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi khi đổi mật khẩu',
      error: error.message
    });
  }
};

module.exports = {
  login,
  logout,
  checkAuth,
  changePassword
};