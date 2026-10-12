-- ============================================================
-- SOAL 2.1 : PostgreSQL Trigger - Otomasi Stok Persediaan
-- Nama : Fania Hidayatul Mustafidah
-- NIM  : 12030124130178
-- UTS  : Pemrograman / Coding Gasal 2026/2027
-- ============================================================

-- ============================================================
-- 0. Setup Tabel (sesuai soal)
-- ============================================================
CREATE TABLE inventory_items (
    item_id   VARCHAR(10) PRIMARY KEY,
    item_name VARCHAR(100),
    stock_qty INT NOT NULL DEFAULT 0,
    unit_cost NUMERIC(15, 2) NOT NULL
);

CREATE TABLE inventory_transactions (
    trx_id   SERIAL PRIMARY KEY,
    item_id  VARCHAR(10) REFERENCES inventory_items(item_id),
    trx_type VARCHAR(10) CHECK (trx_type IN ('PURCHASE', 'SALE', 'ADJUSTMENT')),
    qty      INT NOT NULL,
    trx_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 1. TRIGGER FUNCTION
-- trg_update_stock_and_journal()
-- Tugas:
--   a. Update stock_qty tiap ada INSERT baru
--   b. Tolak SALE jika stok jadi minus
-- ============================================================
CREATE OR REPLACE FUNCTION trg_update_stock_and_journal()
RETURNS TRIGGER AS $$
DECLARE
    current_stock INT;
BEGIN
    -- Ambil stok & KUNCI baris (anti race condition)
    SELECT stock_qty INTO current_stock
    FROM inventory_items
    WHERE item_id = NEW.item_id
    FOR UPDATE;

    -- SALE: kurangi stok, tolak jika minus
    IF NEW.trx_type = 'SALE' THEN
        IF current_stock - NEW.qty < 0 THEN
            RAISE EXCEPTION 
                'Stok tidak cukup untuk item %! Stok tersisa: %, diminta: %',
                NEW.item_id, current_stock, NEW.qty;
        END IF;

        UPDATE inventory_items
        SET stock_qty = stock_qty - NEW.qty
        WHERE item_id = NEW.item_id;

    -- PURCHASE: tambah stok
    ELSIF NEW.trx_type = 'PURCHASE' THEN
        UPDATE inventory_items
        SET stock_qty = stock_qty + NEW.qty
        WHERE item_id = NEW.item_id;

    -- ADJUSTMENT: koreksi (qty bisa +/-)
    ELSIF NEW.trx_type = 'ADJUSTMENT' THEN
        IF current_stock + NEW.qty < 0 THEN
            RAISE EXCEPTION 
                'Adjustment menyebabkan stok minus! Stok: %, adjustment: %',
                current_stock, NEW.qty;
        END IF;

        UPDATE inventory_items
        SET stock_qty = stock_qty + NEW.qty
        WHERE item_id = NEW.item_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 2. PASANG TRIGGER
-- ============================================================
CREATE TRIGGER trigger_inventory
AFTER INSERT ON inventory_transactions
FOR EACH ROW
EXECUTE FUNCTION trg_update_stock_and_journal();

-- ============================================================
-- 3. DATA UJI COBA
-- ============================================================
INSERT INTO inventory_items VALUES ('BRG01', 'Kertas A4', 10, 5000);
INSERT INTO inventory_transactions (item_id, trx_type, qty) 
VALUES ('BRG01', 'PURCHASE', 20);
INSERT INTO inventory_transactions (item_id, trx_type, qty) 
VALUES ('BRG01', 'SALE', 5);

-- Cek stok (harus 25 = 10 + 20 - 5)
-- SELECT * FROM inventory_items WHERE item_id = 'BRG01';

-- Test anti-minus (harus ERROR)
-- INSERT INTO inventory_transactions (item_id, trx_type, qty) 
-- VALUES ('BRG01', 'SALE', 100);