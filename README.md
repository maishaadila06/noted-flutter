# Noted — Flutter UI Demo

Aplikasi catatan harian sederhana berdasarkan referensi desain yang dikirim. Seluruh warna utama diambil dari palette:

| Nama | Hex | Penggunaan |
|---|---|---|
| Eggshell | `#FCF6EF` | Latar utama |
| Shrek | `#A0A742` | Aksen/penanda prioritas |
| Baby Blue | `#C7DBE2` | Latar lembut dan ikon |
| Matcha | `#BBCF9B` | Kartu catatan dan aksen |
| Viridian | `#498B6D` | Tombol utama dan navigasi |
| Seven Seas | `#33576E` | Teks utama dan ikon |

## Halaman dan fitur
1. **Splash Screen** — logo dan nama Noted.
2. **Login Statis** — input email/password, toggle password, tombol masuk dan Google (keduanya hanya navigasi demo; tidak ada autentikasi).
3. **Beranda** — contoh catatan, pencarian, filter Semua/Penting/Pribadi/Kerja, navigasi bawah, tombol tambah.
4. **Tambah/Edit Catatan** — validasi judul dan isi, kategori, warna, prioritas.
5. **Detail Catatan** — melihat isi, edit, hapus dengan konfirmasi, arsipkan/kembalikan dari arsip.

Ada juga halaman **Arsip** dan **Profil** sebagai bagian dari navigasi bawah. Data menggunakan state lokal di memori; belum terhubung database/API dan akan kembali ke data demo ketika aplikasi dimulai ulang.

## Cara menjalankan
1. Pastikan Flutter SDK sudah terpasang dan jalankan `flutter doctor`.
2. Ekstrak ZIP, lalu buka terminal di folder `noted_flutter`. Folder ini berisi source inti (`lib/` dan `pubspec.yaml`), belum termasuk folder platform bawaan Flutter.
3. Buat scaffold Android/iOS/Web satu kali:

```bash
flutter create --project-name noted --platforms=android,ios,web .
```

4. Ambil dependency dan jalankan aplikasinya:

```bash
flutter pub get
flutter run
```

Untuk menjalankan di emulator Android, buka emulator terlebih dahulu atau sambungkan perangkat dengan USB debugging aktif.

## Struktur folder

```text
noted_flutter/
├── lib/
│   ├── main.dart
│   ├── models/note.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   ├── add_note_screen.dart
│   │   └── detail_note_screen.dart
│   └── theme/app_theme.dart
├── pubspec.yaml
└── README.md
```
