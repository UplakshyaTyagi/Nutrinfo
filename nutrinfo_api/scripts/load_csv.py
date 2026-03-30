"""
Load and deduplicate the CSV product database into SQLite.

Usage:
    python -m scripts.load_csv
"""
import csv
import sqlite3
import os
import sys

CSV_PATH = os.path.join(os.path.dirname(__file__), "..", "..", "processed_data_with_names.csv")
DB_PATH = os.path.join(os.path.dirname(__file__), "..", "nutrinfo.db")


def health_category(score: float) -> str:
    if score >= 8.5:
        return "Super Healthy"
    elif score >= 6.5:
        return "Healthy"
    elif score >= 4.5:
        return "Eatable"
    elif score >= 2.5:
        return "Unhealthy"
    else:
        return "Super Unhealthy"


def main():
    csv_path = os.path.abspath(CSV_PATH)
    db_path = os.path.abspath(DB_PATH)

    print(f"CSV:  {csv_path}")
    print(f"DB:   {db_path}")

    if not os.path.exists(csv_path):
        print("ERROR: CSV file not found!")
        sys.exit(1)

    # Delete old DB if exists
    if os.path.exists(db_path):
        os.remove(db_path)
        print("Deleted old database.")

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    # Create table
    cur.execute("""
        CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            product_name TEXT NOT NULL,
            sugars_100g REAL DEFAULT 0,
            sat_fat_100g REAL DEFAULT 0,
            sodium_mg_100g REAL DEFAULT 0,
            fiber_100g REAL DEFAULT 0,
            protein_100g REAL DEFAULT 0,
            calories_100g REAL DEFAULT 0,
            nova_group INTEGER DEFAULT 0,
            additives_n INTEGER DEFAULT 0,
            health_score REAL DEFAULT 5.0
        )
    """)

    # Create indexes
    cur.execute("CREATE INDEX ix_products_name ON products(product_name)")
    cur.execute("CREATE INDEX ix_products_name_lower ON products(LOWER(product_name))")

    print("Reading CSV...")
    total_rows = 0
    skipped_unknown = 0
    skipped_empty = 0
    seen_names = set()
    skipped_dupes = 0
    batch = []
    BATCH_SIZE = 10000

    with open(csv_path, "r", encoding="utf-8", errors="replace") as f:
        reader = csv.DictReader(f)
        for row in reader:
            total_rows += 1

            if total_rows % 500000 == 0:
                print(f"  Processed {total_rows:,} rows...")

            name = row.get("product_name", "").strip()

            # Skip unknowns
            if not name or name.lower() == "unknown product":
                skipped_unknown += 1
                continue

            # Parse numeric fields safely
            try:
                sugars = float(row.get("sugars_100g", 0) or 0)
                sat_fat = float(row.get("sat_fat_100g", 0) or 0)
                sodium = float(row.get("sodium_mg_100g", 0) or 0)
                fiber = float(row.get("fiber_100g", 0) or 0)
                protein = float(row.get("protein_100g", 0) or 0)
                calories = float(row.get("calories_100g", 0) or 0)
                nova = int(float(row.get("nova_group", 0) or 0))
                additives = int(float(row.get("additives_n", 0) or 0))
                score = float(row.get("health_score", 5.0) or 5.0)
            except (ValueError, TypeError):
                skipped_empty += 1
                continue

            # Skip all-zero rows (no real nutrition data)
            if sugars == 0 and sat_fat == 0 and sodium == 0 and fiber == 0 and protein == 0 and calories == 0 and score == 10:
                skipped_empty += 1
                continue

            # Deduplicate by lowercase name
            name_key = name.lower()
            if name_key in seen_names:
                skipped_dupes += 1
                continue
            seen_names.add(name_key)

            batch.append((
                name, sugars, sat_fat, sodium, fiber, protein,
                calories, nova, additives, score,
            ))

            if len(batch) >= BATCH_SIZE:
                cur.executemany(
                    "INSERT INTO products (product_name, sugars_100g, sat_fat_100g, sodium_mg_100g, fiber_100g, protein_100g, calories_100g, nova_group, additives_n, health_score) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                    batch,
                )
                conn.commit()
                batch.clear()

    # Insert remaining
    if batch:
        cur.executemany(
            "INSERT INTO products (product_name, sugars_100g, sat_fat_100g, sodium_mg_100g, fiber_100g, protein_100g, calories_100g, nova_group, additives_n, health_score) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            batch,
        )
        conn.commit()

    # Get final count
    cur.execute("SELECT COUNT(*) FROM products")
    final_count = cur.fetchone()[0]

    # Get DB file size
    conn.close()
    db_size_mb = os.path.getsize(db_path) / (1024 * 1024)

    print("\n" + "=" * 50)
    print(f"CSV total rows:      {total_rows:,}")
    print(f"Skipped (unknown):   {skipped_unknown:,}")
    print(f"Skipped (empty/0s):  {skipped_empty:,}")
    print(f"Skipped (dupes):     {skipped_dupes:,}")
    print(f"Final products in DB: {final_count:,}")
    print(f"Database size:       {db_size_mb:.1f} MB")
    print("=" * 50)
    print("Done!")


if __name__ == "__main__":
    main()
