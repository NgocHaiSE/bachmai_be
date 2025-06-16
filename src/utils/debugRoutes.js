const express = require('express');
const path = require('path');

// Function to test individual route modules
const testRouteModule = (routeName, routePath) => {
  try {
    console.log(`\n🔍 Testing route: ${routeName}`);
    
    // Create a test app instance
    const testApp = express();
    
    // Try to require the route module
    const routeModule = require(routePath);
    
    // Check if it's a valid Express router
    if (typeof routeModule === 'function' || (routeModule && typeof routeModule.use === 'function')) {
      // Try to mount the route
      testApp.use('/test', routeModule);
      console.log(`✅ ${routeName}: Successfully loaded and mounted`);
      return true;
    } else {
      console.log(`❌ ${routeName}: Not a valid Express router`);
      console.log(`   Module exports:`, Object.keys(routeModule || {}));
      return false;
    }
  } catch (error) {
    console.error(`❌ ${routeName}: Error loading route`);
    console.error(`   Error: ${error.message}`);
    if (error.stack) {
      console.error(`   Stack: ${error.stack.split('\n')[1]?.trim()}`);
    }
    return false;
  }
};

// Function to test controller functions
const testController = (controllerName, controllerPath) => {
  try {
    console.log(`\n🔍 Testing controller: ${controllerName}`);
    
    const controller = require(controllerPath);
    
    if (!controller || typeof controller !== 'object') {
      console.log(`❌ ${controllerName}: Not a valid controller object`);
      return false;
    }
    
    const functions = Object.keys(controller);
    console.log(`✅ ${controllerName}: Found ${functions.length} functions`);
    
    // Check if all exports are functions
    const invalidFunctions = functions.filter(fn => typeof controller[fn] !== 'function');
    if (invalidFunctions.length > 0) {
      console.log(`⚠️  ${controllerName}: Non-function exports:`, invalidFunctions);
    }
    
    console.log(`   Functions: ${functions.join(', ')}`);
    return true;
  } catch (error) {
    console.error(`❌ ${controllerName}: Error loading controller`);
    console.error(`   Error: ${error.message}`);
    return false;
  }
};

// Main debug function
const debugRoutes = () => {
  console.log('🚀 Starting route debugging...\n');
  
  const basePath = path.join(__dirname, '..');
  
  // Test all controllers first
  const controllers = [
    { name: 'userController', path: path.join(basePath, 'controllers', 'userController.js') },
    { name: 'benhNhanController', path: path.join(basePath, 'controllers', 'benhNhanController.js') },
    { name: 'pdkKhamController', path: path.join(basePath, 'controllers', 'pdkKhamController.js') },
    { name: 'chuyenVienController', path: path.join(basePath, 'controllers', 'chuyenVienController.js') },
    { name: 'donThuocController', path: path.join(basePath, 'controllers', 'donThuocController.js') },
    { name: 'duocPhamController', path: path.join(basePath, 'controllers', 'duocPhamController.js') },
    { name: 'khamBenhController', path: path.join(basePath, 'controllers', 'khamBenhController.js') },
    { name: 'vacXinController', path: path.join(basePath, 'controllers', 'vacXinController.js') },
    { name: 'lichLamViecController', path: path.join(basePath, 'controllers', 'lichLamViecController.js') },
    { name: 'chuyenCaController', path: path.join(basePath, 'controllers', 'chuyenCaController.js') }
  ];
  
  console.log('📋 TESTING CONTROLLERS:');
  let controllerResults = controllers.map(controller => ({
    name: controller.name,
    success: testController(controller.name, controller.path)
  }));
  
  // Test all routes
  const routes = [
    { name: 'userRoutes', path: path.join(basePath, 'routes', 'userRoutes.js') },
    { name: 'benhNhanRoutes', path: path.join(basePath, 'routes', 'benhNhanRoutes.js') },
    { name: 'pdkKhamRoutes', path: path.join(basePath, 'routes', 'pdkKhamRoutes.js') },
    { name: 'chuyenVienRoutes', path: path.join(basePath, 'routes', 'chuyenVienRoutes.js') },
    { name: 'donThuocRoutes', path: path.join(basePath, 'routes', 'donThuocRoutes.js') },
    { name: 'duocPhamRoutes', path: path.join(basePath, 'routes', 'duocPhamRoutes.js') },
    { name: 'khamBenhRoutes', path: path.join(basePath, 'routes', 'khamBenhRoutes.js') },
    { name: 'vacXinRoutes', path: path.join(basePath, 'routes', 'vacXinRoutes.js') },
    { name: 'lichLamViecRoutes', path: path.join(basePath, 'routes', 'lichLamViecRoutes.js') }
  ];
  
  console.log('\n\n📋 TESTING ROUTES:');
  let routeResults = routes.map(route => ({
    name: route.name,
    success: testRouteModule(route.name, route.path)
  }));
  
  // Summary
  console.log('\n\n📊 SUMMARY:');
  console.log('Controllers:');
  controllerResults.forEach(result => {
    console.log(`  ${result.success ? '✅' : '❌'} ${result.name}`);
  });
  
  console.log('\nRoutes:');
  routeResults.forEach(result => {
    console.log(`  ${result.success ? '✅' : '❌'} ${result.name}`);
  });
  
  const totalControllers = controllerResults.length;
  const successfulControllers = controllerResults.filter(r => r.success).length;
  const totalRoutes = routeResults.length;
  const successfulRoutes = routeResults.filter(r => r.success).length;
  
  console.log(`\nControllers: ${successfulControllers}/${totalControllers} successful`);
  console.log(`Routes: ${successfulRoutes}/${totalRoutes} successful`);
  
  if (successfulControllers === totalControllers && successfulRoutes === totalRoutes) {
    console.log('\n🎉 All modules loaded successfully!');
    return true;
  } else {
    console.log('\n⚠️  Some modules failed to load. Check the errors above.');
    return false;
  }
};

// Run if called directly
if (require.main === module) {
  debugRoutes();
}

module.exports = { debugRoutes, testRouteModule, testController };