
-- =========================================================================
-- HAFTA 5: ANALİTİK SORGULAR VE A/B TESTİ DEĞERLENDİRMESİ
-- Proje: Kargo Chatbot A/B Testi
-- Veritabanı: PostgreSQL
-- =========================================================================


-- 1. ÜSLUBA GÖRE ŞİKÂYET SAYISI VE TEKRAR AÇILMA ORANI
-- DISTINCT kullanılarak şikâyetler tekilleştirilmiştir.
-- İlk açılış tarihinden önceki tekrar açılmalar geçersiz sayılmıştır.

WITH valid_reopenings AS (
    SELECT
        c.id AS complaint_id,
        BOOL_OR(ro.reopened_at > c.opened_at) AS is_reopened
    FROM complaints c
    LEFT JOIN reopenings ro ON c.id = ro.complaint_id
    GROUP BY c.id
)
SELECT
    LOWER(TRIM(r.tone)) AS normalized_tone,
    COUNT(DISTINCT c.id) AS toplam_sikayet_sayisi,
    COUNT(DISTINCT CASE
        WHEN vr.is_reopened THEN c.id
    END) AS tekrar_acilan_sayisi,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN vr.is_reopened THEN c.id
        END) * 100.0
        / NULLIF(COUNT(DISTINCT c.id), 0),
        2
    ) AS tekrar_acilma_orani_yuzde
FROM complaints c
JOIN responses r ON c.id = r.complaint_id
JOIN valid_reopenings vr ON c.id = vr.complaint_id
WHERE r.tone IS NOT NULL
GROUP BY LOWER(TRIM(r.tone))
ORDER BY normalized_tone;

/*
YORUM (Soru 1):
Bu sorgu, resmî ve samimi yanıt üsluplarının tekrar açılma oranlarını
karşılaştırır. Tekrar açılma oranı daha düşük olan üslup, müşteri
şikâyetlerinin yeniden açılmasını önleme konusunda daha başarılı olabilir.
*/


-- 2. TEKRAR AÇILIŞ TARİHİ NULL OLAN ŞİKÂYETLERİN ORANI

WITH reopening_summary AS (
    SELECT
        complaint_id,
        COUNT(*) AS toplam_kayit,
        COUNT(reopened_at) AS tarihli_kayit,
        COUNT(*) FILTER (
            WHERE reopened_at <= c.opened_at
        ) AS gecersiz_kayit
    FROM reopenings ro
    JOIN complaints c ON c.id = ro.complaint_id
    GROUP BY complaint_id
)
SELECT
    COUNT(*) AS toplam_sikayet,
    COUNT(*) FILTER (
        WHERE rs.tarihli_kayit IS NULL
    ) AS tekrar_acilis_tarihi_null_sayisi,
    ROUND(
        COUNT(*) FILTER (
            WHERE rs.tarihli_kayit IS NULL
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS null_orani_yuzde,
    COALESCE(SUM(rs.gecersiz_kayit), 0) AS gecersiz_tarih_kaydi
FROM complaints c
LEFT JOIN reopening_summary rs ON c.id = rs.complaint_id;

/*
YORUM (Soru 2):
Tekrar açılma tarihi NULL olan kayıtlar, geçerli bir tekrar açılma
tarihi bulunmayan şikâyetleri gösterir. NULL oranının yüksek olması,
şikâyetlerin önemli bir bölümünün yeniden açılmadığına işaret edebilir.
Ancak bu durum tek başına chatbot başarısını kesin olarak kanıtlamaz.
*/


-- 3. HER ÜSLUPTA EN AZ 40 ŞİKÂYETİ OLAN KONULAR
-- HAVING kullanımı

SELECT
    c.topic,
    LOWER(TRIM(r.tone)) AS normalized_tone,
    COUNT(DISTINCT c.id) AS sikayet_sayisi
FROM complaints c
JOIN responses r ON c.id = r.complaint_id
WHERE r.tone IS NOT NULL
GROUP BY
    c.topic,
    LOWER(TRIM(r.tone))
HAVING COUNT(DISTINCT c.id) >= 40
ORDER BY sikayet_sayisi DESC;

/*
YORUM (Soru 3):
Bu sorgu, her üslup için en az 40 şikâyete sahip konuları belirler.
Böylece yeterli sayıda gözlem bulunan konular üzerinden üslup
performansının karşılaştırılması sağlanır.
*/


-- 4. YANIT SÜRELERİNİN FAST, MEDIUM VE SLOW OLARAK SINIFLANDIRILMASI
-- CASE WHEN kullanımı

SELECT
    LOWER(TRIM(r.tone)) AS normalized_tone,
    CASE
        WHEN r.response_time < 60 THEN 'fast'
        WHEN r.response_time BETWEEN 60 AND 300 THEN 'medium'
        WHEN r.response_time > 300 THEN 'slow'
        ELSE 'unknown'
    END AS response_speed_category,
    COUNT(*) AS adet
FROM responses r
WHERE r.tone IS NOT NULL
GROUP BY
    LOWER(TRIM(r.tone)),
    response_speed_category
ORDER BY
    normalized_tone,
    adet DESC;

/*
YORUM (Soru 4):
Yanıt süreleri 60 saniyenin altında fast, 60-300 saniye arasında
medium ve 300 saniyenin üzerinde slow olarak sınıflandırılmıştır.
Bu sonuçlar, iki farklı üslubun yanıt hızlarının karşılaştırılmasını
sağlar. Unknown kategorisi eksik veya geçersiz süreleri gösterir.
*/


-- 5. HAFTALIK TEKRAR AÇILMA ORANI
-- İki üslup için ayrı ayrı hesaplama
-- DATE_TRUNC kullanımı

WITH valid_reopenings AS (
    SELECT
        c.id AS complaint_id,
        BOOL_OR(ro.reopened_at > c.opened_at) AS is_reopened
    FROM complaints c
    LEFT JOIN reopenings ro ON c.id = ro.complaint_id
    GROUP BY c.id
)
SELECT
    DATE_TRUNC('week', c.opened_at) AS hafta,
    LOWER(TRIM(r.tone)) AS normalized_tone,
    COUNT(DISTINCT c.id) AS toplam_sikayet,
    COUNT(DISTINCT CASE
        WHEN vr.is_reopened THEN c.id
    END) AS tekrar_acilan,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN vr.is_reopened THEN c.id
        END) * 100.0
        / NULLIF(COUNT(DISTINCT c.id), 0),
        2
    ) AS haftalik_tekrar_acilma_orani
FROM complaints c
JOIN responses r ON c.id = r.complaint_id
JOIN valid_reopenings vr ON c.id = vr.complaint_id
WHERE
    r.tone IS NOT NULL
    AND c.opened_at IS NOT NULL
GROUP BY
    DATE_TRUNC('week', c.opened_at),
    LOWER(TRIM(r.tone))
ORDER BY
    hafta DESC,
    normalized_tone;

/*
YORUM (Soru 5):
Bu sorgu, haftalık bazda resmî ve samimi üslupların tekrar açılma
oranlarını karşılaştırır. Böylece zaman içerisinde üslupların
performansında meydana gelen değişimler gözlemlenebilir.
*/


-- =========================================================================
-- HAFTA 5 SONU
-- =========================================================================
