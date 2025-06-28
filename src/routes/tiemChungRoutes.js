const express = require('express');
const router = express.Router();
const {
  layTatCaPDKTiemChung,
  suaPDKTiemChung,
  chiTietPDK,
  huyPDKTiemChung,
  themPDKTiemChung
} = require('../controllers/tiemChungController');

// Routes cho vắc xin
router.get('/', layTatCaPDKTiemChung);
router.get('/:id', chiTietPDK);
router.post('/', themPDKTiemChung);
router.put('/:id', suaPDKTiemChung);
router.delete('/:id', huyPDKTiemChung);
module.exports = router;