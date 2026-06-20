# seraph kernel benchmarks

Generated 2026-06-20 17:52 UTC via run_bench.sh

## saxpy — n=256 (reps=2000)

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `scalar` | 1.9 ± 0.2 | 1.4 | 2.4 | 1.53 ± 0.17 |
| `neon` | 1.5 ± 0.2 | 1.0 | 2.0 | 1.21 ± 0.19 |
| `optim` | 1.4 ± 0.1 | 1.2 | 1.7 | 1.09 ± 0.09 |
| `clang` | 1.2 ± 0.1 | 1.1 | 1.6 | 1.00 |
| `clang_restrict` | 1.3 ± 0.1 | 1.1 | 2.8 | 1.01 ± 0.09 |

## dot — n=256 (reps=2000)

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `scalar` | 1.9 ± 0.2 | 1.6 | 3.5 | 1.24 ± 0.12 |
| `neon` | 1.6 ± 0.1 | 1.4 | 1.9 | 1.00 |
| `optim` | 1.7 ± 0.2 | 1.4 | 2.2 | 1.09 ± 0.15 |
| `clang` | 2.0 ± 0.2 | 1.5 | 2.4 | 1.26 ± 0.13 |
| `clang_restrict` | 1.9 ± 0.2 | 1.5 | 2.4 | 1.25 ± 0.14 |

