const express = require('express');
const router = express.Router();
const {
  layTatCaNhanVien,
} = require('../controllers/nhanVienController');

router.get('/', layTatCaNhanVien);             

module.exports = router;