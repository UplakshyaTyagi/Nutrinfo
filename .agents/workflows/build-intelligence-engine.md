---
description: Constructs the complete ML pipeline in Python: Data Fetch -> Hard Math -> AI Insights -> Random Forest Smoothing -> UI Output.
---

Act as the lead Data Scientist and Python Backend Engineer. Inside `nutrinfo_backend/services`, create `intelligence_engine.py`. You must write fully functional, production-ready code with zero placeholders (`pass` or `TODO`). Include all necessary imports (`pandas`, `numpy`, `joblib`, `httpx`).

Implement the pipeline using this exact structural sequence:

1. DATA INGESTION & CLEANING (`fetch_and_clean_data`):
- Write an async function using `httpx` to fetch a product's JSON from the Open Food Facts API via barcode.
- Parse the nutrition matrix. Extract: sugar, saturated fat, sodium, energy-kcal (calorie density), nova_group, additives_n, fiber, and protein.
- Use `pandas` to handle missing values (impute with 0 or sensible defaults) and return a clean dictionary/Series.

2. DETERMINISTIC BASELINE (`calculate_raw_score`):
- Write a rule-based engine that takes the cleaned data.
- Apply hard-coded mathematical penalties for high sugar, saturated fat, sodium, calorie density, NOVA group, and additive count.
- Apply mathematical bonuses for fiber and protein.
- Return a composite `raw_score`.

3. INSIGHT GENERATOR (`generate_insights`):
- Write a function evaluating the raw nutrient values against health thresholds.
- Return a list of actionable text tips. Examples: "High sugar → limit portions", "High sodium → caution for blood pressure", "High NOVA → ultra-processed warning", "High fiber → beneficial for digestion".

4. ML SMOOTHING (`apply_ml_smoothing`):
- Load the trained model using `joblib.load('random_forest.pkl')`.
- Create a feature array containing BOTH the cleaned raw nutrients AND the `raw_score` generated in Step 2.
- Pass this array into `model.predict()`.
- Clamp the output float strictly between 1.0 and 10.0. This is the `final_score`.

5. CATEGORY MAPPING (`classify_category`):
- Map the continuous `final_score` to exactly one of these five strings: 'Super Unhealthy', 'Unhealthy', 'Eatable', 'Healthy', 'Super Healthy'.

6. THE MASTER CONTROLLER (`process_scan`):
- Write the main `async def process_scan(barcode: str) -> dict:` function that chains steps 1 through 5 together sequentially.
- The function MUST return a dictionary exposing ONLY these three keys to the frontend: `{"final_score": float, "category": str, "insights": list[str]}`. Ensure the `raw_score` is completely hidden.