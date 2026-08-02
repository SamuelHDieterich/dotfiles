---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
---

# Rust

I'm learning this language, not fluent in it. Write the idiomatic version and explain the parts that aren't obvious from reading — why a borrow is where it is, why something needs `Arc` rather than `Rc`, what a lifetime annotation is actually constraining. A working diff I can't reason about is worth less than a slightly slower explanation.

When the borrow checker rejects something, say what ownership rule it is enforcing before showing the fix. "Add `.clone()`" without the reason teaches nothing and usually hides the better design.

Prefer the standard library and a small dependency set. Reach for a crate when it earns its place, not by reflex.

`cargo fmt` owns formatting and `cargo clippy` is worth treating as authoritative — surface its suggestions rather than silencing them. Line width belongs to `cargo fmt`; see the `style` rule.

Where performance is the point, say what you are trading. Zero-cost claims should be attached to something measurable, not asserted.
