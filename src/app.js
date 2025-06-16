const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();

// Middleware cơ bản
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check route
app.get('/', (req, res) => {
  res.json({ 
    message: 'Hospital Management System API đang hoạt động!',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

// Test route để kiểm tra kết nối database
app.get('/api/test', async (req, res) => {
  try {
    const prisma = require('./utils/prisma');
    // Test kết nối với một query đơn giản
    await prisma.$queryRaw`SELECT 1 as test`;
    res.json({ 
      success: true,
      message: 'Kết nối database thành công!' 
    });
  } catch (error) {
    console.error('Database connection error:', error);
    res.status(500).json({ 
      success: false,
      message: 'Lỗi kết nối database',
      error: error.message 
    });
  }
});

// Import và sử dụng routes
try {
  // Routes chính
  const userRoutes = require('./routes/userRoutes');
  const benhNhanRoutes = require('./routes/benhNhanRoutes');
  const pdkKhamRoutes = require('./routes/pdkKhamRoutes');
  const chuyenVienRoutes = require('./routes/chuyenVienRoutes');
  const donThuocRoutes = require('./routes/donThuocRoutes');
  const duocPhamRoutes = require('./routes/duocPhamRoutes');
  const khamBenhRoutes = require('./routes/khamBenhRoutes');
  const vacXinRoutes = require('./routes/vacXinRoutes');
  const lichLamViecRoutes = require('./routes/lichLamViecRoutes');

  // Sử dụng routes
  app.use('/api/users', userRoutes);
  app.use('/api/benh-nhan', benhNhanRoutes);
  app.use('/api/pdk-kham', pdkKhamRoutes);
  app.use('/api/chuyen-vien', chuyenVienRoutes);
  app.use('/api/don-thuoc', donThuocRoutes);
  app.use('/api/duoc-pham', duocPhamRoutes);
  app.use('/api/kham-benh', khamBenhRoutes);
  app.use('/api/vac-xin', vacXinRoutes);
  app.use('/api/lich-lam-viec', lichLamViecRoutes);

  console.log('✅ All routes loaded successfully');
} catch (error) {
  console.error('❌ Error loading routes:', error.message);
}

// API Documentation route
app.get('/api/docs', (req, res) => {
  res.json({
    title: 'Hospital Management System API Documentation',
    version: '1.0.0',
    endpoints: {
      users: {
        base: '/api/users',
        endpoints: [
          'GET / - Lấy tất cả người dùng',
          'GET /search - Tìm kiếm người dùng', 
          'GET /:id - Lấy người dùng theo ID',
          'POST / - Tạo người dùng mới',
          'PUT /:id - Cập nhật người dùng',
          'DELETE /:id - Xóa người dùng',
          'POST /login - Đăng nhập'
        ]
      },
      benhNhan: {
        base: '/api/benh-nhan',
        endpoints: [
          'GET / - Lấy tất cả bệnh nhân',
          'GET /search - Tìm kiếm bệnh nhân',
          'GET /:id - Lấy bệnh nhân theo ID',
          'POST / - Thêm bệnh nhân mới'
        ]
      },
      pdkKham: {
        base: '/api/pdk-kham',
        endpoints: [
          'GET /search - Tìm kiếm phiếu đăng ký khám',
          'GET /:id - Lấy phiếu đăng ký khám theo ID',
          'POST / - Thêm phiếu đăng ký khám',
          'PUT /:id - Sửa phiếu đăng ký khám',
          'PATCH /:id/trang-thai - Cập nhật trạng thái',
          'DELETE /:id - Xóa phiếu đăng ký khám'
        ]
      },
      chuyenVien: {
        base: '/api/chuyen-vien',
        endpoints: [
          'POST /yeu-cau - Thêm yêu cầu chuyển viện',
          'PUT /yeu-cau/:id - Sửa yêu cầu chuyển viện',
          'PATCH /yeu-cau/:id/xu-ly - Xử lý yêu cầu',
          'GET /yeu-cau/search - Tìm kiếm yêu cầu',
          'POST /phieu - Tạo phiếu chuyển viện',
          'PUT /phieu/:id - Sửa phiếu chuyển viện',
          'PATCH /phieu/:id/trang-thai - Cập nhật trạng thái',
          'GET /phieu/search - Tìm kiếm phiếu chuyển viện'
        ]
      },
      donThuoc: {
        base: '/api/don-thuoc',
        endpoints: [
          'GET /search - Tìm kiếm đơn thuốc',
          'GET /:id - Lấy đơn thuốc theo ID',
          'POST / - Thêm đơn thuốc',
          'PUT /:id - Sửa đơn thuốc',
          'DELETE /:id - Xóa đơn thuốc',
          'PATCH /:id/thanh-toan - Xác nhận thanh toán',
          'POST /chi-tiet - Thêm chi tiết đơn thuốc',
          'GET /:id/chi-tiet - Lấy chi tiết đơn thuốc'
        ]
      },
      duocPham: {
        base: '/api/duoc-pham',
        endpoints: [
          'GET / - Lấy tất cả dược phẩm',
          'GET /search - Tìm kiếm dược phẩm',
          'GET /con-hang - Lấy dược phẩm còn hàng',
          'GET /het-han - Lấy dược phẩm hết hạn',
          'GET /loai/:id - Lấy dược phẩm theo loại',
          'GET /:id - Lấy chi tiết dược phẩm'
        ]
      },
      khamBenh: {
        base: '/api/kham-benh',
        endpoints: [
          'GET /search - Tìm kiếm phiếu khám',
          'GET /:id - Lấy chi tiết phiếu khám'
        ]
      },
      vacXin: {
        base: '/api/vac-xin',
        endpoints: [
          'GET / - Lấy tất cả vắc xin',
          'GET /search - Tìm kiếm vắc xin',
          'GET /con-hang - Lấy vắc xin còn hàng',
          'GET /het-han - Lấy vắc xin hết hạn',
          'GET /:id - Lấy chi tiết vắc xin'
        ]
      },
      lichLamViec: {
        base: '/api/lich-lam-viec',
        endpoints: [
          'GET /lich-tuan - Lấy lịch làm việc tuần',
          'POST /ca - Thêm ca làm việc',
          'PUT /ca/:id - Sửa ca làm việc',
          'PATCH /ca/:id/xac-nhan - Xác nhận ca',
          'POST /chuyen-ca - Tạo yêu cầu chuyển ca',
          'PATCH /chuyen-ca/:id/xu-ly - Xử lý chuyển ca',
          'POST /nghi-phep - Tạo đơn nghỉ phép',
          'PATCH /nghi-phep/:id/xu-ly - Xử lý nghỉ phép'
        ]
      }
    }
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Global error handler:', err.stack);
  res.status(500).json({ 
    success: false,
    message: 'Có lỗi xảy ra trên server!',
    error: process.env.NODE_ENV === 'development' ? err.message : 'Internal server error'
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ 
    success: false,
    message: 'Route không tồn tại',
    availableRoutes: '/api/docs'
  });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`🚀 Server đang chạy trên port ${PORT}`);
  console.log(`📍 API URL: http://localhost:${PORT}`);
  console.log(`📚 API Documentation: http://localhost:${PORT}/api/docs`);
  console.log(`🏥 Hospital Management System API`);
});

module.exports = app;