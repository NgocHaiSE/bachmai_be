const express = require('express');
const router = express.Router();
const {
  themBenhNhan,
  layTatCaBenhNhan,
  timKiemBenhNhan,
  layBenhNhanTheoID
} = require('../controllers/benhNhanController');

// Routes cho bệnh nhân - /search must come before /:id
router.get('/search', timKiemBenhNhan);        // GET /api/benh-nhan/search?tuKhoa=xxx
router.get('/', layTatCaBenhNhan);             // GET /api/benh-nhan
router.post('/', themBenhNhan);                // POST /api/benh-nhan
router.get('/:id', layBenhNhanTheoID);         // GET /api/benh-nhan/:id

module.exports = router;