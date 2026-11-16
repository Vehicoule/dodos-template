# DodOS repository

Verification, before every commit and identical in CI:

    nix develop -c ./verify

This repository was created from `dodos-template`. Its first pull request
replaces this paragraph with what the repository holds, and what it does not
hold.

Design, contracts and decisions live in the documentation repository,
github.com/Vehicoule/dodos-doc: the decision log is `decisions/README.md` and
the development workflow is `plan/verification.md`. Decision records are not
kept here. This file is the map, not the content.

## How work lands

- `main` takes changes only through a pull request whose checks are green:
  `verify`, `miri`, `sanitizer` ([workflow](.github/workflows/verify.yml)). Force pushes and deletion are refused.
- [`verify`](verify) is the whole check. The same script runs here and in CI, in the
  environment pinned by [`flake.nix`](flake.nix) and `flake.lock`. It checks the internal
  links of the Markdown files and, once there is a `Cargo.toml`, runs
  `cargo fmt`, `cargo clippy` and `cargo test`.
- `miri` and the sanitizer run in CI only: they need a nightly compiler. They
  do nothing until the repository has a Cargo workspace.
- The paths in [`.github/CODEOWNERS`](.github/CODEOWNERS) belong to the two owners: the workflows,
  `verify`, the Nix files, this file, the skills and the tests.

## Always

- English for code, comments, commits and documentation.
- A test comes with the code it guards, and fails without it.
- A check comes with the code it guards, never afterwards, and prints what it
  inspected: a check that inspects nothing must be seen.
- Update `plan/progress.md` in the documentation repository in the same
  change as the work: the colour of the box, the "Now" table, the date. Moving
  a box is part of "done".
- A component gets only the capabilities it is handed; nothing is ambient.
- Work on a short branch, without secrets, until `verify` passes.

## Rust

Skills are in `.agents/skills/` (`.claude/skills` links to it). The rules are
in the skill [`dodos-rust`](.agents/skills/dodos-rust/SKILL.md) (style, tests, lints, what CI runs), the same file
as in the kernel and system repositories. `rust-1-100` lists what changed in
Rust 1.97 to 1.100 ([skill](.agents/skills/rust-1-100/SKILL.md)). Read both before writing Rust.

## Ask first

- Any change to a contract (WIT files, `abi/`, the model, the tests of the
  contract lane): a contract is re-read by the two humans, and a breaking
  change needs a decision record in the documentation repository.
- A new dependency. Code that ends in a Linux driver process must be
  compatible with GPL-2.0 (no Apache-2.0-only crate there).
- Any `unsafe`.
- Any change to a path listed in `.github/CODEOWNERS`.

## Never

- Delete or weaken a test to make `verify` pass.
- Bypass, disable or edit a ruleset, or merge a pull request of the contract
  lane: humans merge there.
- Put a secret, a token or a key in the repository or in a workflow.
- Translate or copy code file by file from another project. Reading is
  allowed; cite the origin of an idea that is taken.
