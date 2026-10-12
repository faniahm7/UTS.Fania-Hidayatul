# Soal 2.2 — Penanganan Concurrency (Race Condition)

**Nama** : Fania Hidayatul Mustafidah  
**NIM**  : 12030124130178  
**UTS**  : Pemrograman / Coding Gasal 2026/2027

---

## Masalah: Race Condition / Phantom Stock

### Skenario
Dua kasir (Kasir A dan Kasir B) memproses penjualan untuk **item 
yang sama** pada **detik yang sama**, sedangkan stok hanya tersisa 
**1 unit**.

### Tanpa Proteksi (BAHAYA!)

    Kasir A: SELECT stock_qty -> hasil: 1 (cukup, lanjut jual)
    Kasir B: SELECT stock_qty -> hasil: 1 (cukup juga! belum ter-update)

    Kasir A: INSERT SALE 1 -> trigger update stok jadi 0
    Kasir B: INSERT SALE 1 -> trigger update stok jadi -1  [OVERSOLD!]

Akibatnya: stok jadi minus, barang terjual 2 padahal cuma ada 1 
-> **overselling** / **phantom stock**.

---

## Solusi 1: SELECT ... FOR UPDATE (Pessimistic Lock)

### Konsep
Sebelum membaca stok, kita **"kunci" baris** item tersebut. Selama 
transaksi A belum selesai, transaksi B harus **menunggu (blocked)** 
sampai lock dilepas.

### Cuplikan Kode

    BEGIN;

    -- Kunci baris item (kasir lain yang akses item yang sama akan BLOCKED)
    SELECT stock_qty 
    FROM inventory_items 
    WHERE item_id = 'BRG01'
    FOR UPDATE;

    -- Insert transaksi penjualan
    INSERT INTO inventory_transactions (item_id, trx_type, qty)
    VALUES ('BRG01', 'SALE', 1);

    COMMIT;

### Cara Kerja
- Kasir A lock baris -> Kasir B **blocked** sampai A commit
- Setelah A commit, stok update jadi 0
- Kasir B lanjut, lihat stok = 0 -> **trigger raise exception**
- Tidak ada overselling

---

## Solusi 2: Isolation Level SERIALIZABLE

### Konsep
Set transaksi pada level isolasi tertinggi. PostgreSQL akan 
mendeteksi konflik dan **membatalkan salah satu transaksi** 
secara otomatis (minta user retry).

### Cuplikan Kode

    BEGIN ISOLATION LEVEL SERIALIZABLE;

        SELECT stock_qty FROM inventory_items WHERE item_id = 'BRG01';
        -- validasi & insert transaksi

    COMMIT;

### Cara Kerja
- Kalau ada konflik (dua transaksi baca data yang sama), 
  PostgreSQL akan abort salah satunya dengan error:
  `could not serialize access due to concurrent update`
- Aplikasi harus **retry** transaksi yang di-abort

---

## Solusi 3: Locking di Trigger (Best Practice)

Pada praktiknya, **solusi terbaik** adalah **menggabungkan 
keduanya**: terapkan `SELECT ... FOR UPDATE` di dalam **trigger 
function**. Setiap INSERT ke `inventory_transactions` otomatis 
mengunci baris inventory yang relevan.

Ini sudah diimplementasikan di `trigger.sql` pada Soal 2.1:

    SELECT stock_qty INTO current_stock
    FROM inventory_items
    WHERE item_id = NEW.item_id
    FOR UPDATE;

### Keunggulan
- Lock terjadi **otomatis** di level database
- Tidak bergantung pada aplikasi frontend
- Mencegah race condition **apapun** jenis kliennya (web, mobile, API)

---

## Kesimpulan

| Solusi | Kelebihan | Kekurangan |
|--------|-----------|-----------|
| `SELECT ... FOR UPDATE` | Simpel, efisien, tepat sasaran | Perlu disiplin di setiap query |
| `SERIALIZABLE` | Paling ketat, otomatis | Sering abort, perlu retry logic |
| **Combined (best practice)** | Aman + terpusat di DB | Tidak ada |

Untuk sistem akuntansi dan persediaan, **selalu gunakan 
`SELECT ... FOR UPDATE`** pada operasi yang mengubah saldo, agar 
integritas data terjamin meski ada banyak user konkuren.