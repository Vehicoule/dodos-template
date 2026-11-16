---
name: rust-1-100
description: What changed in Rust 1.97 to 1.100 (July to November 2026) that matters for DodOS. Read before writing Rust here; these releases are newer than most model training data.
---

# Rust 1.97 to 1.100, for DodOS

Source: `RELEASES.md` of rust-lang/rust, read on 14 November 2026. The flake
pins the toolchain; check `rustc --version` before using an item below
(on 14 November 2026 the flake gives 1.99.1, so the 1.100 items are not yet
available).

## Useful here

| Since | Item | Use in the kernel |
|---|---|---|
| 1.100 | Custom allocators are stable: `core::alloc::Allocator`, `Vec::new_in`, `Box::new_in` | Collections backed by untyped memory, with no global heap |
| 1.100 | The never type `!` is stable; `Infallible` is an alias of `!` | Functions that never return (panic, idle loop, entry) |
| 1.100 | `extern "custom"` is stable | Entry points whose calling convention is hand-written |
| 1.100 | `core::mem::DropGuard` | Clean-up on early return without a hand-written guard type |
| 1.100 | Cargo lints: `[lints.cargo]`, with an unused-dependency check | Add to the workspace lints once there are dependencies |
| 1.100 | Cargo minimum publish age (dependency cool-down) | Supply chain: refuse versions published in the last days |
| 1.99 | C-variadic function definitions and `core::ffi::VaList` are stable | The Linux driver emulation layer (`printk`-style functions) |
| 1.99 | `#[unsafe(naked)]` C-variadic functions | Architecture layer |
| 1.98 | `core::fmt::NumBuffer`, `<integer>::format_into` | Print a number on the console without allocation |
| 1.98 | `bool::ok_or`, `Option::map_or_default`, `Result::map_or_default` | Shorter error paths |
| 1.98 | `core::sync::atomic::Atomic<T>` helpers (`from_mut`, slices) | Per-core state |

## Breaking, or newly refused

- 1.100: `box` patterns are no longer accepted. Closures capture variables used in `if let` more precisely, which can give new borrow errors. Some `Box` impls are generic over the allocator, which can give new inference errors. On x86 the "Rust" ABI now passes values in SSE registers when they are always available: never assume the Rust ABI in assembly, use `extern "C"` or `extern "custom"`.
- 1.100: enabling SSE or AVX on a soft-float x86 target is an error. Bare-metal targets such as `x86_64-unknown-none` are soft-float (from memory, to check when the target is chosen).
- 1.100: `repr(align)` fields in a `repr(packed)` type are a deny-by-default lint.
- 1.99: `std::i32::MAX` and the other legacy integer modules are fully deprecated: write `i32::MAX`. `#[no_mangle]` on a generic item is a hard error. References to extern statics are no longer promoted.
- 1.99: Cargo disables incremental compilation when `CI` is set.
- 1.98: `invalid_runtime_symbol_definitions` is deny-by-default: defining `memcpy`, `memset` and similar symbols with a wrong signature is refused. The kernel defines these itself, so their signatures must be exact. More ambiguous glob imports are errors.
