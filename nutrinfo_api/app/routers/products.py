"""Product search and detail endpoints — no auth required."""
import re
from fastapi import APIRouter, Query
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import Depends

from app.core.database import get_db
from app.models.db_models import Product

router = APIRouter(prefix="/products")

# ── Fetch-more, rank-better constant ─────────────────────────────────────
_CANDIDATE_POOL = 60  # fetch extra candidates so we can re-rank in Python


def _health_category(score: float) -> str:
    if score >= 8.5:
        return "Super Healthy"
    elif score >= 6.5:
        return "Healthy"
    elif score >= 4.5:
        return "Eatable"
    elif score >= 2.5:
        return "Unhealthy"
    else:
        return "Super Unhealthy"


def _product_to_dict(p: Product) -> dict:
    score = p.health_score or 5.0
    return {
        "id": p.id,
        "product_name": p.product_name,
        "sugars_100g": p.sugars_100g,
        "sat_fat_100g": p.sat_fat_100g,
        "sodium_mg_100g": p.sodium_mg_100g,
        "fiber_100g": p.fiber_100g,
        "protein_100g": p.protein_100g,
        "calories_100g": p.calories_100g,
        "nova_group": p.nova_group,
        "additives_n": p.additives_n,
        "health_score": score,
        "health_category": _health_category(score),
    }


def _relevance_score(product_name: str, query: str) -> int:
    """Score a product name against a search query.
    Higher = more relevant.
      4 — exact match (full name equals query)
      3 — name starts with the query
      2 — query appears as a whole word / word-boundary match
      1 — query is only a substring (e.g. 'maggi' inside 'formaggi')
    """
    name_lower = product_name.lower()
    q = query.lower()

    if name_lower == q:
        return 4
    if name_lower.startswith(q):
        return 3
    # word-boundary check: query preceded/followed by non-alpha or string edge
    if re.search(rf'(?<![a-z]){re.escape(q)}(?![a-z])', name_lower):
        return 2
    return 1


def _rank_products(products, query: str):
    """Sort product list so the most relevant names appear first."""
    return sorted(
        products,
        key=lambda p: _relevance_score(p.product_name or "", query),
        reverse=True,
    )


@router.get("/trending")
async def trending_products(
    limit: int = Query(5, ge=1, le=20),
    db: AsyncSession = Depends(get_db),
):
    """Fetch random healthy products (health_score >= 8.5) as trending swaps."""
    stmt = (
        select(Product)
        .where(Product.health_score >= 8.5)
        .order_by(func.random())
        .limit(limit)
    )
    result = await db.execute(stmt)
    products = result.scalars().all()
    return [_product_to_dict(p) for p in products]


@router.get("/search")
async def search_products(
    q: str = Query(..., min_length=2, description="Search query for product name"),
    limit: int = Query(20, ge=1, le=50),
    db: AsyncSession = Depends(get_db),
):
    """Search products by name, ranked by relevance (exact > starts-with > word match > substring)."""
    query = q.strip().lower()
    # Fetch a larger pool of candidates from the DB …
    stmt = (
        select(Product)
        .where(func.lower(Product.product_name).contains(query))
        .limit(_CANDIDATE_POOL)
    )
    result = await db.execute(stmt)
    candidates = result.scalars().all()

    # … then rank in Python and return the top `limit`
    ranked = _rank_products(candidates, query)
    return [_product_to_dict(p) for p in ranked[:limit]]


@router.get("/{product_id}")
async def get_product(
    product_id: int,
    db: AsyncSession = Depends(get_db),
):
    """Get a single product by numeric ID."""
    stmt = select(Product).where(Product.id == product_id)
    result = await db.execute(stmt)
    product = result.scalar_one_or_none()
    if product is None:
        return {"error": "Product not found", "detail": f"No product with id={product_id}"}
    return _product_to_dict(product)


@router.post("/scan-by-name")
async def scan_by_name(
    body: dict,
    db: AsyncSession = Depends(get_db),
):
    """
    Search for a product by OCR-extracted name.
    Expects: {"product_name": "some text from the label"}
    Returns the best matches ranked by relevance, or a not-found message.
    """
    raw_name = (body.get("product_name") or "").strip()
    if not raw_name or len(raw_name) < 2:
        return {"found": False, "message": "Product nutrition info has not been updated yet."}

    query = raw_name.lower()

    # 1) Full-phrase search
    stmt = (
        select(Product)
        .where(func.lower(Product.product_name).contains(query))
        .limit(_CANDIDATE_POOL)
    )
    result = await db.execute(stmt)
    candidates = result.scalars().all()

    if candidates:
        ranked = _rank_products(candidates, query)
        return {
            "found": True,
            "products": [_product_to_dict(p) for p in ranked[:5]],
        }

    # 2) Word-by-word fallback — try each significant word
    words = [w for w in query.split() if len(w) > 2]
    for word in words[:3]:
        stmt = (
            select(Product)
            .where(func.lower(Product.product_name).contains(word))
            .limit(_CANDIDATE_POOL)
        )
        result = await db.execute(stmt)
        candidates = result.scalars().all()
        if candidates:
            ranked = _rank_products(candidates, word)
            return {
                "found": True,
                "products": [_product_to_dict(p) for p in ranked[:5]],
            }

    return {"found": False, "message": "Product nutrition info has not been updated yet."}
