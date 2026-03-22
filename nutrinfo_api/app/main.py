"""Nutrinfo FastAPI application factory."""
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.database import Base, engine
from app.routers import scan, products, reviews, history, auth


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Create all tables on startup (Alembic handles migrations in prod).
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield
    await engine.dispose()


def create_app() -> FastAPI:
    app = FastAPI(
        title="Nutrinfo API",
        version="0.1.0",
        description="Premium food intelligence backend — 4-step ML health scoring pipeline.",
        lifespan=lifespan,
    )

    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],  # Tighten in production.
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    app.include_router(scan.router,     prefix="/api/v1", tags=["Scan"])
    app.include_router(products.router, prefix="/api/v1", tags=["Products"])
    app.include_router(reviews.router,  prefix="/api/v1", tags=["Reviews"])
    app.include_router(history.router,  prefix="/api/v1", tags=["History"])
    app.include_router(auth.router,     prefix="/api/v1", tags=["Auth"])

    @app.get("/health", tags=["Health"])
    async def health_check():
        return {"status": "ok", "service": "nutrinfo-api"}

    return app


app = create_app()
