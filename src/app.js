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
    message: 'Hospital Backend API đang hoạt động!',
    timestamp: new Date().toISOString()
  });
});

// Test route để kiểm tra kết nối database
app.get('/api/test', async (req, res) => {
  try {
    const prisma = require('./utils/prisma');
    // Test kết nối với một query đơn giản
    await prisma.$queryRaw`SELECT 1 as test`;
    res.json({ message: 'Kết nối database thành công!' });
  } catch (error) {
    console.error('Database connection error:', error);
    res.status(500).json({ 
      message: 'Lỗi kết nối database',
      error: error.message 
    });
  }
});

// Import và sử dụng routes (tạm comment lại để test cơ bản trước)
try {
  const userRoutes = require('./routes/userRoutes');
  app.use('/api/users', userRoutes);
  console.log('User routes loaded successfully');
} catch (error) {
  console.error('Error loading user routes:', error.message);
}

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Global error handler:', err.stack);
  res.status(500).json({ 
    message: 'Có lỗi xảy ra trên server!',
    error: process.env.NODE_ENV === 'development' ? err.message : 'Internal server error'
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ message: 'Route không tồn tại' });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`🚀 Server đang chạy trên port ${PORT}`);
  console.log(`📍 API URL: http://localhost:${PORT}`);
  console.log(`🏥 Hospital Backend API`);
});

module.exports = app;