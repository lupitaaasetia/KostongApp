const express = require('express');
const router = express.Router();
const Notifikasi = require('../models/Notifikasi');
const auth = require('../middleware/authMiddleware');

// @route   GET api/notifikasi/user/:userId
router.get('/user/:userId', auth, async (req, res) => {
  try {
    const notifs = await Notifikasi.find({ user_id: req.params.userId })
      .sort({ createdAt: -1 })
      .limit(50);
    res.json(notifs);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   POST api/notifikasi
router.post('/', auth, async (req, res) => {
  try {
    const newNotif = new Notifikasi(req.body);
    const notif = await newNotif.save();
    res.status(201).json(notif);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   PUT api/notifikasi/:id/read
router.put('/:id/read', auth, async (req, res) => {
  try {
    const notif = await Notifikasi.findByIdAndUpdate(
      req.params.id,
      { read: true },
      { new: true }
    );
    
    if (!notif) {
      return res.status(404).json({ message: 'Notification not found' });
    }
    res.json(notif);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;