# Git

Commit messages open with a gitmoji, then an imperative sentence. Capitalize the first word, no trailing period.

Pick the emoji for the *type* of change when there is a standard one — ✨ feature, 🐛 fix, ♻️ refactor, ⬆️ dependency bump, 🚚 move, 🗑️ removal, 🚧 WIP, ✏️ typo, 🔧 config, 💥 sweeping change, 👽 adapting to an upstream API change, 🚸 UX improvement.

Otherwise pick one for the *subject*. This repo does that often: 🥭 for mango, ❄️ for nix/flake work, 🐳 for podman, 📸 for the screenshot tool, 🫆 for fingerprint.

Lock file bumps are always `🔒 Update flake.lock`.

A commit covering two distinct things stacks both emoji, or joins the halves with `+`:

```
🔒🐛 Update flake.lock + Fix pam services config after update
🐛 Fix xdpw issue with screencast + 🚸 Improve screencast selection
```

Don't amend or push unless asked.
