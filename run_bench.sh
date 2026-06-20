#!/usr/bin/env bash
#
# run_bench.sh — sweep all kernel families and variants and sizes through
# hyperfine and export one markdown table per (family, size) combo,
# plus a combined results/ directory you can paste straight into a
# writeup or PR description.
#
# Usage:
#   ./run_bench.sh                 # full sweep, default sizes
#   ./run_bench.sh -w 5 -m 30      # override warmup/min-runs
#   ./run_bench.sh --quick         # smaller sweep for a fast sanity check
#
# Requires: hyperfine on PATH, dune build already run (or this script
# will run it for you).

set -euo pipefail

BIN_DIR="_build/default/bin"
OUT_DIR="results"
WARMUP=3
MIN_RUNS=20
VARIANTS=(scalar neon optim clang clang_restrict)

# size:reps pairs — reps chosen so each hyperfine *run* (not the whole
# sweep) stays in the sub-few-seconds range even at DRAM sizes.
# Adjust reps down further if a single run still feels too slow.
SIZES=(
  "256:100000"      # L1
  "65536:5000"      # L2
  "4000000:30"      # DRAM
)

QUICK=0
EXTRA_ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --quick)
      QUICK=1
      shift
      ;;
    -w)
      WARMUP="$2"
      shift 2
      ;;
    -m)
      MIN_RUNS="$2"
      shift 2
      ;;
    *)
      EXTRA_ARGS+=("$1")
      shift
      ;;
  esac
done

if [[ "$QUICK" -eq 1 ]]; then
  SIZES=("256:2000")
  MIN_RUNS=10
fi

if ! command -v hyperfine >/dev/null 2>&1; then
  echo "error: hyperfine not found on PATH" >&2
  exit 1
fi

echo "==> dune build"
dune build

mkdir -p "$OUT_DIR"

FAMILIES=(saxpy dot sum)

for family in "${FAMILIES[@]}"; do
  bin="$BIN_DIR/bench_${family}.exe"
  if [[ ! -x "$bin" ]]; then
    echo "warning: $bin not found or not executable, skipping $family" >&2
    continue
  fi

  for size_pair in "${SIZES[@]}"; do
    n="${size_pair%%:*}"
    reps="${size_pair##*:}"

    cmds=()
    labels=()
    for v in "${VARIANTS[@]}"; do
      cmds+=("$bin $v $n $reps")
      labels+=("$v")
    done

    out_md="$OUT_DIR/${family}_n${n}.md"
    out_json="$OUT_DIR/${family}_n${n}.json"

    echo "==> $family  n=$n  reps=$reps"

    # Build a -n/-L style hyperfine invocation with explicit
    # --command-name labels so the markdown table reads cleanly
    # (variant name instead of the full binary invocation).
    hf_args=(-w "$WARMUP" -m "$MIN_RUNS" --export-markdown "$out_md" --export-json "$out_json")
    for i in "${!cmds[@]}"; do
      hf_args+=(--command-name "${labels[$i]}" "${cmds[$i]}")
    done

    if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
      hyperfine "${hf_args[@]}" "${EXTRA_ARGS[@]}"
    else
      hyperfine "${hf_args[@]}"
    fi
  done
done

# Stitch everything into one combined markdown file with section
# headers, so you have a single file to paste/share.
combined="$OUT_DIR/combined.md"
{
  echo "# seraph kernel benchmarks"
  echo
  echo "Generated $(date -u '+%Y-%m-%d %H:%M UTC') via run_bench.sh"
  echo
  for family in "${FAMILIES[@]}"; do
    for size_pair in "${SIZES[@]}"; do
      n="${size_pair%%:*}"
      reps="${size_pair##*:}"
      f="$OUT_DIR/${family}_n${n}.md"
      if [[ -f "$f" ]]; then
        echo "## ${family} — n=${n} (reps=${reps})"
        echo
        cat "$f"
        echo
      fi
    done
  done
} > "$combined"

echo
echo "==> done. Per-table results in $OUT_DIR/, combined report at $combined"
