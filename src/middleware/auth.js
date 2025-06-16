const prisma = require('../utils/prisma');

// Middleware xác thực người dùng đơn giản
const authenticateUser = async (req, res, next) => {
  try {
    // Lấy token từ header (có thể là session ID hoặc user ID)
    const authHeader = req.headers.authorization;
    const userId = req.headers['x-user-id']; // Hoặc từ header khác

    if (!userId && !authHeader) {
      return res.status(401).json({
        success: false,
        message: 'Vui lòng đăng nhập để truy cập'
      });
    }

    // Lấy user ID từ header hoặc token
    const extractedUserId = userId || (authHeader && authHeader.replace('Bearer ', ''));

    if (!extractedUserId) {
      return res.status(401).json({
        success: false,
        message: 'Token không hợp lệ'
      });
    }

    // Kiểm tra người dùng có tồn tại không
    const user = await prisma.nGUOIDUNG.findUnique({
      where: { idNguoiDung: extractedUserId },
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
        message: 'Người dùng không tồn tại'
      });
    }

    // Lưu thông tin user vào request để sử dụng trong controller
    req.user = user;
    req.userId = extractedUserId;

    next();
  } catch (error) {
    console.error('Authentication error:', error);
    res.status(500).json({
      success: false,
      message: 'Lỗi xác thực người dùng',
      error: error.message
    });
  }
};

// Middleware kiểm tra quyền
const requireRole = (allowedRoles) => {
  return (req, res, next) => {
    try {
      if (!req.user) {
        return res.status(401).json({
          success: false,
          message: 'Cần xác thực trước'
        });
      }

      const userRole = req.user.ChucVu;
      const userPermission = req.user.NHOM_NGUOIDUNG?.QUYEN?.TenQuyen;

      // Kiểm tra role hoặc permission
      const hasPermission = allowedRoles.includes(userRole) || 
                           (userPermission && allowedRoles.includes(userPermission));

      if (!hasPermission) {
        return res.status(403).json({
          success: false,
          message: 'Không có quyền truy cập chức năng này'
        });
      }

      next();
    } catch (error) {
      console.error('Authorization error:', error);
      res.status(500).json({
        success: false,
        message: 'Lỗi kiểm tra quyền',
        error: error.message
      });
    }
  };
};

// Middleware set session context cho SQL Server
const setSessionContext = async (req, res, next) => {
  try {
    if (req.userId) {
      // Set session context trong SQL Server để stored procedures có thể sử dụng
      await prisma.$executeRaw`
        EXEC sp_set_session_context @key = N'UserID', @value = ${req.userId}
      `;
    }
    next();
  } catch (error) {
    console.error('Session context error:', error);
    // Không block request nếu set session context thất bại
    next();
  }
};

// Middleware cho routes không yêu cầu authentication (optional auth)
const optionalAuth = async (req, res, next) => {
  try {
    const userId = req.headers['x-user-id'];
    const authHeader = req.headers.authorization;
    
    if (userId || authHeader) {
      // Có thông tin auth, thực hiện xác thực
      return authenticateUser(req, res, next);
    } else {
      // Không có thông tin auth, cho phép truy cập anonymous
      next();
    }
  } catch (error) {
    console.error('Optional auth error:', error);
    next(); // Cho phép tiếp tục nếu có lỗi
  }
};

module.exports = {
  authenticateUser,
  requireRole,
  setSessionContext,
  optionalAuth
};