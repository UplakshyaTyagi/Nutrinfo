"""SQLAlchemy 2.0 ORM Models using String(36) UUID primary keys."""
import uuid
from datetime import datetime
from typing import Optional

from sqlalchemy import String, Text, Boolean, Float, Integer, ForeignKey, DateTime, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base


def generate_uuid() -> str:
    """Helper to generate String UUID primary keys."""
    return str(uuid.uuid4())


class User(Base):
    __tablename__ = "users"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=generate_uuid)
    firebase_uid: Mapped[str] = mapped_column(String(128), unique=True, index=True)
    display_name: Mapped[Optional[str]] = mapped_column(String(100))
    email: Mapped[Optional[str]] = mapped_column(String(200))
    dietary_focus: Mapped[Optional[str]] = mapped_column(String(50))
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())

    # Relationships
    scan_history: Mapped[list["ScanHistory"]] = relationship(back_populates="user", cascade="all, delete-orphan")
    reviews: Mapped[list["Review"]] = relationship(back_populates="user", cascade="all, delete-orphan")


class Product(Base):
    __tablename__ = "products"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=generate_uuid)
    barcode: Mapped[str] = mapped_column(String(50), unique=True, index=True)
    name: Mapped[str] = mapped_column(String(300))
    brand: Mapped[Optional[str]] = mapped_column(String(200))
    category: Mapped[Optional[str]] = mapped_column(String(200))
    image_url: Mapped[Optional[str]] = mapped_column(String(500))
    
    # Raw Data
    off_data_json: Mapped[Optional[str]] = mapped_column(Text)
    ocr_ingredients_text: Mapped[Optional[str]] = mapped_column(Text)
    hidden_additives_json: Mapped[Optional[str]] = mapped_column(Text)
    allergens_json: Mapped[Optional[str]] = mapped_column(Text)
    
    # Computed Intelligence
    final_score: Mapped[Optional[float]] = mapped_column(Float)
    health_category: Mapped[Optional[str]] = mapped_column(String(30))
    insights_json: Mapped[Optional[str]] = mapped_column(Text)
    sugar_rda_pct: Mapped[Optional[float]] = mapped_column(Float)
    sodium_rda_pct: Mapped[Optional[float]] = mapped_column(Float)
    nova_group: Mapped[Optional[int]] = mapped_column(Integer)
    is_veg: Mapped[bool] = mapped_column(Boolean, default=True)
    
    last_fetched_at: Mapped[datetime] = mapped_column(DateTime, default=func.now(), onupdate=func.now())

    # Relationships
    scans: Mapped[list["ScanHistory"]] = relationship(back_populates="product", cascade="all, delete-orphan")
    reviews: Mapped[list["Review"]] = relationship(back_populates="product", cascade="all, delete-orphan")


class ScanHistory(Base):
    __tablename__ = "scan_history"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=generate_uuid)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id"))
    product_id: Mapped[str] = mapped_column(ForeignKey("products.id"))
    dietary_conflict: Mapped[bool] = mapped_column(Boolean, default=False)
    scanned_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())

    # Relationships
    user: Mapped["User"] = relationship(back_populates="scan_history")
    product: Mapped["Product"] = relationship(back_populates="scans")


class Review(Base):
    __tablename__ = "reviews"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=generate_uuid)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id"))
    product_id: Mapped[str] = mapped_column(ForeignKey("products.id"))
    rating: Mapped[int] = mapped_column(Integer)  # 1-5
    body: Mapped[Optional[str]] = mapped_column(Text)
    created_at: Mapped[datetime] = mapped_column(DateTime, server_default=func.now())

    # Relationships
    user: Mapped["User"] = relationship(back_populates="reviews")
    product: Mapped["Product"] = relationship(back_populates="reviews")
