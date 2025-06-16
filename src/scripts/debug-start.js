#!/usr/bin/env node

/**
 * Debug startup script for Hospital Management System API
 * This script will test all routes and controllers before starting the main server
 */

const { debugRoutes } = require('../src/utils/debugRoutes');

console.log('🏥 Hospital Management System - Debug Startup');
console.log('=' .repeat(50));

// Run route debugging
const allModulesOk = debugRoutes();

if (allModulesOk) {
  console.log('\n🚀 Starting main server...');
  console.log('=' .repeat(50));
  
  // Start the main application
  require('../src/app.js');
} else {
  console.log('\n❌ Cannot start server due to module loading errors.');
  console.log('Please fix the issues above and try again.');
  process.exit(1);
}