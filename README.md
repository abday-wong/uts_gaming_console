# Doran Gaming Console - Aplikasi E-Commerce & Integrasi Pembayaran

Proyek ini adalah bagian dari tugas **Ujian Akhir Semester (UAS) Genap 2025/2026** untuk mata kuliah **Aplikasi Mobile Lanjutan**.

### 👤 Identitas Mahasiswa
* **Nama**: [Tulis Nama Anda Di Sini]
* **NIM**: [Tulis NIM Anda Di Sini]
* **Kelas**: [Tulis Kelas Anda Di Sini]
* **Matakuliah**: Aplikasi Mobile Lanjutan (KB1154)
* **Program Studi**: Teknik Informatika
* **Dosen Pengampu**: IKetut Gunawan, S.KOM, M.T.I
* **Institut**: Institut Teknologi & Bisnis Bina Sarana Global

---

## 1. 📱 Deskripsi Aplikasi
**Doran Gaming Console** adalah aplikasi E-Commerce berbasis Flutter yang mengkhususkan diri pada katalog penjualan konsol game (seperti PlayStation 5, Xbox Series X, Nintendo Switch) beserta aksesoris gaming premium. Aplikasi ini merupakan pengembangan lanjutan dari proyek UTS dengan integrasi metode pembayaran eksternal (*App-to-App Integration*) ke dompet digital **Doran Pay** melalui mekanisme **Deep Link**.

### Fitur Utama:
* **Katalog Produk & Detail**: Menampilkan koleksi konsol game dan aksesoris dengan deskripsi lengkap dan harga.
* **Keranjang Belanja (Cart)**: Menambah, memodifikasi kuantitas, dan menghapus item belanjaan sebelum checkout.
* **Integrasi Pembayaran (Outgoing Deep Link)**: Mengirimkan total tagihan belanja secara instan ke aplikasi Doran Pay untuk diproses pembayarannya.
* **Penanganan Status Transaksi (Incoming Deep Link)**: Menerima callback dari Doran Pay, membersihkan isi keranjang belanja secara otomatis jika transaksi sukses, menyimpan log rincian transaksi, dan menampilkan struk bukti pembayaran digital.
* **Notifikasi Pengiriman (FCM)**: Menerima notifikasi push status transaksi dan logistik barang menggunakan Firebase Cloud Messaging.
* **Desain Estetika Retro-Modern (Neubrutalism)**: Tampilan visual berani yang mencolok, menggunakan garis border hitam tebal (2.5px), bayangan datar tanpa blur (*flat shadows*), tipografi tebal, dan palet warna kontras tinggi (kuning stabilo, biru langit, hijau lime, jingga).

---

## 2. 🏗️ Arsitektur Aplikasi
Aplikasi Doran Gaming Console dirancang menggunakan pola arsitektur **MVVM (Model-View-ViewModel)** dengan pemisahan peran yang jelas untuk memudahkan pengujian kode:

```
lib/
├── core/
│   ├── router/          # Konfigurasi Navigasi & Deep Link Handlers
│   └── theme/           # Konfigurasi Gaya Neubrutalism (Shadows, Borders, Colors)
├── models/              # Struktur data model (Product, CartItem, Transaction)
├── providers/           # ViewModels / State Management (CartProvider, AuthProvider)
├── screens/             # Presentation Views (Dashboard, ProductDetail, Cart, Success)
├── services/            # Secure Storage & Firebase Cloud Messaging
└── main.dart            # Inisialisasi Firebase & Entry point utama
```

### Penjelasan Komponen MVVM:
* **Model**: Representasi data produk, keranjang, dan rincian transaksi belanja.
* **View (Screens)**: File antarmuka pengguna yang murni bertugas merender layout Neubrutalism. View merespons perubahan data yang dipancarkan oleh Providers (ViewModels) dan memicu fungsi tindakan (seperti checkout atau menambah item).
* **ViewModel (Providers)**: Menggunakan package **Provider** untuk menangani logika aplikasi. Misalnya, `CartProvider` mengurus perhitungan subtotal harga produk, penambahan jumlah kuantitas barang, pengosongan keranjang belanja saat transaksi berhasil, serta penyimpanan riwayat transaksi ke penyimpanan terenkripsi lokal HP (`SecureStorage`).

