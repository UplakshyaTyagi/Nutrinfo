"""SQLAlchemy 2.0 ORM Models — auth-free, CSV-driven product database."""
import uuid
from datetime import datetime
from typing import Optional

from sqlalchemy import String, Text, Float, Integer, DateTime, func, Index
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import Base


def generate_uuid() -> str:
    return str(uuid.uuid4())


class Product(Base):
    """Product table matching the CSV columns exactly."""
    __tablename__ = "products"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    product_name: Mapped[str] = mapped_column(String(500), index=True)
    sugars_100g: Mapped[float] = mapped_column(Float, default=0)
    sat_fat_100g: Mapped[float] = mapped_column(Float, default=0)
    sodium_mg_100g: Mapped[float] = mapped_column(Float, default=0)
    fiber_100g: Mapped[float] = mapped_column(Float, default=0)
    protein_100g: Mapped[float] = mapped_column(Float, default=0)
    calories_100g: Mapped[float] = mapped_column(Float, default=0)
    nova_group: Mapped[int] = mapped_column(Integer, default=0)
    additives_n: Mapped[int] = mapped_column(Integer, default=0)
    health_score: Mapped[float] = mapped_column(Float, default=5.0)

    # Full-text search index on product_name
    __table_args__ = (
        Index("ix_products_name_lower", func.lower(product_name)),
    )
