class BookingModel {
  final String id;
  final String userId;
  final String kostId;
  final String? kamarId;
  final String? nomorBooking;
  final DateTime? tanggalMulai;
  final DateTime? tanggalSelesai;
  final int? durasi;
  final String? tipeDurasi;
  final double? hargaTotal;
  final double? biayaAdmin;
  final double? totalBayar;
  final String? statusBooking;
  final String? metodePembayaran;
  final String? catatan;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? expiredAt;
  final Map<String, dynamic>? kost;
  final Map<String, dynamic>? kamar;

  BookingModel({
    required this.id,
    required this.userId,
    required this.kostId,
    this.kamarId,
    this.nomorBooking,
    this.tanggalMulai,
    this.tanggalSelesai,
    this.durasi,
    this.tipeDurasi,
    this.hargaTotal,
    this.biayaAdmin,
    this.totalBayar,
    this.statusBooking,
    this.metodePembayaran,
    this.catatan,
    this.createdAt,
    this.updatedAt,
    this.expiredAt,
    this.kost,
    this.kamar,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['user_id'] ?? '',
      kostId: json['kost_id'] is String
          ? json['kost_id']
          : (json['kost_id']?['_id'] ?? ''),
      kamarId: json['kamar_id'] is String
          ? json['kamar_id']
          : json['kamar_id']?['_id'],
      nomorBooking: json['nomor_booking'],
      tanggalMulai: json['tanggal_mulai'] != null
          ? DateTime.tryParse(json['tanggal_mulai'].toString())
          : null,
      tanggalSelesai: json['tanggal_selesai'] != null
          ? DateTime.tryParse(json['tanggal_selesai'].toString())
          : null,
      durasi: json['durasi'],
      tipeDurasi: json['tipe_durasi'],
      hargaTotal: json['harga_total'] != null
          ? (json['harga_total'] as num).toDouble()
          : null,
      biayaAdmin: json['biaya_admin'] != null
          ? (json['biaya_admin'] as num).toDouble()
          : null,
      totalBayar: json['total_bayar'] != null
          ? (json['total_bayar'] as num).toDouble()
          : null,
      statusBooking: json['status_booking'],
      metodePembayaran: json['metode_pembayaran'],
      catatan: json['catatan'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      expiredAt: json['expired_at'] != null
          ? DateTime.tryParse(json['expired_at'].toString())
          : null,
      kost: json['kost_id'] is Map
          ? Map<String, dynamic>.from(json['kost_id'])
          : null,
      kamar: json['kamar_id'] is Map
          ? Map<String, dynamic>.from(json['kamar_id'])
          : null,
    );
  }
}
