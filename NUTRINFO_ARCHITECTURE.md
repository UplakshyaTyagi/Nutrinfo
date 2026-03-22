Project Name: Nutrinfo
Type: Premium AI-Driven Mobile SaaS Application
Target Audience: Health-conscious consumers seeking rapid, continuous product intelligence.

1. CORE PHILOSOPHY & STRICT CONSTRAINTS
The Core Value: Nutrinfo is a high-speed product discovery and health intelligence tool. Users scan a product and immediately receive a 1.0–10.0 health score, category classification, and actionable dietary tips.

STRICT NEGATIVE CONSTRAINT: Nutrinfo DOES NOT track daily calories, macros, weight, or water intake. Do not write any code, database models, or UI elements related to daily dietary tracking or logging.

2. COMPREHENSIVE TECH STACK
Frontend (Mobile): Flutter (Dart) using Material 3 / Cupertino.

Frontend State & Routing: Riverpod (State Management), GoRouter (with StatefulShellRoute for persistent navigation).

Backend Framework: Python 3.11+, FastAPI (fully asynchronous).

Database (Phase 1): Local SQLite via aiosqlite.

ORM & Migrations: SQLAlchemy 2.0 (Async) and Alembic.

Authentication: Firebase Auth (Client-side) passing secure JWT Bearer tokens to FastAPI middleware.

Machine Learning: Scikit-Learn (Random Forest .pkl model), Pandas, NumPy.

External APIs: Google Cloud Vision API (OCR/Barcode extraction), Open Food Facts API (Nutritional Matrix).

3. THE INTELLIGENCE PIPELINE (CRITICAL SEQUENCE)
The backend scoring engine operates on a strict, four-step sequential pipeline to eliminate threshold cliffs and provide continuous data. This must be implemented in services/intelligence_engine.py:

The Hard Math (Deterministic Baseline): Fetch raw nutritional data from Open Food Facts. Clean it using Pandas. Apply a hard-coded, rule-based algorithm to evaluate penalties (High sugar, saturated fat, sodium, calorie density, NOVA group, additives) and bonuses (Fiber, Protein) to establish a raw baseline score.

AI Insight Generation:
Based strictly on the raw nutrient flags evaluated in Step 1, generate dynamic, actionable text tips (e.g., "High sodium → caution for blood pressure", "High NOVA → ultra-processed warning").

ML Smoothing (The Random Forest):
Pass both the cleaned nutrient array and the raw deterministic score into the pre-trained Random Forest model. The ML model erases unfair hard-cutoff cliffs (e.g., penalizing 5.01g but not 4.99g) and outputs a smoothed, continuous Final Score on a 1.0 to 10.0 scale.

Category Mapping & Response:
Map the continuous Final Score to one of five UI categories: Super Unhealthy, Unhealthy, Eatable, Healthy, Super Healthy. The API must return ONLY the Final Score, the Category, and the Insights to the frontend. The raw deterministic score remains completely hidden.

4. FRONTEND UI/UX ARCHITECTURE
The app must look like a multi-million-dollar premium SaaS product.

Aesthetic Theme: Luxurious Dark Mode. Backgrounds are deep textured charcoal (#121212), never pitch black.

Visual Effects: Heavy use of Glassmorphism (BackdropFilter blur) for all cards and containers.

Accents: Neon Mint Green (#00FF7F) and Cyan/Blue (#00BFFF). Typography is crisp white or muted silver.

Persistent Bottom Navigation: A frozen, non-reloading glassmorphism nav bar. Layout: Home (Grid) | History (Clock) | [Massive Floating Camera FAB] | Profile (Silhouette).

Splash Screen Logo: Do not generate or hallucinate graphics. Use an Image.asset('assets/images/logo.png') placeholder sized at 150x150 over the typography.

5. DATABASE SCHEMA (SQLAlchemy ORM)
All tables must use String-based UUIDs for primary keys to ensure smooth migration to PostgreSQL later.

users Table:

id (UUID, PK)

firebase_uid (String, Unique, Indexed)

email (String)

role (Enum: 'user', 'expert', 'admin')

dietary_focus (String - from onboarding)

products Table (The Central Cache):

id (UUID, PK)

barcode (String, Indexed)

product_name (String)

final_ml_score (Float)

health_category (String)

protein_g, carbs_g, fats_g, sodium_mg (Floats)

nova_group (Integer)

scan_history Table:

id (UUID, PK)

user_id (UUID, FK -> users.id)

product_id (UUID, FK -> products.id)

scanned_at (Timestamp)

reviews Table (Community Data):

id (UUID, PK)

user_id (UUID, FK -> users.id)

product_id (UUID, FK -> products.id)

review_text (Text)

status (Enum: 'pending', 'approved', 'rejected')

6. SCREEN INVENTORY & CORE FEATURES
Splash: screen used for loading of app.
Authentication: Email/Password, Apple, and Google SSO wrappers.

Onboarding Wizard: Collects dietary_focus (e.g., Keto, Vegan) via interactive pills.

Dashboard (Home): Features a "Trending Healthy Swap" card (e.g., Cereal 3.2 -> Oats 9.2) and a horizontal carousel of Recent Scans. Large search bar at the top.

AI Vision Scanner: Camera viewfinder with an animated AR bounding box. Uploads image to FastAPI.

Results Page: Displays the massive 1.0-10.0 decimal score via an animated semi-circle gauge. Shows AI Insights card and expandable macro rows.

Community/Expert Reviews: A bottom sheet on the Results page showing user reviews. "Verified Expert" reviews feature a gold border and shield icon.

Scan History: A chronological ledger grouped by date ("Today", "Yesterday").

Pro Settings: Account preferences, dark mode toggles, and Pro tier upgrade logic.