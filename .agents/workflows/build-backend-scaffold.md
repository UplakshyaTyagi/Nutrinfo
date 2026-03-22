---
description: Generates the async SQLite database, SQLAlchemy 2.0 models (using UUIDs), and Alembic migrations.
---

Execute the complete database scaffolding inside `nutrinfo_backend`. I am driving this build solo, so the code must be fully wired and ready to run.

1. DATABASE CONNECTION:
- Create `core/database.py`. 
- Implement an asynchronous SQLAlchemy 2.0 engine using `aiosqlite`.
- Define the `Base` declarative class and an `async def get_db()` dependency for FastAPI.

2. ORM MODELS (String UUIDs):
- Create `models/user.py`, `models/product.py`, `models/scan.py`, and `models/review.py`.
- CRITICAL: Since SQLite does not have a native UUID type, you MUST use `String(36)` with `uuid.uuid4().hex` as the primary key default for every table to ensure future PostgreSQL compatibility.
- Build the exact columns specified in NUTRINFO_ARCHITECTURE.md.
- Establish the SQLAlchemy relationships (e.g., User -> Scans, Product -> Reviews).

3. MIGRATIONS:
- Initialize Alembic (`alembic init async_migrations`).
- Configure `env.py` to support asynchronous SQLite migrations and import all models.
- Generate the initial migration script: `alembic revision --autogenerate -m "Initial tables"`.
- Do not leave any placeholder code. Write the exact import statements.