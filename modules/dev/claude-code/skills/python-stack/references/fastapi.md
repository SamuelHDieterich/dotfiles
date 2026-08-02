# FastAPI

## Routers

One module per resource, each exposing a `router`, aggregated in a single place per API version:

```python
api_router = APIRouter()
api_router.include_router(cases.router, prefix="/cases", tags=["cases"])
```

Version in the path prefix (`/api/v1`), set once when the aggregate router is mounted. Individual routers stay version-agnostic.

## Dependencies

Dependencies are the injection point for the session, the current user and permission checks. Declare them on the router when they apply to every route in it, rather than repeating them per endpoint:

```python
router = APIRouter(dependencies=[Depends(require_authenticated)])
```

A dependency that raises is how authorization should fail — not an `if` at the top of each handler. Missing the check in one handler out of twenty is the failure mode that pattern prevents.

Use `Annotated[Session, Depends(get_session)]` rather than a bare default value. It keeps the type checker informed and reads correctly to Pyright.

## Request and response models

Declare `response_model` explicitly. It is what strips fields the client shouldn't see; relying on the return annotation of an ORM object leaks columns.

Separate the input schema from the output schema even when they start identical. They diverge the first time you add a server-generated field, and splitting them later means touching every caller.

Validation belongs in the Pydantic model — constrained types, validators, defaults — not in the handler body.

## Errors

Raise the application exception type from services; let the registered handler translate it. Handlers returning `JSONResponse` directly bypass the shared error shape and produce responses the frontend can't parse uniformly.

Include `Retry-After` on 429s.

## Background and long work

`BackgroundTasks` is for short follow-ups after a response — sending a mail, writing an audit row. Anything that can fail meaningfully, take minutes, or needs a retry belongs in a real queue or worker, not in the request lifecycle.

## Rate limiting

`slowapi` attaches limits per route. Apply them to authentication and anything expensive before anything else — those are the endpoints that get found.

## Settings and startup

Do environment branching once, at import, not inside handlers. A handler that checks which environment it is in on every call is a handler that behaves differently in tests than in production.
