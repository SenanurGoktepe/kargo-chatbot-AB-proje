import csv
import re
from collections import Counter

dosya_yolu = "data/raw/twcs.csv"

kelime_deseni = re.compile(
    r"\b(deliver\w*|late|delay\w*|parcel\w*|package\w*|return\w*|refund\w*)\b",
    re.IGNORECASE
)

musteri_toplam = 0
musteri_uygun = 0
sirket_uygun = 0
sirket_hesaplari = Counter()

with open(dosya_yolu, "r", encoding="utf-8", newline="") as dosya:
    okuyucu = csv.DictReader(dosya)

    for kayit in okuyucu:
        mesaj = kayit["text"] or ""

        if kayit["inbound"] == "True":
            musteri_toplam += 1

            if kelime_deseni.search(mesaj):
                musteri_uygun += 1
        else:
            sirket_hesaplari[kayit["author_id"]] += 1

            if kelime_deseni.search(mesaj):
                sirket_uygun += 1

print("Toplam müşteri mesajı:", musteri_toplam)
print("Teslimat/iade kelimesi içeren müşteri mesajı:", musteri_uygun)
print("Aynı konulardaki şirket mesajı:", sirket_uygun)

print("\nEn çok mesaj gönderen 20 şirket hesabı:")

for hesap, sayi in sirket_hesaplari.most_common(20):
    print(hesap, ":", sayi)