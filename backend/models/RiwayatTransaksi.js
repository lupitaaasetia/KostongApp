const mongoose = require('mongoose');

const RiwayatSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  booking_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Booking' },
  amount: Number,
  status: String,
  createdAt: { type: Date, default: Date.now }
}, { collection: 'riwayat_transaksi' });

module.exports = mongoose.model('RiwayatTransaksi', RiwayatSchema);
