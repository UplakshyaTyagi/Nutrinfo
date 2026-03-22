import pytest
from app.services.intelligence_engine import (
    compute_rda,
    deterministic_score,
    generate_insights,
    ml_smooth,
    map_category,
    analyze_product
)
from app.services.dietary_validator import (
    detect_veg_status,
    check_dietary_conflict,
    extract_hidden_additives,
    validate_diet
)

# --- Intelligence Engine Tests ---

def test_compute_rda():
    sugar, sodium = compute_rda(10.0, 1000.0)
    assert sugar == 20.0  # 10/50 * 100
    assert sodium == 50.0  # 1000/2000 * 100

def test_deterministic_score():
    features_healthy = {"sugars": 2, "sodium": 100, "nova_group": 1, "fiber": 5, "protein": 8}
    assert deterministic_score(features_healthy) == 7.5  # 5 + 1.5 + 1.0
    
    features_unhealthy = {"sugars": 25, "sodium": 900, "nova_group": 4, "fiber": 0, "protein": 1}
    assert deterministic_score(features_unhealthy) == 0.0  # 5 - 1.5 - 2.0 - 1.5 = 0

def test_generate_insights():
    features = {"sodium": 700, "sugars": 15, "nova_group": 4, "fiber": 4, "protein": 6}
    tips = generate_insights(features, 30.0, 35.0)
    assert len(tips) == 5
    assert "Very high sodium content" in tips[0]
    assert "High sugar content" in tips[1]
    assert "NOVA Group 4" in tips[2]

def test_map_category():
    assert map_category(9.0) == "Super Healthy"
    assert map_category(7.5) == "Healthy"
    assert map_category(5.5) == "Eatable"
    assert map_category(4.0) == "Unhealthy"
    assert map_category(2.0) == "Super Unhealthy"

def test_analyze_product():
    # Full pipeline test
    features = {
        "energy_kcal": 200, "sugars": 5, "sat_fat": 1, "sodium": 200, 
        "fiber": 2, "protein": 3, "nova_group": 3
    }
    result = analyze_product(features)
    assert "final_score" in result
    assert "health_category" in result
    assert "insights" in result
    
    
# --- Dietary Validator Tests ---

def test_detect_veg_status():
    assert detect_veg_status("wheat, salt, sugar, spices", ["en:gluten"]) is True
    assert detect_veg_status("wheat, chicken flavor, salt", []) is False
    assert detect_veg_status("milk solids, sugar", ["en:milk"]) is True # milk is dairy, but technically veg in India
    assert detect_veg_status("sugar, gelatin", []) is False

def test_check_dietary_conflict():
    # Vegan conflict
    conflict, msg = check_dietary_conflict("milk powder", True, "Vegan", 2.0)
    assert conflict is True
    assert "milk" in msg
    
    # Keto conflict
    conflict, msg = check_dietary_conflict("almond flour", True, "Keto", 15.0)
    assert conflict is True
    assert "sugar" in msg

def test_extract_hidden_additives():
    ocr = "Ingredients: Sugar, E102, Water, E621 (Flavour)."
    additives = extract_hidden_additives(ocr)
    assert "Tartrazine (Artificial Colour)" in additives
    assert "MSG (Flavour Enhancer)" in additives
