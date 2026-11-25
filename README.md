# Kargo Chatbot A/B Test Projesi

## Öğrenci Bilgileri
- **Ad Soyad:** Senanur Göktepe
- **Öğrenci Numarası:** 202607131024
- **Kura:** #25 – YZO
- **Proje Konusu:** Lojistik ve Teslimat × Sohbet Asistanı × Prompt Sürümleme ve A/B Testleri

## Proje Hakkında
Bu projede, bir kargo şirketinin müşteri hizmetleri sohbet asistanının iade ve geç teslimat şikâyetlerine verdiği yanıtlar incelenmektedir.

İki farklı yanıt üslubu karşılaştırılacaktır:
- **Formal:** Resmî ve kurumsal yanıt üslubu.
- **Friendly:** Samimi ve sıcak yanıt üslubu.

Projenin amacı, hangi yanıt üslubunun müşteri şikâyetlerinin tekrar açılma oranını daha fazla azaltabileceğini araştırmaktır.

**Ana araştırma sorusu:** Hangi yanıt üslubu şikâyetlerin tekrar açılmasını daha fazla azaltmaktadır?

## Kullanılan Veri Kaynağı
- **Veri seti:** Twitter Customer Support Dataset (TWCS)
- **Kaynak:** Kaggle – Customer Support on Twitter
- **Bağlantı:** https://www.kaggle.com/datasets/thoughtvector/customer-support-on-twitter
- **Ham dosya:** `data/raw/twcs.csv`

Veri seti, müşteriler ve şirketler arasındaki destek yazışmalarını içermektedir.

**Veri sınırlılığı:** TWCS veri setinde doğrudan A/B deney grubu ataması, yanıt üslubu ve şikâyetin tekrar açılma tarihi alanları bulunmamaktadır. Bu nedenle veri hazırlama aşamasında oluşturulabilecek sınıflandırmalar ve ölçüm yaklaşımları ayrıca açıklanacaktır. Veri setinden elde edilmeyen bilgiler gerçek deney sonucu olarak sunulmayacaktır.

## Proje Dosyaları
- `README.md`: Proje ve öğrenci bilgileri.
- `SCENARIO.md`: Kura sonucu ve senaryo kartı.
- `AI_BEYAN.md`: Yapay zekâ kullanım beyanı.
- `data/raw/`: Değiştirilmemiş ham veri seti.
- `data/README.md`: Veri kartı ve kaynak bilgileri.
- `sql/hafta-05.sql`: Beş analiz sorgusu.
- `odevler/odev-02/sorgular.sql`: Ödev 2 filo SQL sorguları ve yorumları.
- `odevler/odev-02/rapor.md`: Ödev 2 değerlendirme raporu.
- `kontrol.py`: Ham veri setinin kayıt sayısını kontrol eder.
- `konu_kontrol.py`: Teslimat ve iade konularını inceler.

## Çalıştırma Adımları
1. GitHub deposunu bilgisayarınıza indirin.
2. Kaggle bağlantısından TWCS veri setini indirin.
3. `twcs.csv` dosyasını `data/raw/` klasörüne yerleştirin.
4. Proje klasöründe PowerShell açın.
5. Veri setini kontrol etmek için `py kontrol.py` komutunu çalıştırın.
6. Teslimat ve iade konularını incelemek için `py konu_kontrol.py` komutunu çalıştırın.
7. Hazırlanan verileri PostgreSQL veri tabanına aktarın.
8. `sql/hafta-05.sql` dosyasındaki analiz sorgularını PostgreSQL ortamında çalıştırın.

---

## Veri Modeli

### Güncel ERD

