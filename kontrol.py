import csv

dosya_yolu = "data/raw/twcs.csv"

toplam = 0

with open(dosya_yolu, "r", encoding="utf-8", newline="") as dosya:
    okuyucu = csv.DictReader(dosya)

    print("Sütunlar:", okuyucu.fieldnames)

    for kayit in okuyucu:
        toplam += 1

print("Toplam kayıt:", toplam)


# KONTROL.PY - HAM VERİ İNCELEME DOSYASI
# ======================================
#
# Bu dosyanın amacı Kaggle üzerinden indirdiğimiz
# twcs.csv dosyasını incelemek ve temel veri bilgilerini
# elde etmektir.
#
# Yaptığı işlemler:
#
# 1. CSV dosyasını açar ve okur.
# 2. Dosyanın sütun isimlerini gösterir.
# 3. CSV içerisindeki toplam kayıt sayısını hesaplar.
# 4. Ham veri üzerinde herhangi bir değişiklik yapmaz.
#
# Veri seti:
# Kaynak: Kaggle - Customer Support on Twitter
# Dosya: data/raw/twcs.csv

# =====================================================


import csv

# CSV dosyasının bulunduğu konumu belirler.
dosya_yolu = "data/raw/twcs.csv"

# Toplam kayıt sayısını tutmak için başlangıç değeri.
toplam = 0

# CSV dosyasını okuma modunda açar.
# encoding="utf-8": Türkçe ve diğer karakterlerin
# doğru okunmasına yardımcı olur.
# newline="": CSV satırlarının doğru okunmasını sağlar.
with open(dosya_yolu, "r", encoding="utf-8", newline="") as dosya:

    # CSV dosyasını sözlük biçiminde okumamızı sağlar.
    okuyucu = csv.DictReader(dosya)

    # Dosyadaki sütun isimlerini ekrana yazdırır.
    print("Sütunlar:", okuyucu.fieldnames)

    # Dosyadaki her kaydı tek tek dolaşır.
    for kayit in okuyucu:

        # Her kayıt için sayacı bir artırır.
        toplam += 1

# Toplam kayıt sayısını ekrana yazdırır.
print("Toplam kayıt:", toplam)