---
paths:
  - "**/*.py"
---

# Python

`uv` manages dependencies and virtualenvs. Never run `pip install`. Add with `uv add`, run with `uv run`, sync with `uv sync`, and never hand-edit a lockfile.

`ruff` is both linter and formatter, usually wired as a pre-commit hook. A ruff finding is a real finding — fix the cause rather than adding `noqa`. Fixes that change a default, a signature or a constructor are behaviour changes: run the tests before calling them done.

Type hints on every function signature. Prefer Pydantic or SQLModel models over passing dicts around.

Tests are pytest. Run them, read the failure output, and quote the result rather than predicting it.

Line width belongs to `ruff format`. Don't hand-wrap code, and don't hard-wrap docstrings or comments at a column — see the `style` rule.

For FastAPI, SQLModel, Alembic and pytest patterns in depth, invoke the `python-stack` skill.
