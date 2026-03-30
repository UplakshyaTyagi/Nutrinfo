"""Nutrinfo FastAPI application — auth-free, CSV-driven product intelligence."""
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.database import Base, engine
from app.routers import products


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Tables already created by load_csv script; this is a safety net.
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield
    await engine.dispose()


def create_app() -> FastAPI:
    app = FastAPI(
        title="Nutrinfo API",
        version="1.0.0",
        description="Product nutrition intelligence — search & scan by name.",
        lifespan=lifespan,
    )

    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    app.include_router(products.router, prefix="/api/v1", tags=["Products"])

    @app.get("/health", tags=["Health"])
    async def health_check():
        return {"status": "ok", "service": "nutrinfo-api"}

    return app


app = create_app()
