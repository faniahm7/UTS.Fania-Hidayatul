# UTS Pemrograman / Coding — Gasal 2026/2027

**Nama** : Fania Hidayatul Mustafidah  
**NIM** : 12030124130178  
**Prodi** : S1 Akuntansi Reguler  
**Fakultas** : Ekonomika dan Bisnis, Universitas Diponegoro  
**Mata Kuliah** : Pemrograman / Coding  
**Dosen** : Totok Dewayanto  
**Tanggal Ujian** : Senin, 19 Oktober 2026

---

## 📂 Struktur Jawaban

| Soal | Topik | Folder |
|------|-------|--------|
| 1 | Desain Arsitektur Data, Normalisasi & Asas Berpasangan | [SOAL-1/](./SOAL-1/) |
| 2 | Otomasi Bisnis, Trigger & Concurrency Persediaan | [SOAL-2/](./SOAL-2/) |
| 3 | Purwarupa Web Full-Stack & AI Tools | [SOAL-3/](./SOAL-3/) |

---

## 📌 Ringkasan Jawaban

### Soal 1 — General Ledger Schema (Bobot 25%)

**1.1 ERD** — Diagram relasi 3 tabel:
- `chart_of_accounts` (master akun)
- `journal_headers` (header jurnal)
- `journal_lines` (baris debit/kredit)

**1.2 DDL PostgreSQL** — Implementasi dengan:
- Primary Key
- Foreign Key dengan `ON DELETE RESTRICT`
- CHECK constraint: `debit >= 0`, `credit >= 0`, dan `NOT (debit=0 AND credit=0)`

**1.3 Analisis** — Pemisahan Header-Line lebih andal karena:
- Audit trail jelas (1 header = 1 transaksi utuh)
- Memenuhi 3NF (tidak ada transitive dependency)
- Fleksibel untuk jurnal multi-baris

### Soal 2 — Otomasi Persediaan (Bobot 40%)

**2.1 Trigger** — `trg_update_stock_and_journal()`:
- Auto-update `stock_qty` tiap ada INSERT
- Tolak `SALE` yang bikin stok minus via `RAISE EXCEPTION`

**2.2 Concurrency** — Teknik anti race condition:
- `SELECT ... FOR UPDATE` (pessimistic lock)
- `SERIALIZABLE` isolation level
- Best practice: locking di dalam trigger

### Soal 3 — Purwarupa Web & AI Tools (Bobot 35%)

**3.1a Gemini Canvas** — Form entri jurnal kas keluar dengan:
- Live calculation Total Debit & Kredit
- Balanced indicator
- Validasi zero-discrepancy sebelum Submit

**3.1b NotebookLM** — Verifikasi kepatuhan PSAK 2 (Kas & Setara Kas)

**3.2 Audit Trail** — Trigger lock untuk POSTED + field audit:
- `created_by`, `created_at`, `hash_checksum`
- Jurnal pembalik (storno) untuk koreksi

---

## 🛠️ Tools & Teknologi

- **PostgreSQL** (Supabase Cloud) — untuk DDL & trigger
- **Gemini Canvas** — generate form web
- **NotebookLM** — verifikasi PSAK
- **VS Code** — editor
- **GitHub** — repositori publik

---

## 📎 Link Terkait

- **Repositori GitHub**: [isi link repo kamu di sini]
- **Supabase Project**: PROJECT UTS

---

© 2026 Fania Hidayatul Mustafidah — 12030124130178