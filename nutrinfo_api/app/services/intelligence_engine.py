"""Intelligence Engine: The 4-step ML health scoring pipeline."""
import os
from typing import TypedDict

import joblib
import pandas as pd

from app.core.config import get_settings

settings = get_settings()

MODEL_PATH = os.path.join(os.path.dirname(__file__), "ml", "random_forest.pkl")

# Load model globally so it's cached in memory
try:
    rf_model = joblib.load(MODEL_PATH)
except FileNotFoundError:
    rf_model = None  # Will fail gracefully if model isn't there yet


class AnalysisResult(TypedDict):
    final_score: float
    health_category: str
    insights: list[str]
    sugar_rda_pct: float
    sodium_rda_pct: float


def compute_rda(sugars_g: float, sodium_mg: float) -> tuple[float, float]:
    """Calculate FSSAI 2026 %RDA. Sugar limit: 50g, Sodium limit: 2000mg."""
    sugar_rda = round((sugars_g / 50.0) * 100, 1) if sugars_g else 0.0
    sodium_rda = round((sodium_mg / 2000.0) * 100, 1) if sodium_mg else 0.0
    return sugar_rda, sodium_rda


def deterministic_score(features: dict) -> float:
    """
    Step 1: Hard-coded penalties and rewards.
    Base score starts at 5.0.
    """
    score = 5.0
    
    # Penalties
    if features.get("sugars", 0) > 10:
        score -= 1.5
    if features.get("sodium", 0) > 600:
        score -= 2.0
    if features.get("nova_group", 0) == 4:
        score -= 1.5
        
    # Rewards
    if features.get("fiber", 0) > 3:
        score += 1.5
    if features.get("protein", 0) > 5:
        score += 1.0
        
    # Clamp between 0.0 and 10.0
    return max(0.0, min(10.0, score))


def generate_insights(features: dict, sugar_rda: float, sodium_rda: float) -> list[str]:
    """Step 2: Pure rule-based text tips."""
    tips = []
    
    if features.get("sodium", 0) > 600:
        tips.append(f"Very high sodium content ({sodium_rda}% of daily FSSAI limit) — limit frequent intake.")
    elif sodium_rda > 20:
        tips.append(f"Moderate sodium ({sodium_rda}% of daily limit).")
        
    if features.get("sugars", 0) > 10:
        tips.append(f"High sugar content ({sugar_rda}% of daily FSSAI limit) — monitor intake.")
        
    if features.get("nova_group", 0) == 4:
        tips.append("NOVA Group 4 (ultra-processed) — minimal whole-food ingredients.")
    elif features.get("nova_group", 0) == 1:
        tips.append("NOVA Group 1 — unprocessed or minimally processed food, excellent choice.")
        
    if features.get("fiber", 0) > 3:
        tips.append("Good source of dietary fiber — supports digestion.")
    elif features.get("fiber", 0) < 1:
        tips.append("Low in dietary fiber — consider pairing with whole vegetables.")
        
    if features.get("protein", 0) > 5:
        tips.append("Good protein content — helps with satiety.")
        
    if not tips:
        tips.append("Standard nutritional profile. Consume in moderation.")
        
    return tips[:5]  # Max 5 tips


def ml_smooth(features: dict, raw_score: float) -> float:
    """Step 3: Random Forest smoothing."""
    if rf_model is None:
        return raw_score  # Fallback to deterministic if no model

    # The ML model expects exactly these 8 features based on training definition
    input_data = pd.DataFrame([{
        "sugars_100g": features.get("sugars", 0),
        "sat_fat_100g": features.get("sat_fat", 0),
        "sodium_mg_100g": features.get("sodium", 0),
        "fiber_100g": features.get("fiber", 0),
        "protein_100g": features.get("protein", 0),
        "calories_100g": features.get("energy_kcal", 0),
    }])
    
    prediction = rf_model.predict(input_data)[0]
    return float(max(1.0, min(10.0, prediction)))


def map_category(score: float) -> str:
    """Step 4: Deterministic 5-tier mapping."""
    if score >= 8.5: return "Super Healthy"
    if score >= 7.0: return "Healthy"
    if score >= 5.0: return "Eatable"
    if score >= 3.0: return "Unhealthy"
    return "Super Unhealthy"


def analyze_product(cleaned_nutrients: dict) -> AnalysisResult:
    """
    Master pipeline executor. 
    `cleaned_nutrients` must have keys: energy_kcal, sugars, sat_fat, sodium, fiber, protein, nova_group.
    """
    # 1. Math
    raw_score = deterministic_score(cleaned_nutrients)
    
    # 2. FSSAI RDA & Insights
    sugar_rda, sodium_rda = compute_rda(
        sugars_g=cleaned_nutrients.get("sugars", 0.0), 
        sodium_mg=cleaned_nutrients.get("sodium", 0.0)
    )
    insights = generate_insights(cleaned_nutrients, sugar_rda, sodium_rda)
    
    # 3. Model
    final_score = ml_smooth(cleaned_nutrients, raw_score)
    final_score = round(final_score, 1)
    
    # 4. Map
    category = map_category(final_score)
    
    return {
        "final_score": final_score,
        "health_category": category,
        "insights": insights,
        "sugar_rda_pct": sugar_rda,
        "sodium_rda_pct": sodium_rda
    }
