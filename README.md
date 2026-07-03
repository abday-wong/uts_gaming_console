# Doran Gaming Console - Aplikasi E-Commerce dan Integrasi Pembayaran
**Proyek E-Commerce Penjualan Konsol Game**

Proyek ini adalah bagian dari tugas Ujian Tengah Semester (UTS) Genap 2025/2026 untuk mata kuliah Aplikasi Mobile Lanjutan.

### Identitas Mahasiswa

| Detail Akademik | Informasi |
| :--- | :--- |
| **Nama Lengkap** | Muhammad Abday Abdul Hafidz |
| **NIM** | 1123150093 |
| **Kelas** | TI SE23 P1 |
| **Program Studi** | Teknik Informatika |
| **Mata Kuliah** | Aplikasi Mobile Lanjutan (KB1154) |
| **Dosen Pengampu** | IKetut Gunawan, S.KOM, M.T.I |
| **Institut** | Institut Teknologi dan Bisnis Bina Sarana Global |

---

## 1. Deskripsi Aplikasi
Doran Gaming Console adalah aplikasi E-Commerce berbasis Flutter yang mengkhususkan diri pada katalog penjualan konsol game (seperti PlayStation 5, Xbox Series X, Nintendo Switch) beserta aksesoris gaming premium. Aplikasi ini merupakan pengembangan lanjutan dari proyek UTS dengan integrasi metode pembayaran eksternal (App-to-App Integration) ke dompet digital Doran Pay melalui mekanisme Deep Link.

### Fitur Utama:
* **Katalog Produk dan Detail**: Menampilkan koleksi konsol game dan aksesoris dengan deskripsi lengkap dan harga.
* **Keranjang Belanja (Cart)**: Menambah, memodifikasi kuantitas, dan menghapus item belanjaan sebelum checkout secara lokal.
* **Integrasi Pembayaran (Outgoing Deep Link)**: Mengirimkan total tagihan belanja secara instan ke aplikasi Doran Pay untuk diproses pembayarannya.
* **Penanganan Status Transaksi (Incoming Deep Link)**: Menerima callback dari Doran Pay, membersihkan isi keranjang belanja secara otomatis jika transaksi sukses, menyimpan log rincian transaksi, dan menampilkan struk bukti pembayaran digital.
* **Notifikasi Pengiriman (FCM)**: Menerima notifikasi push status transaksi dan logistik barang menggunakan Firebase Cloud Messaging.
* **Desain Estetika Retro-Modern (Neubrutalism)**: Tampilan visual berani yang mencolok, menggunakan garis border hitam tebal (2.5px), bayangan datar tanpa blur (flat shadows), tipografi tebal, dan palet warna kontras tinggi (kuning stabilo, biru langit, hijau lime, jingga).

---

## 2. Arsitektur Aplikasi
Aplikasi Doran Gaming Console dirancang menggunakan pola arsitektur **MVVM (Model-View-ViewModel)** dengan pemisahan folder berbasis modul fitur (*feature-based*):

```
uts_gaming_console/ (Root)
├── android/             # Konfigurasi platform Android native (AndroidManifest.xml, google-services.json)
├── assets/              # Aset gambar produk game konsol dan ikon aplikasi
├── lib/                 # Kode sumber utama Flutter
│   ├── core/
│   │   ├── constants/   # String statis, gambar, dan alamat API (AppStrings)
│   │   ├── routes/      # Konfigurasi navigasi rute halaman aplikasi (AppRouter)
│   │   ├── services/    # Secure Storage untuk log transaksi lokal & layanan Firebase Messaging
│   │   ├── theme/       # Sistem desain warna neubrutalism tebal (AppColors, AppTheme)
│   │   └── shared/      # Komponen UI reusable global (AppButton, AppTextField)
│   ├── features/
│   │   ├── auth/        # Login/Register, data user, dan otentikasi login
│   │   ├── cart/        # Halaman Cart, Checkout, struk sukses, dan state CartProvider
│   │   └── dashboard/   # Layar Katalog Utama, Detail Produk, dan ProductProvider
│   ├── firebase_options.dart # Konfigurasi client Firebase (tidak dilacak oleh Git)
│   └── main.dart        # Inisialisasi Firebase Core, penangkap Deep Link, dan routing
├── test/                # Berkas testing untuk uji coba program
├── pubspec.yaml         # Definisi dependensi package luar dan konfigurasi aset Flutter
└── README.md            # Dokumentasi utama proyek E-Commerce
```

### Penjelasan Komponen MVVM:
* **Model**: Struktur data mentah produk, item keranjang, dan rincian transaksi belanja (terletak di subfolder `data/models/`).
* **View (Screens)**: Tampilan antarmuka yang murni bertugas merender layout Neubrutalism dan berinteraksi langsung dengan pengguna.
* **ViewModel (Providers)**: Menggunakan package `Provider` untuk memisahkan logic dari UI. `CartProvider` mengurus perhitungan subtotal harga produk secara reaktif, menaikkan jumlah barang, menghapus barang, dan mengosongkan keranjang belanja saat callback pembayaran sukses terdeteksi.

---

