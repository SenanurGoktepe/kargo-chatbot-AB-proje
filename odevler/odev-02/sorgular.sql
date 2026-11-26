-- Ödev 2, Bölüm 1: Filo soruları
-- Ad Soyad:Senanur Göktepe
-- Veritabanı: robot_fleet
-- Her sorgunun altına sonucu açıklayan tek cümlelik yorum yaz.

-- Soru 1: Her robotun adı, operatör adı ve operatör telefonu (INNER JOIN)
Select r.name AS robot_adi, o.operator_name AS operator_adi, o.phone AS telefon 
From robots r
INNER JOIN operators o ON r.operator_name = o.operator_name;


-- Yorum:9 satır döndü çünkü operator_name değeri NULL olan Mars-03 robotu operators tablosunda eşleşme bulamadığı için INNER JOIN tarafından elendi.


-- Soru 2: Aynı liste, bütün robotlar görünsün (LEFT JOIN). 1. sorguyla karşılaştır, kim kayboldu?
SELECT r.name AS robot_adi, o.operator_name AS operator_adi, o.phone AS telefon
FROM robots r
LEFT JOIN operators o ON r.operator_name = o.operator_name;

-- Yorum:10 satır döndü ve 1. sorguda kaybolan Mars-03 robotu operatör adı ve telefonu NULL olarak listeye dahil oldu.


-- Soru 3: Hiç görev almamış robotların adı ve modeli
SELECT  r.name AS robot_adi, r.model
FROM robots r
LEFT JOIN missions m ON r.id = m.robot_id
WHERE m.id IS NULL;

-- Yorum:4 satır döndü çünkü missions tablosunda kaydı bulunmayan Kartal-02, Atlas-03, Mars-03 ve Kartal-04 robotları LEFT JOIN ve IS NULL filtresiyle bulundu.
   

-- Soru 4a: JOIN ile hesaplanan toplam batarya (görevi olan robotlar)
SELECT SUM(r.battery_level) AS yanlis_toplam_batarya
FROM robots r
INNER JOIN missions m ON r.id =m.robot_id;
-- Soru 4b: JOIN kullanmadan doğru toplam
SELECT SUM(battery_level) AS dogru_toplam_batarya
FROM robots
WHERE id IN (SELECT DISTINCT robot_id FROM missions);

-- Yorum (iki sonuç ve fark):4a'daki JOIN birden fazla görevi olan robotların satırlarını görev sayısı kadar çoğalttığı (fan-out) için toplam batarya 262 yerine 700 olarak yanlış hesaplandı.


-- Soru 5: Robot başına görev sayısı; count(*) ve count(m.id) yan yana
SELECT r.id, r.name AS robot_adi, COUNT(*) AS count_yildiz, COUNT(m.id) AS count_mission_id
FROM robots r
LEFT JOIN missions m ON r.id = m.robot_id
GROUP BY r.id, r.name
ORDER BY r.id;

-- Yorum (hangi robotlarda ikisi farklı?):Hiç görevi olmayan Kartal-02 (4), Atlas-03 (7), Mars-03 (9) ve Kartal-04 (10) robotlarında COUNT(*) NULL satırı sayıp 1 döndürürken COUNT(m.id) doğru değer olan 0'ı döndürdü.
