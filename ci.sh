#!/bin/bash
# Local multi-compiler check: tests in both profiles with every compiler
# found on PATH, then the generated-file and documentation checks.
# GitHub Actions (.github/workflows/ci.yml) covers more platforms.

source /opt/intel/oneapi/setvars.sh > /dev/null 2>&1
FAILED=()

for FC in gfortran ifx nvfortran flang flang-new; do
    command -v "$FC" > /dev/null || continue
    for PROFILE in debug release; do
        echo "--- $FC $PROFILE"
        if fpm test --compiler "$FC" --profile "$PROFILE" && fpm run --compiler "$FC" --profile "$PROFILE" --example --all > /dev/null; then
            echo "✅ $FC $PROFILE"
        else
            FAILED+=("$FC $PROFILE")
        fi
    done
done

make check-generated > /dev/null || FAILED+=("generated files differ from tmpl/ (run make generate)")
python3 tools/check_docs.py || FAILED+=("llms.txt")

if [ ${#FAILED[@]} -eq 0 ]; then
    echo "✅ All checks passed"
else
    printf '❌ %s\n' "${FAILED[@]}"
    exit 1
fi
