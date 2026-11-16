---
name: dodos-rust
description: The Rust rules of DodOS, shared by the kernel and system repositories - style, tests, lints and the checks CI runs. Read before writing or reviewing Rust in either repository.
---

# Rust in DodOS

This file is the same in the kernel and system repositories. Rules that hold
in one repository only are in its `AGENTS.md`. For what changed in recent
compilers, read the skill `rust-1-100`.

## Style

- Propagate errors with `?`. No hand-written `match` that only returns the
  error.
- An enum instead of a `bool` parameter.
- No glob import (`use x::*`) outside tests.
- No `Rc` or `Arc` unless ownership is really shared.
- One small function per operation; a check that several operations share is
  written once.
- Short is a requirement, not a preference: two humans re-read the code. If a
  file grows past what one sitting can read, split the behaviour, not the
  file.

The enum, glob and `Rc`/`Arc` rules come from the Google Rust style guide.

## Tests

- One test per behaviour, named after the behaviour.
- A bug fix comes with a regression test named after its issue (practice of
  ripgrep).
- A test fails without the code it guards. Check it: change the code, see the
  test fail.
- Random tests use a hand-written deterministic generator and fixed seeds, so
  a failure reproduces.
- Never delete or weaken a test to make `verify` pass.

## Lints

Every crate has `[lints] workspace = true`. The workspace lints check the
rules a tool can check (glob imports, several `bool` parameters). `verify`
runs clippy with warnings denied.

## What CI runs

| Check | Where | What it catches |
|---|---|---|
| `verify`: format, clippy, tests | Locally and in CI, through Nix | The base |
| Kani | CI only | A property of a pure function, for every input |
| Miri | CI only, nightly compiler | Undefined behaviour in `unsafe` code |
| Address sanitizer | CI only, nightly compiler | Memory errors at run time in hosted tests |

Kani, Miri and the sanitizer are not in Nix, so they do not run in `verify`.
A crate with `#![forbid(unsafe_code)]` and long random tests is excluded from
Miri and from the sanitizer in the workflow file; a crate with `unsafe` never
is.

## `unsafe`

- Every `unsafe` block has a `// SAFETY:` comment that says why the
  conditions hold.
- A crate that needs no `unsafe` says so with `#![forbid(unsafe_code)]`.
