Submission summary template

Name: 
Student ID: 
Repository URL: 

Summary of work:
- Implemented `reverse` in C. Supports stdin, file->stdout, and file->file modes.
- Includes error handling for same input/output, file open failures, malloc failures, and too many args.

Files to include in repository:
- reverse.c
- Makefile
- README.md
- sample_input.txt
- sample_expected.txt
- run_tests.ps1

Testing performed:
- Ran program in three modes and compared outputs to expected.
- Verified error messages and exit codes for failure cases.

Assumptions and limitations:
- Program buffers all lines in memory. For very large files this may exhaust memory.
- Portable `getline` fallback provided for Windows.

Notes for graders:
- The code compiles on Windows (MinGW/msys) and POSIX systems.
- For extra credit, I can implement a streaming/temporary-file based reverse if required.
