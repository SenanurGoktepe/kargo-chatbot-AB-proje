# Kura #25 – YZO
## Lojistik ve Teslimat × Sohbet Asistanı × Prompt Sürümleme ve A/B Testleri

### 1. Proje Hikâyesi

Bir kargo şirketinin müşteri hizmetleri sohbet asistanı, müşterilerden gelen iade ve geç teslimat şikâyetlerini yanıtlamaktadır.

Şirketin müşteri hizmetleri ekibi, iki farklı yanıt üslubunun müşteri deneyimine etkisini karşılaştırmak istemektedir.

Karşılaştırılacak yanıt üslupları:

- **Formal:** Resmî ve kurumsal yanıt üslubu.
- **Friendly:** Samimi ve sıcak yanıt üslubu.

Projenin amacı, hangi yanıt üslubunun şikâyetlerin tekrar açılma oranını daha fazla azaltabileceğini araştırmaktır.

### 2. Ana Araştırma Sorusu

Hangi yanıt üslubu (resmî veya samimi), müşteri şikâyetlerinin tekrar açılma oranını daha fazla azaltmaktadır?

### 3. Hedef Kullanıcılar

- Kargo şirketlerinin müşteri hizmetleri ekipleri.
- Müşteri deneyimi yöneticileri.
- Sohbet asistanı geliştiren yazılım ekipleri.
- Prompt tasarımı ve A/B testi yapan ekipler.

### 4. Tablo Adayları

**complaints**

Müşteri şikâyetlerine ait bilgileri tutması planlanan tablo.

- id
- topic
- opened_at

**responses**

Şikâyetlere verilen yanıt bilgilerini tutması planlanan tablo.

- id
- complaint_id
- tone
- response_time

**reopenings**

Tekrar açılma bilgilerini tutması planlanan tablo.

- id
- complaint_id
- reopened_at

Bu tablolar, proje senaryosunda belirlenen mantıksal tablo adaylarıdır.

### 5. Veri Kaynağı

**Birincil veri kaynağı: Kaggle – Customer Support on Twitter**

https://www.kaggle.com/datasets/thoughtvector/customer-support-on-twitter

Veri seti, müşteriler ile şirketlerin müşteri destek hesapları arasındaki gerçek yazışmaları içermektedir.

İncelenen ham veri dosyası `twcs.csv` olup 2.811.774 satır ve 7 sütundan oluşmaktadır.

Temel sütunlar:

- tweet_id
- author_id
- inbound
- created_at
- text
- response_tweet_id
- in_response_to_tweet_id

Veri setinin teslimat, gecikme, iade ve müşteri destek konularına uygunluğu incelenmektedir.

### 6. Beklenen Veri Sorunları

- Eksik yanıt bağlantıları.
- Farklı tarih ve saat bilgilerinin standartlaştırılması ihtiyacı.
- Mesajların müşteri veya şirket tarafından gönderildiğinin ayrıştırılması.
- Mesaj içeriklerinin farklı dillerde olması.
- Üslup değerlerinin farklı biçimlerde sınıflandırılması (formal, Formal, frml).
- Şikâyetlerin tekrar açılma bilgisinin doğrudan bulunmaması.

Veri kaynağında resmî A/B deney grubu ve prompt sürümü bilgileri bulunmamaktadır. Benzer şekilde, resmî şikâyet yeniden açılma kaydı da doğrudan yer almamaktadır.

Şirket yanıtından sonra müşterinin yeniden mesaj göndermesi, resmî şikâyetin tekrar açılmasıyla aynı durum değildir. Bu nedenle böyle bir ölçüm kullanılırsa tekrar iletişim göstergesi olarak değerlendirilecek ve bu sınırlama sonuç yorumlarında belirtilecektir.

### 7. Yapay Zekâ Bileşeni

Projenin dönem sonu aşamasında sohbet asistanının iki farklı yanıt üslubunu karşılaştıran bir A/B test sistemi tasarlanacaktır.

Bu sistemde:

- Kullanıcıların deney gruplarına atanması,
- Kullanılan prompt sürümlerinin kaydedilmesi,
- Asistan yanıtlarının izlenmesi,
- Şikâyetlerin tekrar açılma durumunun ölçülmesi

amaçlanmaktadır.

Yapay zekâ bileşeninin veritabanında uygulanması vize kapsamında değildir.

### 8. Sonuçların Değerlendirilmesi

Şikâyetin tekrar açılması yalnızca yanıt kalitesiyle ilişkili değildir. Sorunun gerçekten çözülüp çözülmemesi de bu sonucu etkileyebilir.

Bu nedenle resmî ve samimi yanıt üslupları karşılaştırılırken bu ayrım dikkate alınacaktır. Gözlemsel verilerden elde edilen sonuçlar, gerçek bir kontrollü A/B deneyinin kanıtı olarak sunulmayacaktır.
