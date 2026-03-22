"""Open Food Facts Service: Fallback to search product by name if nutrition is missing."""
import httpx
from typing import Optional

from app.core.config import get_settings

settings = get_settings()

async def search_off_by_name(product_name: str, brand: str) -> Optional[dict]:
    """
    Searches Open Food Facts by name and brand.
    Returns a unified features dict if a confident match is found.
    """
    if not product_name:
        return None
        
    query = f"{brand} {product_name}".strip()
    
    # We use the search endpoint v2
    url = f"{settings.open_food_facts_base_url}/search"
    params = {
        "search_terms": query,
        "search_simple": 1,
        "action": "process",
        "json": 1,
        "page_size": 1
    }
    
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get(url, params=params, timeout=10.0)
            response.raise_for_status()
            data = response.json()
            
            products = data.get("products", [])
            if not products:
                return None
                
            best_match = products[0]
            nutrients = best_match.get("nutriments", {})
            
            return {
                "energy_kcal": float(nutrients.get("energy-kcal_100g", 0)),
                "sugars": float(nutrients.get("sugars_100g", 0)),
                "sat_fat": float(nutrients.get("saturated-fat_100g", 0)),
                "sodium": float(nutrients.get("sodium_100g", 0)) * 1000, # Convert to mg
                "fiber": float(nutrients.get("fiber_100g", 0)),
                "protein": float(nutrients.get("proteins_100g", 0)),
                "nova_group": int(best_match.get("nova_group", 0)),
                "ingredients_text": best_match.get("ingredients_text", ""),
                "allergens_tags": best_match.get("allergens_tags", []),
                "image_url": best_match.get("image_url", ""),
                "off_data_json": best_match,
            }
            
    except Exception as e:
        print(f"OFF API Error: {e}")
        return None
