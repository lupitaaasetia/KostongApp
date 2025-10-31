const express = require('express');
const router = express.Router();
const Booking = require('../models/Booking');
const auth = require('../middleware/authMiddleware');

// @route   GET api/booking/user/:userId
router.get('/user/:userId', auth, async (req, res) => {
  try {
    const bookings = await Booking.find({ user_id: req.params.userId })
      .populate('kost_id', 'title price address photos')
      .sort({ created_at: -1 });
    res.json(bookings);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   POST api/booking
router.post('/', auth, async (req, res) => {
  try {
    const newBooking = new Booking({
      ...req.body,
      nomor_booking: 'BK' + Date.now(),
      status_booking: 'pending',
      created_at: Date.now(),
      updated_at: Date.now()
    });
    
    const booking = await newBooking.save();
    res.status(201).json(booking);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   GET api/booking/:id
router.get('/:id', auth, async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id)
      .populate('kost_id')
      .populate('kamar_id');
    
    if (!booking) {
      return res.status(404).json({ message: 'Booking not found' });
    }
    res.json(booking);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   PUT api/booking/:id
router.put('/:id', auth, async (req, res) => {
  try {
    const booking = await Booking.findByIdAndUpdate(
      req.params.id,
      { ...req.body, updated_at: Date.now() },
      { new: true }
    );
    
    if (!booking) {
      return res.status(404).json({ message: 'Booking not found' });
    }
    res.json(booking);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;