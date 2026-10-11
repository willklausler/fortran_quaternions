# AGENTS.md

Instructions for coding agents working on this repository. The public API and
its conventions are in `llms.txt`; read it before changing behaviour.

## Layout

| Path | Role |
|---|---|
| `tmpl/quaternions.fypp` | **Source of truth** for the module |
| `tmpl/test_quaternions.fypp` | Source of truth for the tests |
| `tmpl/common.fypp` | Kinds, integer kinds, quadruple-precision guard |
| `src/quaternions.F90`, `test/test_quaternions.F90` | **Generated. Never edit.** Commit them with the template change |
| `example/*.f90` | Demo programs; each is copied verbatim into `llms.txt` |
| `app/main.f90` | SLERP demo, the fpm app |
| `llms.txt` | API reference for agents, and the online user manual |
| `man/quaternions.3`, `README.md`, `ford.md` | Human documentation |
| `tools/check_docs.py` | CI check: every public name and example is in `llms.txt` |

## Commands

```sh
pip install fypp==3.3 ford pcpp      # once; FORD runs pcpp as preprocessor
make generate                        # tmpl/ -> src/, test/ (after every template edit)
fpm test --profile debug             # fast check, gfortran
fpm test --profile release
fpm run --example --all
python3 tools/check_docs.py
make check-generated                 # generated files match templates (needs git)
./ci.sh                              # gfortran, ifx, nvfortran if installed
make test FC=ifx                     # make build
make doc                             # FORD HTML in build/doc
```

Done means: `make generate` was run, the tests pass for every compiler you
have in both profiles, and `tools/check_docs.py` passes.

## Decided conventions (do not change without the maintainer)

- Hamilton product (ij = k); scalar first, public components `w, x, y, z`.
- Active rotations: `rotate(q, v)` = q v q^-1. Euler angles: ZYX only.
- `==` is exact; tolerances go through `is_close`.
- Mixed arithmetic only with reals of the same kind and integers of any kind. No implicit kind promotion.
- Elementary functions go through the complex embedding (`*_to_c`, `*_from_c`) so branches match intrinsic `complex`.
- No `error stop` in the library; invalid input yields IEEE NaN/Inf or `iostat > 0`.
- Module name `quaternions`; kinds are not exported (users take them from `iso_fortran_env`).
- Elemental wherever the interface allows.

## Adding or changing a procedure

1. Implement it once in the per-kind loop of `tmpl/quaternions.fypp`, named `${s}$_<name>`.
2. Add the generic to `GENERICS` (or `FUNCS`) there; that also makes it public.
3. Add checks to `tmpl/test_quaternions.fypp`; they run for every kind.
4. Document it in `llms.txt` (the CI check requires the name), the man page and `CHANGELOG.md`.
5. `make generate`, then run the tests.

## Test rules

- Debug profiles trap floating-point exceptions (ifx `-fpe0`, nvfortran `-Ktrap=fp`): tests must not create NaN or Inf through arithmetic, nor compare NaN with `<`. Use `ieee_value` and `ieee_is_nan`.
- Use tolerances relative to `epsilon` of the kind (`tol = 64*eps`); `-O3` changes the last bits.
- One `read` statement per scratch file (ifx bug, see below).
- Compare arrays with the explicit-shape helpers `vclose_*` and `mclose_*`: nvfortran 26.1 corrupts array-valued expressions passed to assumed-shape dummies.

## Compiler quirks that shaped the code

- nvfortran resolves type-bound derived-type I/O for only one type per scope and cannot name `write(formatted)` in `public`: module `quaternions` declares the I/O generics itself under `#ifdef __NVCOMPILER`.
- nvfortran and LLVM flang 21 have no `real128` (guard in `tmpl/common.fypp`).
- nvfortran: no derived-type I/O on character variables, no complex `asinh/acosh/atanh` (computed from `asin/acos/atan`), and no nested I/O in an output list (build the string first).
- gfortran and ifx misbehave when a derived-type read reaches the end of a record; `read_*` stops at the `k` part.
- ifx 2026.1: after a derived-type read of a record that starts with blanks, the next `read` statement on the unit fails (iostat 59).
- libgfortran leaks memory when a derived-type read hits end of record (an error path); the test for it is skipped on gfortran because the debug profile runs LeakSanitizer.
- ifx writes list-directed derived types without a separator; `write_*` starts list-directed output with a blank.
- The generated file goes through the C preprocessor (`[preprocess.cpp]` in fpm.toml turns it on everywhere, including ifx on Windows): no `/*` in comments.

## Commits

Commit as the maintainer, Will Klausler, with the GitHub no-reply address
`226649647+willklausler@users.noreply.github.com` (set in the repository's git config).
