---
description: Wires the FastAPI routers, Pydantic schemas, database sessions, and ML engine together into a functional API.
---

Act as the lead Python Backend Engineer. We need to wire our ML engine and SQLite database to the FastAPI endpoints so the Flutter app can consume the data. Write fully functional, production-ready code. Do not leave `pass` or `TODO` blocks.

Execute this strict implementation sequence inside `nutrinfo_backend`:

1. PYDANTIC SCHEMAS (`schemas/scan.py`):
- Create a `ScanRequest` model that accepts a `barcode` (string).
- Create a `ScanResponse` model that returns EXACTLY three fields: `final_score` (float), `category` (string), and `insights` (list of strings).
- Strictly ensure the raw deterministic score is not part of the response schema.

2. ROUTER IMPLEMENTATION (`routers/scanner.py`):
- Initialize an `APIRouter` with the prefix `/api/v1`.
- Write an async POST endpoint `/scan` that takes `ScanRequest` and the `get_db` async SQLAlchemy session dependency.
- Inside the endpoint, call `await process_scan(request.barcode)` from `services.intelligence_engine`.
- Check if a `Product` with this barcode exists in the database. If not, instantiate a new `Product` model with the data and `session.add()` it.
- Instantiate a new `ScanHistory` record linking the `Product` (and a default user UUID for now).
- Execute `await session.commit()` and `await session.refresh()`.
- Return the secure `ScanResponse`.

3. THE MAIN APP (`main.py`):
- Initialize the `FastAPI()` application instance.
- Configure `CORSMiddleware`. You MUST allow origins `["*"]` (or specific localhost ports) so the local Flutter emulator can make requests without cross-origin blocks. Allow all methods and headers.
- Include the scanner router (`app.include_router(...)`).
- Add a simple `@app.get("/health")` endpoint that returns `{"status": "healthy"}` to verify the server is running.