"""Vision Service: Extracts product information from images using Gemini 1.5 Flash."""
import json
from typing import TypedDict, Optional

from google import genai
from google.genai import types
from pydantic import BaseModel, Field

from app.core.config import get_settings

settings = get_settings()

client = genai.Client(api_key=settings.GEMINI_API_KEY) if settings.GEMINI_API_KEY else None


class NutrientData(BaseModel):
    energy_kcal: float = Field(description="Total calories. If unknown, 0.0")
    sugars: float = Field(description="Sugars per 100g. If unknown, 0.0")
    sat_fat: float = Field(description="Saturated fat per 100g. If unknown, 0.0")
    sodium: float = Field(description="Sodium in mg per 100g. If unknown, 0.0")
    fiber: float = Field(description="Dietary fiber per 100g. If unknown, 0.0")
    protein: float = Field(description="Protein per 100g. If unknown, 0.0")


class ExtractedProductData(BaseModel):
    product_name: str = Field(description="The generic name of the product. E.g., 'Tomato Ketchup'.")
    brand: str = Field(description="The brand name. E.g., 'Heinz'.")
    food_category: str = Field(description="The broad food category. E.g., 'Sauces', 'Beverages', 'Chips'.")
    ingredients_text: str = Field(description="The full ingredients list exactly as written.")
    nutrients: NutrientData = Field(description="The specific macronutrients per 100g.")
    is_nutrition_visible: bool = Field(description="True if the actual nutritional table was visible and parsed.")


class VisionResult(TypedDict):
    product_name: str
    brand: str
    food_category: str
    ingredients_text: str
    nutrients: dict
    is_nutrition_visible: bool


async def analyze_product_image(image_bytes: bytes, mime_type: str) -> Optional[VisionResult]:
    """
    Passes the image to Gemini 1.5 Flash to extract the product details.
    Uses Structured Outputs (JSON Schema) to enforce the response format.
    """
    if not client:
        raise ValueError("GEMINI_API_KEY is not configured.")

    prompt = (
        "You are an expert food product analyzer. Look carefully at this image of a food product.\n"
        "1. Extract the product name, brand, and general food_category (e.g. 'Snacks', 'Beverages').\n"
        "2. Extract the exact ingredients text if visible.\n"
        "3. Look for the nutritional information table. Extract the values per 100g for Energy (kcal), "
        "Sugars (g), Saturated Fat (g), Sodium (mg), Fiber (g), and Protein (g).\n"
        "4. If the nutritional table is NOT visible in this specific photo, set `is_nutrition_visible` to false "
        "and just return 0.0 for the nutrients."
    )

    try:
        response = client.models.generate_content(
            model='gemini-2.5-flash',
            contents=[
                prompt,
                types.Part.from_bytes(data=image_bytes, mime_type=mime_type),
            ],
            config=types.GenerateContentConfig(
                response_mime_type="application/json",
                response_schema=ExtractedProductData,
                temperature=0.1, # Low temperature for factual extraction
            ),
        )

        if not response.text:
            return None

        data = json.loads(response.text)
        
        return {
            "product_name": data.get("product_name", ""),
            "brand": data.get("brand", ""),
            "food_category": data.get("food_category", "Unknown"),
            "ingredients_text": data.get("ingredients_text", ""),
            "nutrients": data.get("nutrients", {}),
            "is_nutrition_visible": data.get("is_nutrition_visible", False)
        }

    except Exception as e:
        print(f"Gemini Vision API Error: {e}")
        return None
