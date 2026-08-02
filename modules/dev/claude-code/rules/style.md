# Writing style

## No column limit

Never hard-wrap text at 80 columns, or at any other fixed width. This applies to prose, markdown, comments, commit message bodies and docstrings.

Break lines where the meaning breaks — one clause, one idea, one list item per line — or don't break them at all and let the editor soft-wrap.

Code line width belongs to the formatter. nixfmt, ruff-format and prettier decide it; you don't.

## Comments

Keep them short and put them above the code they describe. Comment the why, not the what. If the line already says what it does, the comment is noise.

When a comment genuinely needs several sentences of context, that is a signal to split the code into sections with a short heading comment on each, rather than writing one long paragraph.

Don't write comments that point at other files or at the history of the code. "Moved from utils.py", "see also the handler", "this used to be a loop" — none of these are reasons. Git already knows.

Two things that *are* worth a longer comment, because they can't be derived from the code:

- A workaround for a bug or a surprising upstream behaviour. Say what breaks without it, and link the issue.
- A non-obvious invariant that a future edit could silently violate.

The house convention of a trailing `#` comment naming each entry in a Nix package list stays — that is a label, not an explanation.
