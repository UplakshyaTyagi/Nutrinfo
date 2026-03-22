# Nutrinfo

> **Premium AI-Driven Food Intelligence — Scan. Know. Choose Better.**

## Monorepo Structure

```
nutrinfo/
├── nutrinfo_app/        Flutter mobile application
├── nutrinfo_api/        FastAPI intelligence backend
└── ui_references/       Stitch HTML/CSS mockups (source of UI truth)
    └── stitch_html/
```

## Quick Start

### Backend
```bash
cd nutrinfo_api
python -m venv .venv && .venv\Scripts\activate   # Windows
pip install -r requirements.txt
cp .env.example .env                              # fill in your secrets
alembic upgrade head
uvicorn app.main:app --reload
```

### Frontend
```bash
cd nutrinfo_app
flutter pub get
flutter run
```

## Intelligence Pipeline
1. **Deterministic Baseline** — hard-coded nutrition math on Open Food Facts data
2. **Rule-Based Insights** — FSSAI-calibrated %RDA tips ("48% of daily sodium limit")
3. **ML Smoothing** — pre-trained Random Forest erases threshold cliffs → 1.0–10.0 score
4. **Category Mapping** — Super Unhealthy / Unhealthy / Eatable / Healthy / Super Healthy

## Tech Stack
| Layer | Technology |
|---|---|
| Frontend | Flutter (Riverpod + GoRouter) |
| Backend | Python 3.11+, async FastAPI |
| Database | SQLite → aiosqlite (UUID PKs) |
| ORM / Migrations | SQLAlchemy 2.0 + Alembic |
| ML | scikit-learn Random Forest + joblib |
| Vision | Google Cloud Vision API |
| Auth | Firebase Auth JWT |
| Nutrition Data | Open Food Facts API |
