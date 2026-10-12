-- ============================================================
-- SOAL 1.2 : DDL PostgreSQL - General Ledger Module
-- Nama : Fania Hidayatul Mustafidah
-- NIM  : 12030124130178
-- Prodi: S1 Akuntansi Reguler
-- UTS  : Pemrograman / Coding Gasal 2026/2027
-- ============================================================

-- ============================================================
-- 1. Tabel Chart of Accounts (Daftar Akun)
-- ============================================================
CREATE TABLE chart_of_accounts (
    account_id      SERIAL PRIMARY KEY,
    account_code    VARCHAR(20) UNIQUE NOT NULL,
    account_name    VARCHAR(100) NOT NULL,
    normal_balance  VARCHAR(6) NOT NULL
                    CHECK (normal_balance IN ('DEBIT','CREDIT')),
    report_class    VARCHAR(20) NOT NULL
                    CHECK (report_class IN
                        ('ASET','LIABILITAS','EKUITAS','PENDAPATAN','BEBAN'))
);

-- ============================================================
-- 2. Tabel Journal Headers (Header Jurnal)
-- ============================================================
CREATE TABLE journal_headers (
    header_id       SERIAL PRIMARY KEY,
    trx_date        DATE NOT NULL,
    reference_no    VARCHAR(50) UNIQUE NOT NULL,
    description     TEXT,
    status_posting  VARCHAR(10) NOT NULL DEFAULT 'DRAFT'
                    CHECK (status_posting IN ('DRAFT','POSTED','VOID'))
);

-- ============================================================
-- 3. Tabel Journal Lines (Baris Jurnal)
-- ============================================================
CREATE TABLE journal_lines (
    line_id     SERIAL PRIMARY KEY,
    header_id   INT NOT NULL,
    account_id  INT NOT NULL,
    debit       NUMERIC(15,2) NOT NULL DEFAULT 0
                CHECK (debit  >= 0),
    credit      NUMERIC(15,2) NOT NULL DEFAULT 0
                CHECK (credit >= 0),

    CONSTRAINT fk_header
        FOREIGN KEY (header_id)
        REFERENCES journal_headers(header_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_account
        FOREIGN KEY (account_id)
        REFERENCES chart_of_accounts(account_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_not_both_zero
        CHECK (debit > 0 OR credit > 0)
);

-- ============================================================
-- DATA UJI COBA
-- ============================================================
INSERT INTO chart_of_accounts (account_code, account_name, normal_balance, report_class)
VALUES 
  ('101','Kas','DEBIT','ASET'),
  ('102','Piutang Usaha','DEBIT','ASET'),
  ('401','Pendapatan Jasa','CREDIT','PENDAPATAN'),
  ('501','Beban Gaji','DEBIT','BEBAN');

INSERT INTO journal_headers (trx_date, reference_no, description, status_posting)
VALUES ('2026-10-19','JV-001','Penerimaan kas dari pelanggan','DRAFT');

INSERT INTO journal_lines (header_id, account_id, debit, credit)
VALUES 
  (1, 1, 500000, 0),
  (1, 3, 0, 500000);

-- ============================================================
-- TEST CONSTRAINT (harus ERROR, bukti constraint bekerja)
-- ============================================================
-- Test 1: debit & credit dua-duanya nol -> HARUS ERROR
-- INSERT INTO journal_lines (header_id, account_id, debit, credit)
-- VALUES (1, 1, 0, 0);

-- Test 2: hapus header yang masih punya lines -> HARUS ERROR
-- DELETE FROM journal_headers WHERE header_id = 1;