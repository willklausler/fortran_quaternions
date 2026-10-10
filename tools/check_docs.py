#!/usr/bin/env python3
"""Fail if llms.txt misses a public name or an example program.

Every identifier in a PUBLIC statement of src/quaternions.F90 must appear in
llms.txt, and every example/*.f90 must appear in it verbatim.
"""
import pathlib
import re
import sys

root = pathlib.Path(__file__).resolve().parent.parent
llms = (root / "llms.txt").read_text()
source = (root / "src" / "quaternions.F90").read_text()

errors = []
for line in source.splitlines():
    match = re.match(r"\s*public\s*::\s*(.*)", line, re.IGNORECASE)
    if not match:
        continue
    for name in re.split(r"\s*,\s*", match.group(1).strip()):
        if re.fullmatch(r"\w+", name) and not re.match(r"(write|read)_\w\w$", name):
            if not re.search(rf"\b{name}\b", llms):
                errors.append(f"public name not in llms.txt: {name}")

for example in sorted((root / "example").glob("*.f90")):
    if example.read_text().strip() not in llms:
        errors.append(f"example not verbatim in llms.txt: {example.name}")

print("\n".join(errors) or "llms.txt covers all public names and examples")
sys.exit(1 if errors else 0)
