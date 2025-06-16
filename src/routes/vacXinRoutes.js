const express = require('express');
const router = express.Router();
const {
  timKiemVacXin,
  layChiTietVacXin,
  layTatCaVacXin,
  layVacXinConHang,
  layVacXinHetHan
} = require('../controllers/vacXinController');

// Routes cho vắc xin
router.get('/', layTatCaVacXin);
router.get('/search', timKiemVacXin);
router.get('/con-hang', layVacXinConHang);
router.get('/het-han', layVacXinHetHan);
router.get('/:id', layChiTietVacXin);

module.exports = router;