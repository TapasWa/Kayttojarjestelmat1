# Run reverse in three modes and save outputs for screenshots
$proj = "c:\Users\Tapsa\OneDrive\Käyttöjärjestelmät\Project 1 Warmup to C and Unic programming"
Push-Location $proj
if (Test-Path .\reverse) { Remove-Item .\reverse -Force }
# Build
gcc -std=c11 -Wall -Wextra reverse.c -o reverse
# Mode 1: stdin -> stdout
Get-Content sample_input.txt | .\reverse | Out-File output_mode1.txt -Encoding utf8
# Mode 2: input file -> stdout
.\reverse sample_input.txt | Out-File output_mode2.txt -Encoding utf8
# Mode 3: input file -> output file
.\reverse sample_input.txt output_mode3.txt
# Record exit codes
"mode1_exit=$LASTEXITCODE" | Out-File test_results.txt -Encoding utf8
# Save expected
Get-Content sample_expected.txt | Out-File expected.txt -Encoding utf8
Pop-Location
Write-Host "Tests completed. Output files: output_mode1.txt, output_mode2.txt, output_mode3.txt, expected.txt"
