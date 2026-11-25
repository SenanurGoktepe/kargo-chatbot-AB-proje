
import csv
import os
import re
from datetime import datetime

BASE = os.path.dirname(os.path.abspath(__file__))
RAW_FILE = os.path.join(BASE, "data", "raw", "twcs.csv")
OUTPUT_DIR = os.path.join(BASE, "data", "cleaned")

os.makedirs(OUTPUT_DIR, exist_ok=True)

COMPLAINTS_FILE = os.path.join(OUTPUT_DIR, "complaints.csv")
RESPONSES_FILE = os.path.join(OUTPUT_DIR, "responses.csv")
REOPENINGS_FILE = os.path.join(OUTPUT_DIR, "reopenings.csv")


def is_inbound(value):
    return str(value).strip().lower() == "true"


def parse_date(value):
    if not value:
        return None

    try:
        return datetime.strptime(
            value.strip(),
            "%a %b %d %H:%M:%S %z %Y"
        )
    except (ValueError, TypeError):
        return None


def classify_topic(text):
    text = (text or "").lower()

    if re.search(r"\b(return|refund|exchange|money back)\b", text):
        return "return"

    if re.search(r"\b(late|delay|delayed|overdue)\b", text):
        return "late_delivery"

    if re.search(
        r"\b(delivery|deliver|package|parcel|shipment|shipping)\b",
        text
    ):
        return "delivery"

    return None


def classify_tone(text):
    text = (text or "").lower()

    formal_words = [
        "dear",
        "regards",
        "sincerely",
        "apologize",
        "thank you for contacting",
        "please accept"
    ]

    friendly_words = [
        "hey",
        "hi",
        "thanks",
        "sorry",
        "we're",
        "you're",
        "let's",
        "happy to help"
    ]

    formal_score = sum(word in text for word in formal_words)
    friendly_score = sum(word in text for word in friendly_words)

    if formal_score > friendly_score and formal_score > 0:
        return "formal"

    if friendly_score > formal_score and friendly_score > 0:
        return "friendly"

    return "unknown"


def main():
    if not os.path.exists(RAW_FILE):
        print("HATA: Kaynak dosya bulunamadi:")
        print(RAW_FILE)
        return

    print("Kaynak CSV bulundu.")
    print("Veriler isleniyor...")

    complaints = {}

    # 1. Sikayetleri bul
    with open(RAW_FILE, "r", encoding="utf-8", newline="") as file:
        reader = csv.DictReader(file)

        for row in reader:
            if not is_inbound(row.get("inbound")):
                continue

            topic = classify_topic(row.get("text", ""))
            if topic is None:
                continue

            tweet_id = row.get("tweet_id", "").strip()
            created_at = parse_date(row.get("created_at", ""))

            if not tweet_id or created_at is None:
                continue

            complaints[tweet_id] = {
                "id": tweet_id,
                "topic": topic,
                "opened_at": created_at.isoformat()
            }

    print("Bulunan sikayet:", len(complaints))

    # 2. Sikayetlere verilen ilk yanitlari bul
    responses = {}

    with open(RAW_FILE, "r", encoding="utf-8", newline="") as file:
        reader = csv.DictReader(file)

        for row in reader:
            if is_inbound(row.get("inbound")):
                continue

            complaint_id = (
                row.get("in_response_to_tweet_id") or ""
            ).strip()

            if complaint_id not in complaints:
                continue

            response_id = (row.get("tweet_id") or "").strip()
            response_date = parse_date(row.get("created_at", ""))

            if not response_id or response_date is None:
                continue

            complaint_date = datetime.fromisoformat(
                complaints[complaint_id]["opened_at"]
            )

            if response_date < complaint_date:
                continue

            if complaint_id not in responses:
                response_seconds = (
                    response_date - complaint_date
                ).total_seconds()

                responses[complaint_id] = {
                    "id": response_id,
                    "complaint_id": complaint_id,
                    "tone": classify_tone(row.get("text", "")),
                    "response_time": round(response_seconds, 2)
                }

    print("Bulunan ilk yanit:", len(responses))

    # 3. CSV dosyalarini yaz
    with open(
        COMPLAINTS_FILE, "w", encoding="utf-8-sig", newline=""
    ) as file:
        writer = csv.DictWriter(
            file,
            fieldnames=["id", "topic", "opened_at"]
        )
        writer.writeheader()
        writer.writerows(complaints.values())

    with open(
        RESPONSES_FILE, "w", encoding="utf-8-sig", newline=""
    ) as file:
        writer = csv.DictWriter(
            file,
            fieldnames=[
                "id",
                "complaint_id",
                "tone",
                "response_time"
            ]
        )
        writer.writeheader()
        writer.writerows(responses.values())

    # 4. Ilk yanitlara gelen musteri takip mesajlarini bul
    response_to_complaint = {
        response["id"]: complaint_id
        for complaint_id, response in responses.items()
    }

    reopenings = []

    with open(RAW_FILE, "r", encoding="utf-8", newline="") as file:
        reader = csv.DictReader(file)

        for row in reader:
            if not is_inbound(row.get("inbound")):
                continue

            parent_id = (
                row.get("in_response_to_tweet_id") or ""
            ).strip()

            if parent_id not in response_to_complaint:
                continue

            reopened_date = parse_date(row.get("created_at", ""))
            tweet_id = (row.get("tweet_id") or "").strip()

            if reopened_date is None or not tweet_id:
                continue

            reopenings.append({
                "id": tweet_id,
                "complaint_id": response_to_complaint[parent_id],
                "reopened_at": reopened_date.isoformat()
            })

    with open(
        REOPENINGS_FILE, "w", encoding="utf-8-sig", newline=""
    ) as file:
        writer = csv.DictWriter(
            file,
            fieldnames=["id", "complaint_id", "reopened_at"]
        )
        writer.writeheader()
        writer.writerows(reopenings)

    # 5. Sonuclari goster
    tone_counts = {
        "formal": 0,
        "friendly": 0,
        "unknown": 0
    }

    for response in responses.values():
        tone_counts[response["tone"]] += 1

    print("\n===== ISLEM TAMAMLANDI =====")
    print("Sikayet sayisi:", len(complaints))
    print("Yanit sayisi:", len(responses))
    print("Formal yanit:", tone_counts["formal"])
    print("Friendly yanit:", tone_counts["friendly"])
    print("Siniflandirilmayan yanit:", tone_counts["unknown"])
    print("Takip mesaji:", len(reopenings))

    print("\nOlusturulan dosyalar:")
    print(COMPLAINTS_FILE)
    print(RESPONSES_FILE)
    print(REOPENINGS_FILE)


if __name__ == "__main__":
    main()
