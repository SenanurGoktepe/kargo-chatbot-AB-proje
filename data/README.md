# Veri Kartı – Twitter Customer Support Dataset

## 1. Veri Setinin Kimliği

- **Veri setinin adı:** Twitter Customer Support Dataset (TWCS)
- **Kaynak:** Kaggle – Customer Support on Twitter
- **Bağlantı:** https://www.kaggle.com/datasets/thoughtvector/customer-support-on-twitter
- **Orijinal dosya:** `twcs.csv`
- **Yerel dosya yolu:** `data/raw/twcs.csv`

## 2. Veri Setinin Boyutu

- **Toplam kayıt:** 2.811.774
- **Sütun sayısı:** 7
- **Dosya boyutu:** 516.508.641 bayt (yaklaşık 492,6 MiB)
- **Kayıt türü:** Müşteri ve şirketler arasındaki Twitter destek mesajları.

## 3. Veri Setindeki Sütunlar

| Sütun | Açıklama |
|---|---|
| `tweet_id` | Mesajın benzersiz kimliği. |
| `author_id` | Mesajı gönderen hesabın kimliği. |
| `inbound` | Mesajın müşteriden gelen veya şirket tarafından gönderilen mesaj olduğunu belirtir. |
| `created_at` | Mesajın oluşturulma tarihi ve saati. |
| `text` | Mesajın metin içeriği. |
| `response_tweet_id` | Mesaja verilen yanıtın kimliğini belirtir. |
| `in_response_to_tweet_id` | Mesajın yanıt olarak gönderildiği önceki mesajın kimliğini belirtir. |

## 4. Projede Kullanım Amacı

Bu veri seti, müşteri destek yazışmalarını incelemek ve teslimat, kargo, gecikme ve iade gibi konularla ilişkili mesajları belirlemek amacıyla kullanılmaktadır.

Projenin temel araştırma konusu, müşteri hizmetleri sohbet asistanında kullanılan resmî (formal) ve samimi (friendly) yanıt üsluplarının şikâyetlerin tekrar açılmasıyla ilişkisini incelemektir.

## 5. Veri Kalitesi ve Beklenen Sorunlar

Veri hazırlama sürecinde aşağıdaki konular dikkate alınacaktır:

- Mesaj metinlerinde teslimat, gecikme, kargo ve iade konularına ilişkin farklı ifadeler bulunabilir.
- Mesajlar arasındaki yanıt ilişkileri incelenirken eksik veya kopuk bağlantılarla karşılaşılabilir.
- Tarih alanlarının biçimi ve kronolojik sıralaması kontrol edilmelidir.
- Konu sınıflandırmasında aynı konuyu ifade eden farklı kelimeler bulunabilir.

## 6. Veri Setinin Sınırlılıkları

TWCS veri setinde doğrudan aşağıdaki bilgiler bulunmamaktadır:

- Yanıtın resmî veya samimi olduğunu gösteren bir `tone` sütunu.
- Şikâyetin tekrar açıldığı tarihi gösteren bir `reopened_at` sütunu.
- Gerçek A/B deneyinde kullanıcıların hangi gruba atandığını gösteren bir deney grubu bilgisi.

Mesajlar arasındaki yanıt bağlantıları tek başına bir şikâyetin tekrar açıldığını kanıtlamaz. Bu nedenle bu alanlar, veri setinde doğrudan gözlemlenmiş gerçek bilgiler gibi kabul edilmeyecektir.

Projenin analiz yönteminde kullanılacak sınıflandırmalar ve varsayımlar ayrıca açıklanacaktır. Gerçek bir A/B testi gerçekleştirilmediği sürece sonuçlar nedensel deney sonucu olarak yorumlanmayacaktır.

## 7. Ham Verinin Korunması

Orijinal `twcs.csv` dosyası değiştirilmeden `data/raw/` klasöründe saklanmaktadır.

Dosya boyutu nedeniyle GitHub deposuna yüklenmemiştir. Projeyi çalıştırmak isteyen kullanıcı, veri setini belirtilen Kaggle kaynağından indirerek `data/raw/twcs.csv` konumuna yerleştirmelidir.

## 8. Veri Ön İncelemesi ve Filtreleme

Ham veri üzerinde yapılan ön incelemede toplam 2.811.774 kayıt bulunduğu doğrulanmıştır.

Mesajların müşteri veya şirket tarafından gönderildiği `inbound` sütunu kullanılarak ayrıştırılmaktadır.

Teslimat, gecikme, kargo, paket, iade ve geri ödeme konularıyla ilişkili mesajları belirlemek için mesaj metinlerinde anahtar kelime tabanlı arama yapılmıştır.

Ön inceleme sonucunda:
- Toplam müşteri mesajı: 1.537.843
- Teslimat ve iade anahtar kelimelerini içeren müşteri mesajı: 130.963
- Aynı konularla ilişkili şirket mesajı: 85.151

Bu sayılar ön inceleme sonuçlarıdır; temizlenmiş veri setindeki nihai kayıt sayısını göstermez.

## 9. Üslup Sınıflandırması

Ham veri setinde mesajların resmî veya samimi olduğunu belirten hazır bir sütun bulunmamaktadır.

Proje kapsamında böyle bir sınıflandırma yapılması durumunda mesaj metinleri üzerinden sezgisel kurallar kullanılacaktır.

Sınıflandırma sonuçları aşağıdaki aday kategorilerle ifade edilecektir:
- `formal_candidate`
- `friendly_candidate`
- `mixed`
- `neutral_unclassified`

Bu kategoriler doğrulanmış müşteri deneyimi veya gerçek deney grubu bilgisi değildir. Otomatik sınıflandırma sonuçlarıdır ve analizlerde bu sınırlama dikkate alınacaktır.