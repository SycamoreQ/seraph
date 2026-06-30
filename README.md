# Seraph

Hand-written ARM NEON kernels in OCaml, with correctness testing and throughput benchmarking against clang-generated baselines.

## Overview

Seraph is a collection of hand-written AArch64 NEON assembly kernels, called from OCaml via a thin C FFI layer. The goal is to understand SIMD programming at the instruction level — writing kernels by hand, verifying them against scalar OCaml references, and measuring them against what a compiler produces on its own.

The project is structured around a deliberate learning sequence: write kernels by hand before automating anything, internalize each ISA's quirks (lane width, tail handling, reduction patterns, calling conventions) before trying to encode them in an IR or generator. Each kernel introduces one new concept the previous ones didn't need.

This is also the foundation for a planned single-query attention kernel, assembling the dot product, softmax, and weighted sum primitives already implemented here into a decode-phase attention operation directly relevant to LLM inference.

## Kernels

| Kernel | File | What it teaches |
|---|---|---|
| SAXPY | `kernels/saxpy.S and kernels/saxpy_optim.S` | Basic elementwise FMA, tail handling, AAPCS64 calling convention |
| Dot product (1 acc) | `kernels/dot.S` | Horizontal reduction via `faddp`, scalar vs vector accumulation |
| Dot product (4 acc) | `kernels/dot_optim.S` | Multiple independent accumulators, breaking serial dependency chains |
| Softmax | `kernels/softmax_neon.S` | Four-pass structure, max-subtraction for numerical stability, `frecpe`/`frecps` reciprocal, polynomial exp approximation via Horner's method |

Each kernel has a scalar OCaml reference implementation in `lib/scalar/` used as a correctness oracle, and a corresponding test file in `test/` that runs both implementations across a range of lengths — including deliberately awkward ones that aren't multiples of the vector width — to exercise tail-handling logic.

## Ablation Study

The benchmark suite compares each hand-written kernel against clang-generated baselines at three sizes chosen to land in different cache regimes:

- **L1** (256 elements, ~1KB per array): compute-bound, instruction scheduling dominates
- **L2** (65536 elements, ~256KB per array): bandwidth/compute boundary
- **DRAM** (4M elements, ~16MB per array): memory-bandwidth-bound, code quality differences wash out

Selected results on Apple Silicon (M-series):

**SAXPY (L1):**
| Variant | ns/call | GFLOP/s | GB/s |
|---|---|---|---|
| Scalar OCaml | 185 | 2.8 | 16.6 |
| Hand-written NEON | 20 | 25.9 | 155 |
| clang -O3, no restrict | 17 | 30.5 | 183 |
| clang -O3, restrict | 16 | 31.1 | 186 |


**Dot product (L1):**
| Variant | ns/call | GFLOP/s | GB/s |
|---|---|---|---|
| Scalar OCaml | 244 | 2.1 | 8.4 |
| Hand-written NEON (1 acc) | 32 | 16.0 | 64 |
| clang -O3, no restrict | 83 | 6.2 | 24.8 |
| clang -O3, restrict | 84 | 6.1 | 24.4 |

**Softmax (L1):**
| Variant | ns/call | GFLOP/s | GB/s |
|---|---|---|---|
| Scalar OCaml | 1757 | 1.2 | 4.7 |
| Hand-written NEON | 101 | 20.2 | 80.8 |
| clang -O3 | 433 | 4.7 | 18.9 |

## Building

Requires an arm64 machine (Apple Silicon Mac or arm64 Linux). NEON instructions do not run on x86; there is no cross-compilation support.

```sh
opam install alcotest
dune build
```

**Run tests:**
```sh
dune test
```

## FFI Design

The OCaml to assembly boundary uses a two-layer approach. The `.S` files contain pure AArch64 assembly with no knowledge of OCaml's runtime. A thin `shim.c` sits between them: it receives OCaml `value` arguments, unwraps `Bigarray` values to raw `float*` via `Caml_ba_data_val`, untags integers via `Int_val`, calls the assembly function with a plain C ABI, and wraps any return value via `caml_copy_double`. The assembly never sees tagged integers or OCaml heap objects.

Buffers use `Bigarray.Array1.t` with `float32` element kind and `c_layout`, which provides a flat, GC-immovable, C-compatible memory region. A regular `float array` would store 64-bit doubles and could be moved by the GC mid-call — neither is acceptable at the assembly boundary.

## AAPCS64 Notes

Under the AArch64 procedure call standard:
- `v0`–`v7` and `v16`–`v31` are caller-saved; kernels may clobber them freely
- `v8`–`v15` are callee-saved in their **lower 64 bits only** — clobbering the upper half without saving it causes intermittent corruption in the caller

All kernels in this repo stay within `v0`–`v7` and `v16`–`v31` and are leaf functions, so no save/restore is needed. Any future kernel that needs `v8`–`v15` across a call must save/restore explicitly.
