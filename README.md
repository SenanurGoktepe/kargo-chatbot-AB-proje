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

