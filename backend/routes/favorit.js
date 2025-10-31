const express = require('express');
const router = express.Router();
const Favorit = require('../models/Favorit');
const auth = require('../middleware/authMiddleware');

// @route   GET api/favorit/user/:userId
router.get('/user/:userId', auth, async (req, res) => {
  try {
    const favorits = await Favorit.find({ user_id: req.params.userId })
      .populate('kost_id')
      .sort({ createdAt: -1 });
    res.json(favorits);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   POST api/favorit
router.post('/', auth, async (req, res) => {
  try {
    const { user_id, kost_id } = req.body;
    
    const existing = await Favorit.findOne({ user_id, kost_id });
    if (existing) {
      return res.status(400).json({ message: 'Already in favorites' });
    }
    
    const newFavorit = new Favorit({ user_id, kost_id });
    const favorit = await newFavorit.save();
    res.status(201).json(favorit);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   DELETE api/favorit/:id
router.delete('/:id', auth, async (req, res) => {
  try {
    const favorit = await Favorit.findByIdAndDelete(req.params.id);
    if (!favorit) {
      return res.status(404).json({ message: 'Favorite not found' });
    }
    res.json({ message: 'Favorite removed' });
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;