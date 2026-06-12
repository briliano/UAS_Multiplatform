# 📝 KerenNote App - Multiplatform Persistence III Challenge

[![Flutter Version](https://img.shields.io/badge/Flutter-v3.x+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-v3.x+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Aplikasi manajemen catatan (*Note-Taking App*) modern berbasis Flutter yang mengimplementasikan **Persistensi Data Lokal III (Sistem Berkas Lokal)**. Proyek ini dibuat khusus untuk menyelesaikan **Soal 5 Tantangan** pada materi pembelajaran Pemrograman Multiplatform.

---

## ✨ Fitur Utama (Tantangan Soal 5)

Aplikasi ini telah dirancang ulang sepenuhnya untuk mendukung mekanisme penyimpanan multimedia tingkat lanjut dengan ketentuan:
*   📸 **Triple Photo Slot:** Mendukung penyimpanan hingga maksimal 3 foto per catatan.
*   💾 **Manajemen File Terisolasi:** Gambar disimpan secara asinkron dengan penamaan terstruktur (`image_1.jpg`, `image_2.jpg`, `image_3.jpg`) di dalam sub-direktori catatan yang unik.
*   🔄 **Indikator Kuota Dinamis:** Antarmuka secara cerdas melacak jumlah foto (`imageCount`) dan mengunci tombol *add* apabila kuota lampiran penuh (3/3).
*   🗑️ **Penghapusan Independen:** Menghapus satu lampiran foto tertentu tanpa merusak atau memengaruhi berkas gambar lainnya di dalam folder.
*   🎨 **Premium Modern UI:** Tampilan editor minimalis-elegan yang dilengkapi efek *bouncing scroll* horizontal, frame foto bergaya *soft shadow*, dan mikro-animasi pada komponen tombol.

---

## 🛠️ Paket & Arsitektur Dependensi

Aplikasi memanfaatkan sinergi pustaka cross-platform berikut untuk menjamin performa IO biner yang gegas:
*   **`dart:io`**: Library inti Dart untuk manipulasi entitas fisik file system secara asinkron.
*   **`path_provider`**: Penentu lokasi direktori penyimpanan lokal aman (`getApplicationDocumentsDirectory`).
*   **`image_picker`**: Antarmuka jembatan untuk memilih dokumen multimedia langsung dari galeri perangkat.

---

## 📸 Antarmuka Aplikasi (Preview)

| Halaman Daftar Catatan | Halaman Editor (Kuota Tersedia) | Halaman Editor (Kuota Penuh) |
| :---: | :---: | :---: |
| ![List Screen](https://via.placeholder.com/200x400.png?text=List+Screen) | ![Editor Active](https://via.placeholder.com/200x400.png?text=Editor+Slot+Available) | ![Editor Max Out](https://via.placeholder.com/200x400.png?text=Editor+Slot+Full) |

> *Catatan: Anda dapat mengganti gambar placeholder di atas dengan screenshot asli aplikasi Anda setelah di-run.*

---

## 🚀 Cara Menjalankan Proyek

### 1. Prasyarat
Pastikan Flutter SDK dan Git sudah terpasang di komputer Anda.

### 2. Kloning Proyek
```bash
git clone [https://github.com/USERNAME_ANDA/NAMA_REPOSITORI.git](https://github.com/USERNAME_ANDA/NAMA_REPOSITORI.git)
cd NAMA_REPOSITORI