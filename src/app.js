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
    timestamp: new Date().toISOString()
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
const userRoutes = require('./routes/userRoutes');
const benhNhanRoutes = require('./routes/benhNhanRoutes');
const pdkKhamRoutes = require('./routes/pdkKhamRoutes');
const chuyenVienRoutes = require('./routes/chuyenVienRoutes');
const donThuocRoutes = require('./routes/donThuocRoutes');
const duocPhamRoutes = require('./routes/duocPhamRoutes');
const khamBenhRoutes = require('./routes/khamBenhRoutes');
const vacXinRoutes = require('./routes/vacXinRoutes');
const lichLamViecRoutes = require('./routes/lichLamViecRoutes');

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

// Error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ 
    success: false,
    message: 'Có lỗi xảy ra!'
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ 
    success: false,
    message: 'Route không tồn tại'
  });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server đang chạy trên port ${PORT}`);
  console.log(`API URL: http://localhost:${PORT}`);
});

module.exports = app;