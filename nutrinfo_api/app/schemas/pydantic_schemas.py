from uuid import UUID
from datetime import datetime
from typing import Optional, Any
from pydantic import BaseModel, ConfigDict

# --- Bases ---

class UserBase(BaseModel):
    firebase_uid: str
    display_name: str
    email: str
    dietary_focus: str

class ProductBase(BaseModel):
    name: str
    brand: str
    category: str
    image_url: str
    off_data_json: str
    ocr_ingredients_text: str
    hidden_additives_json: str
    allergens_json: str
    final_score: float
    health_category: str
    insights_json: str
    sugar_rda_pct: float
    sodium_rda_pct: float
    nova_group: int
    is_veg: bool

class ScanHistoryBase(BaseModel):
    dietary_conflict: bool
    scanned_at: datetime

class ReviewBase(BaseModel):
    rating: int
    body: str

# --- Responses ---

class UserResponse(UserBase):
    id: str
    created_at: datetime
    model_config = ConfigDict(from_attributes=True)

class ProductResponse(ProductBase):
    id: str
    last_fetched_at: datetime
    model_config = ConfigDict(from_attributes=True)

class ScanHistoryResponse(ScanHistoryBase):
    id: str
    user_id: str
    product_id: str
    product: Optional[ProductResponse] = None
    model_config = ConfigDict(from_attributes=True)

class ReviewResponse(ReviewBase):
    id: str
    user_id: str
    product_id: str
    created_at: datetime
    model_config = ConfigDict(from_attributes=True)

class AuthSyncResponse(BaseModel):
    status: str
    user: UserResponse

class ScanResponse(BaseModel):
    status: str
    source: str
    data: dict[str, Any]  # The merged dictionary returned by /scan
