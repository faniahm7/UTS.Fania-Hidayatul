# Soal 3.2 — Mekanisme Jejak Audit & Immutability

**Nama** : Fania Hidayatul Mustafidah  
**NIM**  : 12030124130178

---

## Spesifikasi Fungsi Backend — Lock Transaksi POSTED

### Konsep
Transaksi berstatus `POSTED` tidak boleh diubah (`UPDATE`) 
maupun dihapus (`DELETE`). Untuk koreksi, wajib melalui 
**jurnal pembalik** (reversing entry / storno).

### Implementasi Trigger PostgreSQL

```sql
CREATE OR REPLACE FUNCTION cegah_ubah_posted()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status_posting = 'POSTED' THEN
        RAISE EXCEPTION 
            'Transaksi POSTED tidak boleh diubah/dihapus! Buat jurnal pembalik.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER lock_posted
BEFORE UPDATE OR DELETE ON journal_headers
FOR EACH ROW EXECUTE FUNCTION cegah_ubah_posted();