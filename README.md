# dodos-template

The template of every new DodOS repository (Step 0 of the
[roadmap](https://github.com/Vehicoule/dodos-doc/blob/main/plan/roadmap.md#step-0)):
the Nix environment, the `verify` command, `AGENTS.md`, the GitHub Actions
workflow and `CODEOWNERS`. A repository made from it is born with its CI.

After **Use this template**:

1. Replace the second paragraph of [`AGENTS.md`](AGENTS.md) with what the repository holds,
   and add its contract paths to `.github/CODEOWNERS`.
2. Keep [`LICENSE`](LICENSE) (AGPL-3.0, D-014) for code; a repository of WIT files or
   of an SDK takes the Apache License 2.0 (D-119).
3. Recreate the ruleset of `main`: GitHub does not copy rulesets from a
   template. Copy the one of this repository (Settings, Rules, Rulesets,
   Export, then Import in the new repository).
4. Replace this README.
