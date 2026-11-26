# Ödev Raporu

**Ödev no:** Ödev 02 | **Hafta:** 7 | **Tarih:** 26 / 11 / 2026

**Ad Soyad:** Senanur Göktepe | **Öğrenci No:** 202607131024

**Program:** ☑ Yapay Zeka Operatörlüğü ☐ Robotik ve Yapay Zeka

**Kullandığım veritabanı:** ☐ llm_ops ☑ robot_fleet

**PR bağlantısı:** https://github.com/SenanurGoktepe/kargo-chatbot-AB-proje/pull/2

**Commit sayısı:** 7

---

### 1. Fan-out
4. soruda görevi olan robotların toplam batarya seviyesi `JOIN` kullanılmadan hesaplandığında **262** iken, `robots` ve `missions` tabloları birleştirilip (`INNER JOIN`) `SUM()` alındığında satır çoğalması (*fan-out*) nedeniyle **700**'e çıkmıştır. Bire-çok (`1-N`) birleşmede her robot sahip olduğu görev sayısı kadar satır ürettiği için batarya değerleri şu şekilde mükerrer toplanmıştır: **Atlas-01** (82) **3 kez**, **Kartal-01** (18) **3 kez**, **Kartal-03** (91) **3 kez**, **Mars-01** (47) **2 kez**, **Mars-02** (9) **2 kez** ve **Atlas-02** (15) **1 kez** sayılmıştır (görevi olmayan 4, 7, 9 ve 10 numaralı robotlar eşleşmediği için toplama girmemiştir). Gerçek bir raporda bu hata, çok işlem yapan birimlerin kapasite, stok veya bütçe gibi tekil varlık değerlerinin yapay biçimde şişmesine ve hatalı maliyet ya da kaynak planlaması kararları alınmasına yol açar.

### 2. En Zor Karar
Kargo Chatbot A/B Testi projemin ERD tasarımında üzerinde en çok düşündüğüm tek karar, yanıt üslubu (`tone`) ve şablon açıklamasını `RESPONSES` tablosunda tutmak yerine **`PROMPT_VERSIONS`** adında ayrı bir tabloya bölüp `1-N` ilişkiyle bağlamak oldu. Seçenekler arasında vize taslağındaki gibi `RESPONSES` tablosunun içinde doğrudan metin olarak `tone` sütunu tutmak ile sürüm bazlı ayrı bir referans tablosu oluşturmak arasında kaldım. Her yanıt kaydında aynı üslup ve prompt açıklaması bilgisinin tekrarlanmasının 3NF kuralına aykırı (geçişli bağımlılık) olması ve ileride yeni prompt sürümleri eklendiğinde güncelleme anomalisi yaratacak olması nedeniyle ayrı tablo yapısını seçtim.

---

### 5. Yapay Zeka Kullanım Beyanı
☐ Bu ödevde yapay zeka aracı kullanmadım.

☑ Kullandım, aşağıda belirttim:

| Soru no | Araç | Ne sordum (özet) | Cevabı nasıl doğruladım |
| :--- | :--- | :--- | :--- |
| Bölüm 1 (Soru 1-5) | Gemini | `LEFT JOIN` ile eşleşmeyen kayıtların filtrelenmesi, `COUNT(*)` vs `COUNT(sütun)` farkı ve `SUM` fan-out tuzağının mantığını sordum. | `robot_fleet.sql` içindeki `INSERT` verilerinden tüm robotların görev sayılarını ve batarya değerlerini tek tek sayıp çarparak 262 ve 700 sonuçlarını doğruladım. |
| Bölüm 2 (ERD & Markdown) | Gemini | Kargo projemdeki üslup tekrarını 3NF'ye göre nasıl ayıracağımı ve Mermaid ERD diyagramı sözdizimini sordum; diyagram kod bloğunu (` ``` `) kapatmayı unuttuğum için aldığım sözdizimi hatasını çözdüm. | Kapanış işaretini ekledikten sonra GitHub önizleme ekranında tüm tabloların ve kardinalite çizgilerinin hatasız çizildiğini kontrol ederek doğruladım. |

---

### 6. Öz Değerlendirme

| Ölçüt | 4 Tam | 3 İyi | 2 Gelişmeli | 1 Yetersiz |
| :--- | :---: | :---: | :---: | :---: |
| A, Doğruluk | ☐ | ☑ | ☐ | ☐ |
| B, SQL kalitesi | ☐ | ☑ | ☐ | ☐ |
| C, Yorum ve analiz | ☐ | ☑ | ☐ | ☐ |
| D, Git ve PR disiplini | ☐ | ☑ | ☐ | ☐ |
| E, Dürüstlük ve beyan | ☑ | ☐ | ☐ | ☐ |

**Bir dahaki ödevde daha iyi yapacağım şey:** Veritabanı şemasını tasarlarken tekrar eden metin alanlarını (`tone`, şablon açıklaması gibi) sonradan fark etmek yerine başlangıçta 3NF kurallarına göre ayrı tablolara ayırmak ve `LEFT JOIN` ile `INNER JOIN` seçimlerini veri kaybı riskine göre sorgu öncesinde netleştirmek.
---
