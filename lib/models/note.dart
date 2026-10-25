import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final String category;
  final String priority;
  final Color color;
  final DateTime updatedAt;
  final bool archived;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.priority,
    required this.color,
    required this.updatedAt,
    this.archived = false,
  });

  Note copyWith({
    String? title,
    String? content,
    String? category,
    String? priority,
    Color? color,
    DateTime? updatedAt,
    bool? archived,
  }) =>
      Note(
        id: id,
        title: title ?? this.title,
        content: content ?? this.content,
        category: category ?? this.category,
        priority: priority ?? this.priority,
        color: color ?? this.color,
        updatedAt: updatedAt ?? this.updatedAt,
        archived: archived ?? this.archived,
      );

  static List<Note> demoNotes() {
    final now = DateTime.now();
    return [
      Note(
        id: 'demo-1',
        title: 'Ide Aplikasi',
        content: 'Ide untuk membuat aplikasi catatan sederhana dengan fitur kategori, warna, dan prioritas. Aplikasi ini digunakan untuk mencatat ide, rencana, dan hal penting sehari-hari.',
        category: 'Pribadi',
        priority: 'Tinggi',
        color: AppColors.matcha,
        updatedAt: now.subtract(const Duration(minutes: 25)),
      ),
      Note(
        id: 'demo-2',
        title: 'Rencana Mingguan',
        content: 'Menyusun daftar kegiatan minggu ini, menentukan target, dan menyisihkan waktu untuk evaluasi di akhir pekan.',
        category: 'Pribadi',
        priority: 'Sedang',
        color: AppColors.babyBlue,
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Note(
        id: 'demo-3',
        title: 'Catatan Kuliah',
        content: 'Merangkum materi perkuliahan, melengkapi referensi, dan menyiapkan pertanyaan untuk sesi diskusi berikutnya.',
        category: 'Kuliah',
        priority: 'Sedang',
        color: const Color(0xFFDDE9D4),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      Note(
        id: 'demo-4',
        title: 'Hal yang Perlu Dibeli',
        content: 'Buat daftar kebutuhan sebelum pergi ke toko supaya tidak ada barang yang terlupa.',
        category: 'Belanja',
        priority: 'Rendah',
        color: const Color(0xFFF0E8CF),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      Note(
        id: 'demo-5',
        title: 'Jurnal Harian',
        content: 'Hari ini berjalan cukup baik. Catat hal yang disyukuri dan satu hal yang ingin diperbaiki besok.',
        category: 'Pribadi',
        priority: 'Rendah',
        color: const Color(0xFFE5EDE8),
        updatedAt: now.subtract(const Duration(days: 4)),
      ),
    ];
  }
}

String formatNoteDate(DateTime date) {
  const months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];
  final day = date.day.toString().padLeft(2, '0');
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$day ${months[date.month - 1]} ${date.year} · $hour.$minute';
}
