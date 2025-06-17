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
    message: 'Hospital Management System API - Debug Mode',
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

// Function để test load từng route riêng biệt
const testLoadRoute = (routeName, routePath) => {
  console.log(`\n🔍 Testing route: ${routeName}`);
  try {
    const route = require(routePath);
    
    // Tạo test app riêng cho route này
    const testApp = express();
    testApp.use('/test', route);
    
    console.log(`✅ ${routeName}: Successfully loaded`);
    return { success: true, route };
  } catch (error) {
    console.error(`❌ ${routeName}: Failed to load`);
    console.error(`   Error: ${error.message}`);
    if (error.stack) {
      console.error(`   Stack: ${error.stack.split('\n').slice(0, 3).join('\n')}`);
    }
    return { success: false, error };
  }
};

// Danh sách routes để test
const routesToTest = [
  { name: 'userRoutes', path: './routes/userRoutes' },
  { name: 'benhNhanRoutes', path: './routes/benhNhanRoutes' },
  { name: 'pdkKhamRoutes', path: './routes/pdkKhamRoutes' },
  { name: 'chuyenVienRoutes', path: './routes/chuyenVienRoutes' },
  { name: 'donThuocRoutes', path: './routes/donThuocRoutes' },
  { name: 'duocPhamRoutes', path: './routes/duocPhamRoutes' },
  { name: 'khamBenhRoutes', path: './routes/khamBenhRoutes' },
  { name: 'vacXinRoutes', path: './routes/vacXinRoutes' },
  { name: 'lichLamViecRoutes', path: './routes/lichLamViecRoutes' }
];

console.log('🚀 Starting debug route loading...');
console.log('=' .repeat(50));

// Test từng route một
const routeResults = [];
for (const routeInfo of routesToTest) {
  const result = testLoadRoute(routeInfo.name, routeInfo.path);
  routeResults.push({ ...routeInfo, ...result });
}

// Summary
console.log('\n' + '=' .repeat(50));
console.log('📊 ROUTE LOADING SUMMARY');
console.log('=' .repeat(50));

const successfulRoutes = [];
const failedRoutes = [];

routeResults.forEach(result => {
  if (result.success) {
    successfulRoutes.push(result);
    console.log(`✅ ${result.name}`);
  } else {
    failedRoutes.push(result);
    console.log(`❌ ${result.name}`);
  }
});

console.log(`\n📈 Results: ${successfulRoutes.length}/${routeResults.length} routes loaded successfully`);

// Load chỉ những routes thành công
console.log('\n🔧 Loading successful routes into main app...');

successfulRoutes.forEach(routeInfo => {
  try {
    const routePath = routeInfo.path.replace('./routes/', '');
    const apiPath = `/api/${routePath.replace('Routes', '').replace(/([A-Z])/g, '-$1').toLowerCase().substring(1)}`;
    
    app.use(apiPath, routeInfo.route);
    console.log(`✅ Mounted ${routeInfo.name} at ${apiPath}`);
  } catch (error) {
    console.error(`❌ Failed to mount ${routeInfo.name}:`, error.message);
  }
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Error:', err.stack);
  res.status(500).json({ 
    success: false,
    message: 'Có lỗi xảy ra!',
    error: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ 
    success: false,
    message: `Route không tồn tại: ${req.method} ${req.originalUrl}`
  });
});

const PORT = process.env.PORT || 3000;

if (failedRoutes.length === 0) {
  app.listen(PORT, () => {
    console.log('\n🎉 All routes loaded successfully!');
    console.log(`🚀 Server running on port ${PORT}`);
    console.log(`📡 API URL: http://localhost:${PORT}`);
  });
} else {
  console.log('\n⚠️  Some routes failed to load. Starting server with available routes only...');
  app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT} (partial functionality)`);
    console.log(`📡 API URL: http://localhost:${PORT}`);
    console.log('\n❌ Failed routes:');
    failedRoutes.forEach(route => {
      console.log(`   - ${route.name}: ${route.error.message}`);
    });
  });
}

module.exports = app;