---

## 3. 🌐 Implementasi Deep Link & Notifikasi FCM
Bagian ini menjelaskan teknik integrasi utama yang digunakan pada UAS:

### A. Deep Link Outgoing (Checkout)
Ketika pengguna menekan tombol "Bayar Sekarang" di halaman keranjang belanja, aplikasi merangkai string query URL checkout khusus:
```
dpay://checkout?amount=450000&recipient_email=merchant@gamingstore.com&trx_id=TX-871528&callback_url=ecommerce://callback
```
Aplikasi menggunakan library `url_launcher` untuk meluncurkan link ini. Sistem Android akan secara otomatis membuka aplikasi **Doran Pay** untuk melanjutkan pembayaran.

### B. Deep Link Incoming (Callback Handler)
Aplikasi mendaftarkan skema URL `ecommerce://callback` di file `android/app/src/main/AndroidManifest.xml`.
* Saat transaksi di Doran Pay selesai, Doran Pay memicu callback tersebut.
* Aplikasi menangkap URI callback, mengambil parameter query (`status`, `trx_id`, `amount`, `recipient_email`), lalu mengeksekusi logika:
  * Jika status adalah `success`, `CartProvider.clearCart()` dipanggil untuk mereset keranjang belanja.
  * Data rincian transaksi sukses disimpan ke `SecureStorage` untuk dicatat sebagai riwayat transaksi.
  * Aplikasi langsung mengalihkan rute ke `PaymentSuccessPage` untuk menampilkan struk bukti pembayaran yang detail kepada pengguna.

### C. Firebase Cloud Messaging (FCM)
Aplikasi terintegrasi dengan Firebase Cloud Messaging untuk mendengarkan pesan notifikasi transaksi secara langsung di latar belakang (*background*) maupun saat aplikasi aktif (*foreground*). Notifikasi ini membantu pengguna mendapatkan informasi status pengiriman barang setelah pembayaran dikonfirmasi oleh sistem.

---

## 4. 🚀 Cara Menjalankan Proyek
Ikuti langkah-langkah berikut untuk menjalankan aplikasi:

### Langkah 1: Persiapan Backend
Pastikan backend `gaming-console-backend` (layanan Go) telah berjalan dan terhubung dengan database lokal Anda sebelum memulai aplikasi mobile.

### Langkah 2: Instalasi Dependensi Flutter
Buka terminal di folder `uts_gaming_console` lalu jalankan perintah:
```bash
flutter pub get
```

### Langkah 3: Menjalankan Aplikasi
Hubungkan HP Android (aktifkan USB Debugging) atau jalankan Emulator Android, kemudian ketik:
```bash
flutter run
```

---

## 5. 📦 Daftar Dependensi Utama
* `provider` — State management untuk logika keranjang belanja dan transaksi.
* `url_launcher` — Membuka link eksternal untuk mengalihkan ke aplikasi E-Wallet.
* `firebase_core` & `firebase_messaging` — Konfigurasi push notification transaksi dari cloud.
* `flutter_secure_storage` — Menyimpan log riwayat transaksi lokal secara terenkripsi.
* `google_fonts` — Pemuatan font sans-serif modern (Plus Jakarta Sans).

---

## 📸 Screenshot Aplikasi
*(Anda dapat melampirkan screenshot antarmuka Neubrutalism aplikasi di bawah ini)*

| Dashboard Catalog | Detail Produk | Keranjang Belanja & Checkout | Detail Struk Sukses |
| :---: | :---: | :---: | :---: |
| ![Catalog](screenshots/catalog.png) | ![Detail](screenshots/detail.png) | ![Cart](screenshots/cart.png) | ![Receipt](screenshots/success.png) |

---

## 🎥 Link Video Presentasi
Silakan akses video demonstrasi alur transaksi lengkap dan penjelasan kode program pada tautan YouTube berikut:
* 🔗 **[Link Video Presentasi UAS Mobile Lanjutan](https://youtube.com/...)**
