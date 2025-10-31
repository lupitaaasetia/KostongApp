import 'package:flutter/material.dart';

class KostModel {
  final String id;
  final String nama;
  final String alamat;
  final String deskripsi;
  final String tipe; // 'putra', 'putri', 'campur'
  final double harga;
  final List<String> fasilitas;
  final List<String> gambar;
  final double? latitude;
  final double? longitude;
  final String? nomorTelepon;
  final String? nomorWhatsapp;
  final double rating;
  final int jumlahKamar;
  final int kamarTersedia;
  final bool tersedia;
  final String? ownerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  KostModel({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.deskripsi,
    required this.tipe,
    required this.harga,
    required this.fasilitas,
    required this.gambar,
    this.latitude,
    this.longitude,
    this.nomorTelepon,
    this.nomorWhatsapp,
    this.rating = 0.0,
    this.jumlahKamar = 0,
    this.kamarTersedia = 0,
    this.tersedia = true,
    this.ownerId,
    this.createdAt,
    this.updatedAt,
  });

  factory KostModel.fromJson(Map<String, dynamic> json) {
    return KostModel(
      id: json['_id'] ?? json['id'] ?? '',
      nama: json['nama'] ?? json['name'] ?? '',
      alamat: json['alamat'] ?? json['address'] ?? '',
      deskripsi: json['deskripsi'] ?? json['description'] ?? '',
      tipe: json['tipe'] ?? json['type'] ?? 'campur',
      harga: (json['harga'] ?? json['price'] ?? 0).toDouble(),
      fasilitas: json['fasilitas'] != null
          ? List<String>.from(json['fasilitas'])
          : (json['facilities'] != null
              ? List<String>.from(json['facilities'])
              : []),
      gambar: json['gambar'] != null
          ? List<String>.from(json['gambar'])
          : (json['images'] != null ? List<String>.from(json['images']) : []),
      latitude: json['latitude']?.toDouble() ?? json['lat']?.toDouble(),
      longitude: json['longitude']?.toDouble() ?? json['lng']?.toDouble(),
      nomorTelepon: json['nomor_telepon'] ?? json['phone'],
      nomorWhatsapp: json['nomor_whatsapp'] ?? json['whatsapp'],
      rating: (json['rating'] ?? 0).toDouble(),
      jumlahKamar: json['jumlah_kamar'] ?? json['total_rooms'] ?? 0,
      kamarTersedia: json['kamar_tersedia'] ?? json['available_rooms'] ?? 0,
      tersedia: json['tersedia'] ?? json['available'] ?? true,
      ownerId: json['owner_id'] ?? json['ownerId'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : (json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'].toString())
              : null),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : (json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'].toString())
              : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nama': nama,
      'alamat': alamat,
      'deskripsi': deskripsi,
      'tipe': tipe,
      'harga': harga,
      'fasilitas': fasilitas,
      'gambar': gambar,
      'latitude': latitude,
      'longitude': longitude,
      'nomor_telepon': nomorTelepon,
      'nomor_whatsapp': nomorWhatsapp,
      'rating': rating,
      'jumlah_kamar': jumlahKamar,
      'kamar_tersedia': kamarTersedia,
      'tersedia': tersedia,
      'owner_id': ownerId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Getter methods
  Color getPrimaryColor() {
    switch (tipe.toLowerCase()) {
      case 'putri':
      case 'perempuan':
        return Colors.pink;
      case 'putra':
      case 'laki-laki':
        return Colors.blue;
      case 'campur':
      case 'mixed':
        return Colors.green;
      default:
        return Colors.purple;
    }
  }

  IconData getKostIcon() {
    switch (tipe.toLowerCase()) {
      case 'putri':
      case 'perempuan':
        return Icons.woman;
      case 'putra':
      case 'laki-laki':
        return Icons.man;
      case 'campur':
      case 'mixed':
        return Icons.people;
      default:
        return Icons.home;
    }
  }

  String getKostType() {
    switch (tipe.toLowerCase()) {
      case 'putri':
      case 'perempuan':
        return 'Kost Putri';
      case 'putra':
      case 'laki-laki':
        return 'Kost Putra';
      case 'campur':
      case 'mixed':
        return 'Kost Campur';
      default:
        return 'Kost';
    }
  }

  String getFormattedPrice() {
    if (harga >= 1000000) {
      return 'Rp ${(harga / 1000000).toStringAsFixed(1)}jt/bulan';
    } else if (harga >= 1000) {
      return 'Rp ${(harga / 1000).toStringAsFixed(0)}rb/bulan';
    } else {
      return 'Rp ${harga.toStringAsFixed(0)}/bulan';
    }
  }

  String getStatusText() {
    if (!tersedia) return 'Penuh';
    if (kamarTersedia == 0) return 'Penuh';
    if (kamarTersedia <= 3) return 'Hampir Penuh';
    return 'Tersedia';
  }

  Color getStatusColor() {
    if (!tersedia || kamarTersedia == 0) return Colors.red;
    if (kamarTersedia <= 3) return Colors.orange;
    return Colors.green;
  }

  // Facility icon mapping
  static IconData getFacilityIcon(String facility) {
    final facilityLower = facility.toLowerCase();
    if (facilityLower.contains('wifi')) return Icons.wifi;
    if (facilityLower.contains('ac') || facilityLower.contains('pendingin'))
      return Icons.ac_unit;
    if (facilityLower.contains('kasur') || facilityLower.contains('bed'))
      return Icons.bed;
    if (facilityLower.contains('lemari') || facilityLower.contains('wardrobe'))
      return Icons.closed_caption;
    if (facilityLower.contains('meja') || facilityLower.contains('table'))
      return Icons.table_restaurant;
    if (facilityLower.contains('kursi') || facilityLower.contains('chair'))
      return Icons.chair;
    if (facilityLower.contains('kamar mandi') ||
        facilityLower.contains('bathroom')) return Icons.bathroom;
    if (facilityLower.contains('dapur') || facilityLower.contains('kitchen'))
      return Icons.kitchen;
    if (facilityLower.contains('parkir') || facilityLower.contains('parking'))
      return Icons.local_parking;
    if (facilityLower.contains('laundry')) return Icons.local_laundry_service;
    if (facilityLower.contains('tv') || facilityLower.contains('televisi'))
      return Icons.tv;
    if (facilityLower.contains('kulkas') ||
        facilityLower.contains('refrigerator')) return Icons.kitchen;
    return Icons.check_circle;
  }

  static Color getFacilityColor(String facility) {
    final facilityLower = facility.toLowerCase();
    if (facilityLower.contains('wifi')) return Colors.blue;
    if (facilityLower.contains('ac')) return Colors.lightBlue;
    if (facilityLower.contains('kasur')) return Colors.purple;
    if (facilityLower.contains('lemari')) return Colors.brown;
    if (facilityLower.contains('meja')) return Colors.orange;
    if (facilityLower.contains('kamar mandi')) return Colors.cyan;
    if (facilityLower.contains('dapur')) return Colors.red;
    if (facilityLower.contains('parkir')) return Colors.green;
    if (facilityLower.contains('laundry')) return Colors.indigo;
    return Colors.grey;
  }
}

class FacilityItem {
  final String name;
  final IconData icon;
  final Color color;

  FacilityItem({
    required this.name,
    required this.icon,
    required this.color,
  });

  factory FacilityItem.fromString(String facility) {
    return FacilityItem(
      name: facility,
      icon: KostModel.getFacilityIcon(facility),
      color: KostModel.getFacilityColor(facility),
    );
  }
}