## 3. Implementasi Deep Link dan Notifikasi FCM
Mekanisme ini dirancang untuk memenuhi ketentuan utama integrasi App-to-App yang aman:

### A. Deep Link Outgoing (Checkout)
Ketika pengguna menekan tombol "Bayar Sekarang" di halaman checkout, aplikasi merangkai string query URL checkout khusus ke aplikasi Doran Pay:
```
emoney://pay?amount=13000000&recipient=recipient@example.com&trx_id=TX-871528&callback=ecommerce://callback
```
Aplikasi menggunakan library `url_launcher` dengan mode `LaunchMode.externalApplication` untuk meluncurkan link ini. Sistem Android secara otomatis akan mendeteksi skema `emoney` dan membuka halaman pembayaran di aplikasi Doran Pay.

### B. Deep Link Incoming (Callback Handler)
Aplikasi mendaftarkan skema URL `ecommerce://callback` di file `android/app/src/main/AndroidManifest.xml`.
* Saat transaksi di Doran Pay selesai, Doran Pay memicu callback tersebut.
* Aplikasi menangkap URI callback di dalam file `lib/main.dart` melalui `_handleDeepLink(Uri uri)`.
* Aplikasi mengambil parameter query (`status`, `trx_id`, `amount`, `recipient_email`), lalu mengeksekusi logika:
  * Jika status adalah `success`, `CartProvider.clearCart()` dipanggil untuk mengosongkan keranjang belanja lokal.
  * Data rincian transaksi sukses disimpan ke `SecureStorage` untuk dicatat sebagai riwayat transaksi lokal.
  * Aplikasi langsung mengalihkan rute ke `PaymentSuccessPage` untuk menampilkan struk bukti pembayaran yang detail kepada pengguna.

### C. Firebase Cloud Messaging (FCM)
Aplikasi terintegrasi dengan Firebase Cloud Messaging untuk mendengarkan pesan notifikasi transaksi secara langsung di latar belakang (background) maupun saat aplikasi aktif (foreground). Notifikasi ini membantu pengguna mendapatkan informasi status pengiriman barang setelah pembayaran dikonfirmasi oleh sistem.

---

## 4. Cara Menjalankan Proyek
Ikuti langkah-langkah berikut untuk menjalankan aplikasi:

### Langkah 1: Persiapan Backend
Pastikan backend gaming-console-backend (layanan Go) telah berjalan dan terhubung dengan database lokal Anda sebelum memulai aplikasi mobile.

### Langkah 2: Instalasi Dependensi Flutter
Buka terminal di folder uts_gaming_console lalu jalankan perintah:
```bash
flutter pub get
```

### Langkah 3: Menjalankan Aplikasi
Hubungkan HP Android (aktifkan USB Debugging) atau jalankan Emulator Android, kemudian ketik:
```bash
flutter run
```

---

## 5. Daftar Dependensi Utama
* `provider` — State management untuk logika keranjang belanja dan transaksi.
* `url_launcher` — Membuka link eksternal untuk mengalihkan ke aplikasi E-Wallet.
* `firebase_core` & `firebase_messaging` — Konfigurasi push notification transaksi dari cloud.
* `flutter_secure_storage` — Menyimpan log riwayat transaksi lokal secara terenkripsi.
* `google_fonts` — Pemuatan font sans-serif modern (Plus Jakarta Sans).

---

## Screenshot Aplikasi

| Dashboard Catalog | Detail Produk | Keranjang Belanja & Checkout | Detail Struk Sukses |
| :---: | :---: | :---: | :---: |
| ![Catalog](screenshots/catalog.png) | ![Detail](screenshots/detail.png) | ![Cart](screenshots/cart.png) | ![Receipt](screenshots/success.png) |

---

## Link Video Presentasi
Silakan akses video demonstrasi alur transaksi lengkap dan penjelasan kode program pada tautan YouTube berikut:

[![Tonton Video Presentasi UTS/UAS](https://img.youtube.com/vi/q0XPGJDBPDU/hqdefault.jpg)](https://youtu.be/q0XPGJDBPDU)

**Tautan Video**: [https://youtu.be/q0XPGJDBPDU](https://youtu.be/q0XPGJDBPDU)

***(Pencet gambar di atas atau klik tautan video untuk menonton videonya)***

---

## 6. Repositori Proyek Terkait
Proyek integrasi App-to-App ini terdiri dari 4 modul repositori terpisah yang saling terhubung:

| Modul Proyek | Jenis Modul | Tautan Repositori GitHub |
| :--- | :--- | :--- |
| **Doran Pay (E-Money)** | Frontend (Flutter Mobile App) | [github.com/abday-wong/fe-emoney](https://github.com/abday-wong/fe-emoney) |
| **E-Money Backend** | Backend (Go REST API) | [github.com/abday-wong/be-emoney](https://github.com/abday-wong/be-emoney) |
| **Doran Gaming (E-Commerce)** | Frontend (Flutter Mobile App) | [github.com/abday-wong/uts_gaming_console](https://github.com/abday-wong/uts_gaming_console) |
| **E-Commerce Backend** | Backend (Go REST API) | [github.com/abday-wong/gaming-console-backend](https://github.com/abday-wong/gaming-console-backend) |
