# Soal 1.3 — Analisis Audit & Keamanan Finansial

**Nama** : Fania Hidayatul Mustafidah  
**NIM**  : 12030124130178  
**Mata Kuliah** : Pemrograman / Coding  
**UTS** : Gasal 2026/2027

---

## Mengapa Pemisahan Header-Line Lebih Andal dibanding Flat Table?

### 1. Dari Sudut Pandang Audit Trail (Jejak Audit)

Pemisahan tabel `journal_headers` dan `journal_lines` memungkinkan setiap 
transaksi jurnal memiliki identitas unik berupa nomor bukti (`reference_no`), 
tanggal (`trx_date`), dan status posting (`status_posting`) yang tercatat 
pada level header. Hal ini membuat auditor dapat dengan mudah menelusuri:

- Kapan transaksi dibuat (`trx_date`)
- Apa bukti transaksinya (`reference_no`)
- Apakah sudah diposting atau masih draft (`status_posting`)
- Detail setiap baris debit dan kredit pada `journal_lines`

Jika menggunakan model **flat table** (satu tabel untuk semua), informasi 
header seperti tanggal dan nomor bukti akan **berulang di setiap baris** 
transaksi. Hal ini menyebabkan:

- **Redundansi data** yang memperbesar risiko inkonsistensi
- **Sulit melacak transaksi sebagai satu kesatuan** karena tidak ada entitas 
  header yang jelas
- **Rentan terhadap anomali update** — jika satu baris diubah, yang lain 
  bisa tidak sinkron

### 2. Dari Sudut Pandang Bentuk Normal Ketiga (3NF)

Model Header-Line memenuhi kriteria 3NF secara natural:

**1NF (First Normal Form):** Setiap kolom berisi nilai atomik (tidak ada 
array atau repeating group). Pada flat table, sering muncul kolom seperti 
`debit1`, `credit1`, `debit2`, `credit2`, dst. yang melanggar 1NF.

**2NF (Second Normal Form):** Tidak ada partial dependency. Pada 
`journal_lines`, atribut seperti `debit` dan `credit` bergantung penuh 
pada Primary Key `line_id`, bukan sebagian.

**3NF (Third Normal Form):** Tidak ada transitive dependency. Atribut 
seperti `trx_date`, `reference_no`, dan `description` hanya bergantung pada 
`header_id`, sehingga dipisahkan ke tabel `journal_headers`. Jika digabung, 
atribut-atribut tersebut akan bergantung pada `line_id` melalui `header_id` 
(transitive) — melanggar 3NF.

### 3. Kesimpulan

Pemisahan Header-Line memberikan **integritas data yang lebih tinggi, 
jejak audit yang jelas, dan struktur yang sesuai kaidah normalisasi 3NF**. 
Selain itu, model ini juga lebih fleksibel untuk menangani jurnal multi-baris 
(multi-line journal) yang umum dalam praktik akuntansi, seperti jurnal 
penyesuaian dengan lebih dari dua akun.

Dengan constraint `CHECK (debit > 0 OR credit > 0)` dan 
`FOREIGN KEY ... ON DELETE RESTRICT`, integritas double-entry juga dapat 
ditegakkan langsung di level database — bukan hanya di frontend — sehingga 
mencegah anomali saldo tidak seimbang (unbalanced balance sheet) seperti 
yang terjadi pada sistem terdahulu.