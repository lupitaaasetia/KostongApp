const mongoose = require('mongoose');

const BookingSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  kost_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Kost' },
  kamar_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Kamar' },
  nomor_booking: String,
  tanggal_mulai: Date,
  tanggal_selesai: Date,
  durasi: Number,
  tipe_durasi: String,
  harga_total: Number,
  biaya_admin: Number,
  total_bayar: Number,
  status_booking: String,
  metode_pembayaran: String,
  catatan: String,
  created_at: { type: Date, default: Date.now },
  updated_at: { type: Date, default: Date.now },
  expired_at: Date
}, { collection: 'booking' });

module.exports = mongoose.model('Booking', BookingSchema);
