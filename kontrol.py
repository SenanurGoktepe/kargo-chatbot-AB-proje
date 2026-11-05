import csv

dosya_yolu = "data/raw/twcs.csv"

toplam = 0

with open(dosya_yolu, "r", encoding="utf-8", newline="") as dosya:
    okuyucu = csv.DictReader(dosya)

    print("Sütunlar:", okuyucu.fieldnames)

    for kayit in okuyucu:
        toplam += 1

print("Toplam kayıt:", toplam)