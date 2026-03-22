---
description: Organizes project folders, initializes Flutter & FastAPI environments, and sets up Git.
---

Act as the project manager and organize this root monorepo directory. I have dropped raw files into the root. Execute these steps exactly:

1. ASSET ORGANIZATION:
- Create a folder named `ui_references/stitch_html/` and move all raw `.html` and `.css` files into it.
- Create a folder named `ui_references/mockups/` and move any UI reference images (like dashboard mockups) into it, EXCEPT for the logo.

2. BACKEND INITIALIZATION (FastAPI):
- Create a `nutrinfo_backend` folder.
- Inside it, generate a `requirements.txt` with exactly: fastapi, uvicorn, sqlalchemy, aiosqlite, alembic, pandas, scikit-learn.
- Create empty subfolders: `routers/`, `models/`, `schemas/`, and `services/`.
- Create a blank `main.py` file.

3. FRONTEND INITIALIZATION (Flutter):
- Run `flutter create nutrinfo_app` in the terminal to scaffold the mobile app.
- Once created, make an `assets/images/` folder inside `nutrinfo_app/`.
- Find the `logo.png` file in the root directory and move it into `nutrinfo_app/assets/images/logo.png`.
- Update the Flutter `pubspec.yaml` file to explicitly include the `- assets/images/` path.

4. VERSION CONTROL:
- Initialize a git repository in the root directory.
- Create a `.gitignore` file that ignores Python `__pycache__`, `.venv`, and standard Flutter build files.
- Do not write any actual application logic yet. Confirm when the workspace is perfectly structured.