```mermaid
erDiagram
    COMPLAINTS ||--o{ RESPONSES : "yanitlanir"
    PROMPT_VERSIONS ||--o{ RESPONSES : "kullanilir"
    COMPLAINTS ||--o| REOPENINGS : "tekrar_acilir"

    COMPLAINTS {
        bigint id PK
        varchar source_tweet_id
        varchar customer_id
        varchar topic
        timestamp opened_at
    }

    PROMPT_VERSIONS {
        int id PK
        varchar version_code
        varchar tone
        text description
    }

    RESPONSES {
        bigint id PK
        bigint complaint_id FK
        int prompt_version_id FK
        int response_time_sec
        timestamp responded_at
    }

    REOPENINGS {
        bigint id PK
        bigint complaint_id FK
        timestamp reopened_at
        varchar reason
    }

**İlişki Açıklamaları:**
* Bir şikâyet (`COMPLAINTS`), sıfır veya çok sayıda asistan yanıtına (`RESPONSES`) sahip olabilir; bir yanıt, tam olarak bir şikâyete aittir.
* Bir prompt sürümü (`PROMPT_VERSIONS`), sıfır veya çok sayıda yanıtta (`RESPONSES`) kullanılabilir; bir yanıt, tam olarak bir prompt sürümüne aittir.
* Bir şikâyet (`COMPLAINTS`), sıfır veya en fazla bir tekrar açılma kaydına (`REOPENINGS`) sahip olabilir; bir tekrar açılma kaydı, tam olarak bir şikâyete aittir.

### Normalizasyon Notu

| Tablo | Neden Ayrıldı / Ayrılmadı? (Bağımlılık) | Normal Form | Somut Örnek |
| :--- | :--- | :--- | :--- |
| **COMPLAINTS** | Her hücrede tek bir atomik değer tutulması ve tekrarlı mesaj listelerinin aynı satıra sıkıştırılmaması için tekil kayıt yapısında tutuldu (`id → source_tweet_id, customer_id, topic, opened_at`). | **1NF** | Bir müşterinin ardışık attığı mesajları tek sütunda virgülle ayırmak yerine her şikâyet kaydı ayrı satırda tek bir `topic` (örn. `geç teslimat`) ve tek bir `opened_at` zaman damgası tutar. |
| **RESPONSES** | Tüm sütunlar tekil birincil anahtar olan `id` değerine tam bağımlıdır; bileşik anahtar kullanılmadığı için kısmi bağımlılık oluşmaması adına ayrı varlık olarak korundu (`id → complaint_id, prompt_version_id, response_time_sec, responded_at`). | **2NF** | Yanıt süresi (`response_time_sec`) yalnızca yanıtın kendi `id` değerine bağlıdır; şikâyetin konusuna veya müşteriye kısmi bağımlılık göstermez. |
| **PROMPT_VERSIONS** | Üslup (`tone`) ve sürüm açıklaması (`description`) yanıtın kendisine değil, doğrudan kullanılan prompt sürümüne (`prompt_version_id → tone, description`) bağımlı olduğu için geçişli bağımlılığı önlemek amacıyla `RESPONSES` tablosundan ayrıldı. | **3NF** | `RESPONSES` tablosunda her satırda `"Formal - Resmî kurumsal şablon v1"` metnini tekrarlamak yerine yalnızca `prompt_version_id = 1` yabancı anahtarı tutulur. |

### İki JOIN Sorusu

1. **Soru 1 (Eşleşmeyen Kayıtlar — LEFT JOIN):**
   * **Türkçe Soru:** Sohbet asistanı tarafından yanıtlandığı hâlde müşteri tarafından hiç tekrar açılmayan (başarıyla kapanan) şikâyetlerin konusu ve açılma tarihi nedir?
   * **Birleşme Tabloları ve Sütunları:** `COMPLAINTS c` ile `REOPENINGS r` tabloları `c.id = r.complaint_id` üzerinden birleşir (ek olarak yanıtlanmış olanları süzmek için `RESPONSES res` ile `c.id = res.complaint_id`).
   * **JOIN Türü ve Nedeni:** `LEFT JOIN` (ve `WHERE r.id IS NULL`) kullanılır; çünkü `COMPLAINTS` tablosundaki tüm şikâyetleri koruyup `REOPENINGS` tablosunda karşılığı bulunmayan (hiç tekrar açılmamış) kayıtları yakalamak gerekir.

2. **Soru 2 (Eşleşen Kayıtlar — INNER JOIN):**
   * **Türkçe Soru:** Resmî (`Formal`) ve samimi (`Friendly`) yanıt üsluplarına göre verilen asistan yanıtlarının ortalama yanıtlanma süresi (saniye) kaçtır?
   * **Birleşme Tabloları ve Sütunları:** `RESPONSES res` ile `PROMPT_VERSIONS pv` tabloları `res.prompt_version_id = pv.id` üzerinden birleşir.
   * **JOIN Türü ve Nedeni:** `INNER JOIN` kullanılır; çünkü yalnızca geçerli bir prompt sürümü ve üslup etiketiyle eşleşen gerçek asistan yanıtlarının istatistiği hesaplanmak istenmektedir.
