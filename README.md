# Kargo Chatbot A/B Test Projesi

## Öğrenci Bilgileri

- **Ad Soyad:** Senanur Göktepe
- **Öğrenci Numarası:** 202607131024
- **Kura:** #25 – YZO
- **Proje Konusu:** Logistics & Delivery × Chatbot Assistant × Prompt Versioning & A/B Tests

## Proje Hakkında

Bu projede, bir kargo şirketinin müşteri hizmetleri sohbet asistanında kullanılan iki farklı yanıt üslubu karşılaştırılmaktadır.

Karşılaştırılacak yanıt üslupları:

- **Formal:** Resmî ve kurumsal yanıt üslubu.
- **Friendly:** Samimi ve sıcak yanıt üslubu.

Projenin temel amacı, hangi yanıt üslubunun müşteri şikâyetlerinin tekrar açılma oranını daha fazla azaltabileceğini araştırmaktır.

**Ana Araştırma Sorusu:** Hangi yanıt üslubu müşteri şikâyetlerinin tekrar açılmasını daha fazla azaltmaktadır?

## Kullanılan Veri Kaynağı

- **Kaynak:** Kaggle – Customer Support on Twitter
- **Bağlantı:** https://www.kaggle.com/datasets/thoughtvector/customer-support-on-twitter
- **Dosya:** twcs.csv

Veri seti müşteri ve şirketler arasındaki gerçek destek yazışmalarını içermektedir. Veri kaynağının proje senaryosuna uygunluğu ve veri kalitesi incelenmektedir.

## Çalıştırma Adımları

1. GitHub deposunu bilgisayara indirin.
2. Kaggle üzerinden belirtilen veri setini indirin.
3. Ham veri dosyasını `data/raw/` klasörüne yerleştirin.
4. PostgreSQL ortamında veri setini yükleyin.
5. İlk SELECT sorgularını çalıştırarak verileri kontrol edin.
6. Hafta 5 analiz sorgularını `sql/hafta-05.sql` dosyasından çalıştırın.
