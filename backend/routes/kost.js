const express = require('express');
const router = express.Router();
const Kost = require('../models/Kost');

// @route   GET api/kost
router.get('/', async (req, res) => {
  try {
    const kosts = await Kost.find().sort({ createdAt: -1 });
    res.json(kosts);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   GET api/kost/:id
router.get('/:id', async (req, res) => {
  try {
    const kost = await Kost.findById(req.params.id);
    if (!kost) {
      return res.status(404).json({ message: 'Kost not found' });
    }
    res.json(kost);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

// @route   POST api/kost
router.post('/', async (req, res) => {
  try {
    const newKost = new Kost(req.body);
    const kost = await newKost.save();
    res.status(201).json(kost);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;