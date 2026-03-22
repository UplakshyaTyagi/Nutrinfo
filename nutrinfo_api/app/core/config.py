"""Application configuration via pydantic-settings."""
from functools import lru_cache
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    # Database
    database_url: str = "sqlite+aiosqlite:///./nutrinfo.db"

    # Google Cloud Vision
    google_application_credentials: str = ""

    # Firebase
    firebase_project_id: str = ""
    GEMINI_API_KEY: str = ""

    # Open Food Facts
    open_food_facts_base_url: str = "https://world.openfoodfacts.org/api/v2"

    # Cache
    product_cache_ttl_days: int = 7


@lru_cache
def get_settings() -> Settings:
    return Settings()
