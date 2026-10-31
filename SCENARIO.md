# Kura #25 – Lojistik ve Teslimat Sohbet Asistanı

## 1. Proje Hikâyesi

Bir kargo şirketinin müşteri hizmetleri sohbet asistanı, müşterilerden gelen iade ve geç teslimat şikâyetlerini yanıtlamaktadır. Şirket, müşterilere verilen yanıtların üslubunun müşteri memnuniyetini etkileyebileceğini düşünmektedir.

Bu nedenle ekip, iki farklı yanıt üslubunu karşılaştırmak istemektedir:

- Formal: Resmî ve kurumsal yanıt üslubu.
- Friendly: Samimi ve daha sıcak yanıt üslubu.

Projenin amacı, hangi yanıt üslubunun şikâyetlerin tekrar açılma oranını daha fazla azaltabileceğini araştırmaktır.

## 2. Ana Araştırma Sorusu

Hangi yanıt üslubu (resmî veya samimi), müşteri şikâyetlerinin tekrar açılma oranını daha fazla azaltmaktadır?

## 3. Hedef Kullanıcılar

- Kargo şirketlerinin müşteri hizmetleri ekipleri.
- Müşteri deneyimi ve memnuniyeti yöneticileri.
- Sohbet asistanı geliştiren yazılım ekipleri.
- Prompt tasarımı ve A/B testi yapan ekipler.

## 4. Tablo Adayları

### complaints
Müşterilerin oluşturduğu şikâyet bilgilerini tutar.

- id
- topic
- opened_at

### responses
Şikâyetlere verilen yanıtları tutar.

- id
- complaint_id
- tone
- response_time

### reopenings
Tekrar açılan şikâyetlerin bilgilerini tutar.

- id
- complaint_id
- reopened_at

Bu tablolar proje kapsamında değerlendirilmesi planlanan mantıksal tablo adaylarıdır.

## 5. Veri Kaynağı Adayları

**Birincil aday: Kaggle – Customer Support on Twitter**

https://www.kaggle.com/datasets/thoughtvector/customer-support-on-twitter

Bu veri seti müşteriler ile şirketlerin müşteri destek hesapları arasındaki gerçek yazışmaları içermektedir.

Veri setinde bulunan temel sütunlar:

- tweet_id
- author_id
- inbound
- created_at
- text
- response_tweet_id
- in_response_to_tweet_id

Veri setinin teslimat ve iade şikâyetleri açısından uygunluğu incelenecektir.

**Alternatif kaynaklar:**

- Hugging Face: customer complaints, customer support, conversations.
- Kaggle: customer support tickets, delivery complaints.

Veri seçiminde en az 500 satır, en az 4 sayısal sütun ve en az 1 tarih/zaman sütunu şartları dikkate alınacaktır.

## 6. Veride Beklenen Sorunlar

- Üslup değerlerinin farklı biçimlerde yazılması (formal, Formal, frml).
- Eksik tarih ve yanıt bilgileri.
- Tarih formatlarının standartlaştırılması ihtiyacı.
- Türkçe ve İngilizce metinlerin birlikte bulunması.
- Aynı konuşmaya ait mesajların birbirleriyle ilişkilendirilmesi.
- Resmî şikâyet yeniden açılma bilgisinin veri kaynağında bulunmaması.

Gerçek A/B deney grubu ve prompt sürümü bilgileri mevcut kaynakta bulunmamaktadır. Bu nedenle bu bilgiler varmış gibi gösterilmeyecektir.

Müşterinin şirket yanıtından sonra yeniden mesaj göndermesi, resmî şikâyetin yeniden açılmasıyla aynı şey değildir. Kaynak bu ayrımı yapmaya izin vermediği takdirde tekrar iletişim ölçümü bir gösterge olarak kullanılacak ve sonuçlar buna göre yorumlanacaktır.

## 7. Yapay Zekâ Bileşeni

Projenin dönem sonu aşamasında sohbet asistanının iki farklı yanıt üslubunu karşılaştıran bir A/B test sistemi tasarlanacaktır.

Bu sistemde:

- Kullanıcıların deney gruplarına atanması,
- Kullanılan prompt sürümünün kaydedilmesi,
- Verilen yanıtların izlenmesi,
- Şikâyetin tekrar açılma veya tekrar iletişim durumunun ölçülmesi

amaçlanmaktadır.

YZ bileşeninin veritabanında uygulanması vize kapsamında değildir.

## 8. Sonuçların Değerlendirilmesi

Tekrar açılma oranının yüksek veya düşük olması doğrudan yanıt kalitesini göstermeyebilir. Şikâyetin tekrar açılması, sorunun çözülüp çözülmemesiyle de ilişkili olabilir.

Bu nedenle elde edilen sonuçlar değerlendirilirken müşteri hizmetlerinin yanıt üslubu ile problemin çözülmesi arasındaki fark dikkate alınacaktır.