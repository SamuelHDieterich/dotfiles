# Testing

pytest with `httpx` and FastAPI's `TestClient`. `pythonpath = ["."]` under `[tool.pytest.ini_options]` makes the app package importable without installing it.

```console
$ uv run pytest
$ uv run pytest tests/test_auth.py -x
$ uv run pytest -k "share" -q
```

## Build the smallest app that exercises the thing

For middleware, exception handlers and dependencies, construct a minimal app in a fixture rather than importing the real one. The test then doesn't drag in routing, auth and settings:

```python
@pytest.fixture
def app_with_handlers():
    app = FastAPI()
    register_exception_handlers(app)

    @app.get("/raises")
    def raises():
        raise AppException(message="bad input", status_code=400, error_code="bad_input")

    return app
```

Assert on the `error_code`, not the message. Messages are display text and will change.

## Database isolation

Override the session dependency instead of pointing tests at a live database:

```python
app.dependency_overrides[get_session] = lambda: test_session
```

Give each test a transaction that rolls back at teardown. Tests depending on rows another test left behind are how a suite becomes order-dependent.

## A lint fix is a behaviour change until proven otherwise

Changing a default value, a signature or a constructor can alter behaviour that tests rely on, even when the change is obviously correct in isolation. Replacing a mutable default to satisfy B006 is the classic case: the lint is right, and callers sharing that default still break.

Run the suite after any such change. Read the failure rather than guessing which test broke.

## Claiming it passes

Run the suite and quote the summary line. "Tests should pass now" is not a result, and a green run of the single test you were watching says nothing about the rest.
