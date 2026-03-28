"""Application configuration via pydantic-settings."""
from functools import lru_cache
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    # Database
    database_url: str = "sqlite+aiosqlite:///./nutrinfo.db"

    # Google Cloud Vision
    google_application_credentials: str = ""

    # Auth0
    auth0_domain: str = "dev-q61utsgndptw7t83.us.auth0.com"
    auth0_api_audience: str = "https://dev-q61utsgndptw7t83.us.auth0.com/api/v2/"
    GEMINI_API_KEY: str = ""

    # Open Food Facts
    open_food_facts_base_url: str = "https://world.openfoodfacts.org/api/v2"

    # Cache
    product_cache_ttl_days: int = 7


@lru_cache
def get_settings() -> Settings:
    return Settings()
