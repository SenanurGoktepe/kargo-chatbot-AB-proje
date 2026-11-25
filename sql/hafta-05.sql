
-- ============================================================
-- HAFTA 5: ANALITIK SORGULAR VE VERI DEGERLENDIRMESI
-- Proje: Kargo Chatbot
-- Veritabani: PostgreSQL
-- ============================================================


-- 1. USLUBA GORE SIKAYET SAYISI VE TEKRAR ACILMA ORANI

WITH reopening_status AS (
    SELECT
        c.id AS complaint_id,
        BOOL_OR(ro.reopened_at > c.opened_at) AS is_reopened
    FROM complaints c
    LEFT JOIN reopenings ro
        ON c.id = ro.complaint_id
    GROUP BY c.id
)
SELECT
    LOWER(TRIM(r.tone)) AS tone,
    COUNT(DISTINCT c.id) AS total_complaints,
    COUNT(DISTINCT CASE
        WHEN rs.is_reopened THEN c.id
    END) AS reopened_complaints,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN rs.is_reopened THEN c.id
        END) * 100.0
        / NULLIF(COUNT(DISTINCT c.id), 0),
        2
    ) AS reopening_rate
FROM complaints c
JOIN responses r ON c.id = r.complaint_id
JOIN reopening_status rs ON c.id = rs.complaint_id
WHERE LOWER(TRIM(r.tone)) IN ('formal', 'friendly')
GROUP BY LOWER(TRIM(r.tone))
ORDER BY tone;


-- 2. TEKRAR ACILMA DURUMU BULUNMAYAN SIKAYETLER

WITH reopening_status AS (
    SELECT
        c.id AS complaint_id,
        BOOL_OR(ro.reopened_at > c.opened_at) AS is_reopened
    FROM complaints c
    LEFT JOIN reopenings ro
        ON c.id = ro.complaint_id
    GROUP BY c.id
)
SELECT
    COUNT(*) AS total_complaints,
    COUNT(*) FILTER (
        WHERE COALESCE(rs.is_reopened, FALSE) = FALSE
    ) AS not_reopened_complaints,
    ROUND(
        COUNT(*) FILTER (
            WHERE COALESCE(rs.is_reopened, FALSE) = FALSE
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS not_reopened_rate,
    COUNT(*) FILTER (
        WHERE rs.is_reopened = TRUE
    ) AS reopened_complaints
FROM complaints c
LEFT JOIN reopening_status rs
    ON c.id = rs.complaint_id;


-- 3. HER IKI TONDA EN AZ 40 SIKAYET BULUNAN KONULAR

SELECT
    c.topic,
    LOWER(TRIM(r.tone)) AS tone,
    COUNT(DISTINCT c.id) AS complaint_count
FROM complaints c
JOIN responses r
    ON c.id = r.complaint_id
WHERE LOWER(TRIM(r.tone)) IN ('formal', 'friendly')
GROUP BY
    c.topic,
    LOWER(TRIM(r.tone))
HAVING COUNT(DISTINCT c.id) >= 40
ORDER BY complaint_count DESC;


-- 4. YANIT SURELERININ SINIFLANDIRILMASI

SELECT
    LOWER(TRIM(tone)) AS tone,
    CASE
        WHEN response_time IS NULL THEN 'unknown'
        WHEN response_time < 60 THEN 'fast'
        WHEN response_time <= 300 THEN 'medium'
        ELSE 'slow'
    END AS response_speed,
    COUNT(*) AS response_count
FROM responses
WHERE LOWER(TRIM(tone)) IN ('formal', 'friendly')
GROUP BY
    LOWER(TRIM(tone)),
    response_speed
ORDER BY tone, response_speed;


-- 5. HAFTALIK TEKRAR ACILMA ORANI

WITH reopening_status AS (
    SELECT
        c.id AS complaint_id,
        BOOL_OR(ro.reopened_at > c.opened_at) AS is_reopened
    FROM complaints c
    LEFT JOIN reopenings ro
        ON c.id = ro.complaint_id
    GROUP BY c.id
)
SELECT
    DATE_TRUNC('week', c.opened_at) AS week,
    LOWER(TRIM(r.tone)) AS tone,
    COUNT(DISTINCT c.id) AS total_complaints,
    COUNT(DISTINCT CASE
        WHEN rs.is_reopened THEN c.id
    END) AS reopened_complaints,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN rs.is_reopened THEN c.id
        END) * 100.0
        / NULLIF(COUNT(DISTINCT c.id), 0),
        2
    ) AS weekly_reopening_rate
FROM complaints c
JOIN responses r
    ON c.id = r.complaint_id
JOIN reopening_status rs
    ON c.id = rs.complaint_id
WHERE
    LOWER(TRIM(r.tone)) IN ('formal', 'friendly')
    AND c.opened_at IS NOT NULL
GROUP BY
    DATE_TRUNC('week', c.opened_at),
    LOWER(TRIM(r.tone))
ORDER BY week DESC, tone;


-- 6. VERI BUTUNLUGU KONTROLU

SELECT
    (SELECT COUNT(*) FROM complaints) AS total_complaints,
    (SELECT COUNT(*) FROM responses) AS total_responses,
    (SELECT COUNT(*) FROM reopenings) AS total_reopenings,
    (SELECT COUNT(DISTINCT complaint_id) FROM reopenings)
        AS complaints_with_followups,
    (SELECT COUNT(*) FROM responses
        WHERE tone = 'unknown') AS unclassified_responses;


-- ============================================================
-- DEGERLENDIRME
--
-- Bu analizde formal ve friendly olarak siniflandirilan
-- yanitlar karsilastirilmistir.
--
-- Unknown kayitlar ton karsilastirmasina dahil edilmemistir.
--
-- Kaynak veri gercek bir randomize A/B testi degildir.
-- Bu nedenle sonuclar nedensel etkiyi kanitlamaz.
--
-- Yeniden acilma gostergesi, ilk yanittan sonra gelen
-- takip mesajlarina dayali bir yaklasik olcumdur.
--
-- ============================================================
-- HAFTA 5 SONU
-- ============================================================