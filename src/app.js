const express = require('express');
const cors = require('cors');
require('dotenv').config();
const session = require('express-session');

const app = express();

// Middleware cơ bản
app.use(cors({
  origin: 'http://localhost:5173', // ĐÚNG PORT FE của bạn!
  credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(session({
  secret: process.env.SESSION_SECRET || 'your_secret_key', // đặt ở biến môi trường là tốt nhất
  resave: false,
  saveUninitialized: false,
  cookie: {
    httpOnly: true,
    secure: false, // true nếu dùng HTTPS
    maxAge: 24 * 60 * 60 * 1000, // 1 ngày
    sameSite: 'lax', // hoặc 'none' nếu dùng frontend ở domain khác và có HTTPS
  }
}));

// Health check route
app.get('/', (req, res) => {
  res.json({ 
    message: 'Hospital Management System API đang hoạt động!',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

// Test database connection
app.get('/api/test', async (req, res) => {
  try {
    const prisma = require('./utils/prisma');
    await prisma.$queryRaw`SELECT 1 as test`;
    res.json({ 
      success: true,
      message: 'Kết nối database thành công!' 
    });
  } catch (error) {
    res.status(500).json({ 
      success: false,
      message: 'Lỗi kết nối database',
      error: error.message 
    });
  }
});

// Import routes
try {
  const userRoutes = require('./routes/userRoutes');
  const benhNhanRoutes = require('./routes/benhNhanRoutes');
  const pdkKhamRoutes = require('./routes/pdkKhamRoutes');
  const chuyenVienRoutes = require('./routes/chuyenVienRoutes');
  const donThuocRoutes = require('./routes/donThuocRoutes');
  const duocPhamRoutes = require('./routes/duocPhamRoutes');
  const khamBenhRoutes = require('./routes/khamBenhRoutes');
  const vacXinRoutes = require('./routes/vacXinRoutes');
  const lichLamViecRoutes = require('./routes/lichLamViecRoutes');
  const authRoutes = require('./routes/authRoutes');
  const khoaRoutes = require('./routes/khoaRoutes');
  const nhanVienRoutes = require('./routes/nhanVienRoutes');

  // Use routes
  app.use('/api/users', userRoutes);
  app.use('/api/benh-nhan', benhNhanRoutes);
  app.use('/api/pdk-kham', pdkKhamRoutes);
  app.use('/api/chuyen-vien', chuyenVienRoutes);
  app.use('/api/don-thuoc', donThuocRoutes);
  app.use('/api/duoc-pham', duocPhamRoutes);
  app.use('/api/kham-benh', khamBenhRoutes);
  app.use('/api/vac-xin', vacXinRoutes);
  app.use('/api/lich-lam-viec', lichLamViecRoutes);
  app.use('/api/auth', authRoutes)
  app.use('/api/khoa', khoaRoutes)
  app.use('/api/nhan-vien', nhanVienRoutes)
  
  
  console.log('✅ All routes loaded successfully');
} catch (error) {
  console.error('❌ Error loading routes:', error.message);
  console.error('Stack:', error.stack);
}

// Error handler
// app.use((err, req, res, next) => {
//   console.error('Error:', err.stack);
//   res.status(500).json({ 
//     success: false,
//     message: 'Có lỗi xảy ra!',
//     error: process.env.NODE_ENV === 'development' ? err.message : undefined
//   });
// });

// 404 handler
// app.use('*', (req, res) => {
//   res.status(404).json({ 
//     success: false,
//     message: `Route không tồn tại: ${req.method} ${req.originalUrl}`
//   });
// });

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log('🏥 Hospital Management System Backend');
  console.log(`🚀 Server đang chạy trên port ${PORT}`);
  console.log(`📡 API URL: http://localhost:${PORT}`);
  console.log(`🔗 Health check: http://localhost:${PORT}/api/test`);
});

module.exports = app;