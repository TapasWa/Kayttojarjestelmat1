
- reverse — simple line-reversing utility

Overview
--------

`reverse` reads lines from stdin or a specified input file and prints them
in reverse order to stdout or a specified output file.

Build
-----

Run `make` (or compile with `gcc`) to build the `reverse` executable:

        make

Usage
-----

        ./reverse
        ./reverse input.txt
        ./reverse input.txt output.txt

Behavior and Error Handling
---------------------------

- If input and output filenames are the same: prints exactly
    "Input and output file must differ" to `stderr` and exits with code 1.
- If an input or output file cannot be opened: prints exactly
    `error: cannot open file 'name'` to `stderr` and exits with code 1.
- If `malloc` fails: prints `malloc failed` to `stderr` and exits with code 1.
- If too many arguments are passed: prints `usage: reverse` to `stderr`
    and exits with code 1.

Notes
-----

- Lines of arbitrary length are supported via `getline` or a provided
    portable fallback for Windows.
- The implementation buffers all lines in memory before printing in
    reverse order. For extremely large files this may exhaust RAM.

Repository
----------

https://github.com/TapasWa/Kayttojarjestelmat1

Files to include in the repository
---------------------------------

- `reverse.c` — source
- `Makefile` — build
- `README.md` — this file
- `run_tests.ps1` — optional test script (Windows)
-------------------------------------------

- Lines of arbitrary length are supported using `getline` or the
    provided portable replacement on Windows.
- The implementation stores all lines in memory before printing them in
    reverse order. This satisfies the assignment but means extremely large
    files may exhaust available memory. Alternatives (not implemented):
    - Use a temporary file to record offsets and then read them in
        reverse order.
    - Use external sort-style chunking to avoid full-memory buffering.

What I changed / added for submission
-------------------------------------

- `reverse.c` — commented, portable, and matches required error strings.
- `Makefile` — builds `reverse` with `gcc`.
- `README.md` — detailed usage, assumptions, and test instructions.
- `sample_input.txt` and `sample_expected.txt` — example for testing.
- `run_tests.ps1` — runs the three invocation modes and writes outputs
    to files you can screenshot for submission.
- `submission_summary.md` — a template summary you can copy into the
    final PDF submission.

Repository
----------

This project is available at: https://github.com/TapasWa/Kayttojarjestelmat1

Please push your final changes to the above repository and include its
public URL in your submission PDF.

Next steps for submission
------------------------

- Run `run_tests.ps1` and capture screenshots of the program output.
- Add comments to the source if you want more inline explanation.
- Initialize a git repository, commit these files, and push to a public
    GitHub repository. Include the repository URL in your submission PDF.

