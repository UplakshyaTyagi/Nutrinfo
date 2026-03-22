"""Dietary Validator: Veg/Non-Veg, Allergens, Dietary Conflicts, and Hidden Additives."""
import re
from typing import TypedDict, Optional

NON_VEG_MARKERS = {
    "egg", "eggs", "chicken", "beef", "pork", "fish", "prawn", 
    "gelatin", "lard", "rennet", "meat", "mutton", "shellfish", "crab"
}

DAIRY_MARKERS = {
    "milk", "cheese", "butter", "ghee", "whey", "lactose", "casein", "yoghurt", "cream"
}

ADDITIVE_CODES = {
    "E102": "Tartrazine (Artificial Colour)",
    "E110": "Sunset Yellow FCF (Artificial Colour)",
    "E129": "Allura Red AC (Artificial Colour)",
    "E621": "MSG (Flavour Enhancer)",
    "E627": "Disodium Guanylate (Flavour Enhancer)",
    "E631": "Disodium Inosinate (Flavour Enhancer)",
    "E635": "Disodium Ribonucleotides (Flavour Enhancer)",
    "E950": "Acesulfame K (Artificial Sweetener)",
    "E951": "Aspartame (Artificial Sweetener)",
    "E955": "Sucralose (Artificial Sweetener)",
    "E211": "Sodium Benzoate (Preservative)",
    "E220": "Sulfur Dioxide (Preservative)",
    "E450": "Diphosphates (Emulsifying Salt)",
    "E508": "Potassium Chloride (Firming Agent)",
}


class DietaryValidationResult(TypedDict):
    is_veg: bool
    dietary_conflict: bool
    conflict_message: Optional[str]
    hidden_additives: list[str]


def detect_veg_status(ocr_text: str, off_allergens: list[str]) -> bool:
    """Scan OCR ingredients text and OFF tags for non-veg ingredients."""
    text_lower = ocr_text.lower() if ocr_text else ""
    
    # Check OCR
    for marker in NON_VEG_MARKERS:
        if re.search(rf"\b{marker}\b", text_lower):
            return False
            
    # Check OFF tags
    for allergen in off_allergens:
        if allergen.lower() in NON_VEG_MARKERS:
            return False
            
    return True


def check_dietary_conflict(ocr_text: str, is_veg: bool, user_focus: Optional[str], sugar_per_100g: float) -> tuple[bool, str | None]:
    """
    Cross-reference the product components against user's dietary_focus limits.
    """
    if not user_focus or user_focus.lower() == "none":
        return False, None

    focus = user_focus.lower()
    text_lower = ocr_text.lower() if ocr_text else ""
    
    if focus == "vegan":
        if not is_veg:
            return True, "⚠️ Dietary Conflict: Contains animal products, conflicting with your Vegan preference."
        for dairy in DAIRY_MARKERS:
            if re.search(rf"\b{dairy}\b", text_lower):
                return True, f"⚠️ Dietary Conflict: Contains {dairy}, conflicting with your Vegan preference."
        if re.search(r"\bhoney\b", text_lower):
            return True, "⚠️ Dietary Conflict: Contains honey, conflicting with your Vegan preference."
            
    elif focus == "vegetarian":
        if not is_veg:
            return True, "⚠️ Dietary Conflict: Contains non-vegetarian ingredients, conflicting with your Vegetarian preference."
            
    elif focus == "keto":
        if sugar_per_100g > 5.0:
            return True, "⚠️ Dietary Conflict: High sugar content limits its compatibility with a Keto diet."
            
    return False, None


def extract_hidden_additives(ocr_text: str) -> list[str]:
    """Regex-scan OCR ingredients text for E-codes and map them."""
    if not ocr_text:
        return []
        
    found_codes = set(re.findall(r"\bE\d{3,4}[a-z]?\b", ocr_text, re.IGNORECASE))
    
    hidden = []
    for code in found_codes:
        code_upper = code.upper()
        if code_upper in ADDITIVE_CODES:
            hidden.append(ADDITIVE_CODES[code_upper])
        else:
            hidden.append(f"{code_upper} (Additive)")
            
    return hidden


def validate_diet(ocr_ingredients: str | None, off_allergens: list[str], user_focus: str | None, sugar_g: float) -> DietaryValidationResult:
    """Master executor snippet."""
    safe_ocr = ocr_ingredients or ""
    
    is_veg = detect_veg_status(safe_ocr, off_allergens)
    conflict, message = check_dietary_conflict(safe_ocr, is_veg, user_focus, sugar_g)
    hidden_additives = extract_hidden_additives(safe_ocr)
    
    return {
        "is_veg": is_veg,
        "dietary_conflict": conflict,
        "conflict_message": message,
        "hidden_additives": hidden_additives
    }
