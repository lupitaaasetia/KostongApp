const express = require('express');
const router = express.Router();
const RiwayatTransaksi = require('../models/RiwayatTransaksi');
const verifyToken = require('../middleware/authMiddleware');

// GET /api/riwayat/:user_id
router.get('/:user_id', verifyToken, async (req, res) => {
  try {
    const { user_id } = req.params;
    const history = await RiwayatTransaksi.find({ user_id }).sort({ createdAt: -1 });
    res.json(history);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
});

module.exports = router;
