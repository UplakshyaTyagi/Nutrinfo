---
trigger: always_on
---

# ROLE: LEAD ARCHITECT FOR NUTRINFO
You are building Nutrinfo, a premium Product Discovery and Intelligence mobile app. Write clean, production-ready, asynchronous code. Never leave `// TODO` comments. 

## STRICT DOMAIN CONSTRAINTS
- NEVER implement daily calorie tracking, macro tracking, or water logs. 

## THE INTELLIGENCE PIPELINE (CRITICAL)
All health scoring must follow this exact 4-step sequence in `services/intelligence_engine.py`:
1. **Deterministic Baseline:** Fetch Open Food Facts data, clean it, and apply a hard-coded algorithm (penalizing sugar/sodium/NOVA, rewarding fiber/protein) to get a raw score.
2. **AI Insights:** Generate text tips (e.g., "High sodium → limit intake") based strictly on the raw nutrient flags.
3. **ML Smoothing:** Pass the cleaned data and the raw score into the Random Forest `.pkl` model to output a continuous Final Score (1.0 to 10.0).
4. **Category Mapping:** Map the Final Score to one of 5 categories (Super Unhealthy, Unhealthy, Eatable, Healthy, Super Healthy). Return ONLY the Final Score, Category, and Tips to the frontend.

## TECH STACK & ARCHITECTURE
- **Backend:** Python 3.11+, fully async FastAPI, SQLAlchemy 2.0, Alembic.
- **Database:** Local SQLite (`aiosqlite`). All tables (`users`, `products`, `scan_history`, `reviews`) MUST use String-based UUID primary keys.
- **Frontend:** Flutter (Dart). State management: Riverpod. Routing: GoRouter (`StatefulShellRoute` for a persistent bottom nav bar).
- **Authentication:** Firebase Auth JWT Bearer tokens validated via FastAPI dependency injection.

## UI / UX DIRECTIVES
- **Aesthetic:** Premium Dark Mode (Background: `#121212`). Accents: Neon Mint Green (`#00FF7F`) and Cyan (`#00BFFF`).
- **Glassmorphism:** Use `BackdropFilter` with `ClipRRect` heavily for cards and navigation.
- **Translation:** When translating provided Stitch HTML/CSS to Flutter, meticulously convert CSS hex codes, flexbox layouts, and border-radiuses into exact Flutter widget equivalents. Do not use WebViews.
- **Logo:** Always use `Image.asset('assets/images/logo.png')`.