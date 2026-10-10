# Contributing

Bug reports, questions and pull requests are welcome.

- **Bugs and questions:** open an [issue](https://github.com/willklausler/fortran_quaternions/issues) with the compiler, its version, the operating system, and a minimal program.
- **Pull requests:** fork, branch, and open a PR against `main`. CI must pass.

Before opening a PR:

1. Edit the templates in `tmpl/`, not the generated `src/quaternions.F90` or `test/test_quaternions.F90`.
2. Run `make generate` (needs `pip install fypp==3.3`) and commit the generated files too.
3. Add tests for every change; run `fpm test --profile debug` and `fpm test --profile release`.
4. Document new or changed public procedures in `llms.txt`, `man/quaternions.3` and `CHANGELOG.md`; `python3 tools/check_docs.py` must pass.

[AGENTS.md](AGENTS.md) describes the layout, conventions and compiler quirks in detail; it applies to human contributors too.
