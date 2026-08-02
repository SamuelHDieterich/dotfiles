---
name: python-stack
description: Building Python backends with FastAPI, SQLModel/SQLAlchemy, Alembic, uv and pytest — project layering, settings, exception handling, session management, migrations and test structure. Use when writing or reviewing FastAPI endpoints, database models, migrations, or backend tests.
---

# Python backend stack

FastAPI on SQLModel and SQLAlchemy 2, Postgres via psycopg 3, settings through pydantic-settings, migrations with Alembic, tests with pytest and httpx. `uv` owns dependencies and virtualenvs; `ruff` lints and formats.

Read the project's own config before applying any of this — it describes the stack, not a particular repo.

## Toolchain

| Task | Command |
|---|---|
| Add a dependency | `uv add <pkg>` |
| Add a dev dependency | `uv add --dev <pkg>` |
| Run anything | `uv run <cmd>` |
| Sync the environment | `uv sync` |
| Lint / format | `ruff check`, `ruff format` |
| Test | `uv run pytest` |

Never `pip install`. Never edit a lockfile by hand.

A ruff finding is a real finding, not noise to silence with `noqa`. B006 in particular — a mutable default like `[]` or `set()` in a signature — is easy to "fix" in a way that changes behaviour, because callers may depend on the shared default. Run the tests after fixing one.

## Layering

Keep the dependency direction one-way:

```
endpoints  →  services  →  repositories  →  session
```

Endpoints parse and validate, services hold the logic, repositories are the only code that touches the session. An endpoint reaching straight into a repository is a smell; a repository importing a service is a bug.

Request and response models are Pydantic schemas, kept separate from the ORM models. Returning an ORM object directly couples the wire format to the table.

When models are shared by more than one deployable — an API and a worker, say — they belong in their own installable package, wired in as an editable path dependency so both consume one definition:

```toml
[tool.uv.sources]
mypkg_db = { path = "../database", editable = true }
```

## Settings

One `Settings(BaseSettings)`, exposed as a module-level `settings` that everything else imports. No `os.environ` reads scattered through the code.

```python
class Settings(BaseSettings):
    APP_NAME: str = "MyApp"
    DB_NAME: str
    DB_PASSWORD: Optional[SecretStr] = None  # unused under IAM auth
    model_config = SettingsConfigDict(env_file=".env")
```

Required values get no default, so a missing one fails at import rather than at first use. An optional value that applies to only one environment gets a short trailing comment saying which.

## Sessions

Build the engine once at module scope and branch on environment there, not per request:

```python
SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False)
```

`autoflush=False` is deliberate — it stops a half-built object from reaching the database mid-function. Sessions reach endpoints through a dependency, one per request, closed in a `finally`.

URL-encode credentials with `quote(value, safe="")` when composing a DSN. A password containing `@` or `/` otherwise produces a connection error that points nowhere near the cause.

## Errors

One application exception type carrying `message`, `status_code`, a stable `error_code` and optional `headers`, with handlers registered once at app creation.

The `error_code` is the API contract; the message is display text. Changing user-facing wording must never change an error code — those are separate edits with separate blast radii.

## References

- `references/fastapi.md` — routers, dependencies, response models, background work.
- `references/alembic.md` — generating, reviewing and running migrations safely.
- `references/testing.md` — fixtures, TestClient, database isolation.
