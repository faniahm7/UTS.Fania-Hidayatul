# Soal 3.1b — Verifikasi PSAK via NotebookLM

**Nama** : Fania Hidayatul Mustafidah  
**NIM**  : 12030124130178

---

## Sumber Referensi
- PSAK 2: Kas dan Setara Kas
- Kerangka Dasar Penyusunan dan Penyajian Laporan Keuangan

## Pertanyaan ke NotebookLM

"Bagaimana pengakuan dan pengukuran kas menurut PSAK? 
Apakah setiap pengeluaran kas harus dicatat berpasangan 
debit-kredit? Apa prinsip dasar yang harus dipenuhi dalam 
sistem pencatatan transaksi kas?"

## Ringkasan Hasil Verifikasi AI

Berdasarkan analisis NotebookLM terhadap dokumen PSAK:

### 1. Prinsip Pengakuan Kas
Kas dan setara kas diakui ketika entitas memiliki **kendali** 
atas sumber daya ekonomi tersebut. Untuk transaksi kas keluar, 
pengakuan dilakukan saat kas **benar-benar berpindah**.

### 2. Asas Double-Entry (Berpasangan)
Sistem pencatatan akuntansi menganut **double-entry 
bookkeeping** - setiap transaksi dicatat dengan pasangan 
Debit dan Kredit yang **nilainya sama besar**.

### 3. Dampak pada Purwarupa Web
Form entri jurnal **WAJIB**:
- Memvalidasi Total Debit = Total Kredit sebelum Submit aktif
- Mencegah zero-discrepancy di level aplikasi
- Menyimpan log audit (created_by, created_at) sebagai 
  bukti jejak
- Menyimpan hash_checksum untuk verifikasi integritas

### 4. Kesimpulan
Purwarupa form entri jurnal kas keluar **sesuai dengan PSAK**:
- Mengakui kas keluar saat berpindahnya dana
- Menegakkan asas double-entry secara ketat
- Memenuhi prinsip auditability (jejak audit)
- Menerapkan prinsip immutability (tidak dapat diubah 
  setelah POSTED)