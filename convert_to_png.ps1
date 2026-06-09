Add-Type -AssemblyName System.Drawing

function TextToPng($infile, $outfile, $caption) {
    if (-not (Test-Path $infile)) { Write-Error "Input file $infile not found"; return }
    $text = Get-Content $infile -Raw
    $lines = $text -split "\r?\n"
    $font = New-Object System.Drawing.Font("Consolas",14)

    # Temporary bitmap to measure sizes
    $tmpBmp = New-Object System.Drawing.Bitmap 1,1
    $g = [System.Drawing.Graphics]::FromImage($tmpBmp)
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias

    $maxWidth = 0
    foreach ($line in $lines) {
        $size = $g.MeasureString($line, $font)
        $w = [int][math]::Ceiling($size.Width)
        if ($w -gt $maxWidth) { $maxWidth = $w }
    }
    $lineHeight = [int][math]::Ceiling($g.MeasureString("A", $font).Height)
    $g.Dispose()
    $tmpBmp.Dispose()

    $padding = 10
    $width = [Math]::Max(200, $maxWidth + $padding * 2)
    $height = [Math]::Max(40, $lineHeight * ($lines.Count) + $padding * 2)

    $bmp = New-Object System.Drawing.Bitmap $width, $height
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::White)
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    $brush = [System.Drawing.Brushes]::Black

    # draw caption (bold)
    if ($caption) {
        $capFont = New-Object System.Drawing.Font("Consolas",16,[System.Drawing.FontStyle]::Bold)
        $g.DrawString($caption, $capFont, $brush, [float]$padding, [float]5)
        $y = $padding + $lineHeight + 10
    } else {
        $y = $padding
    }
    foreach ($line in $lines) {
        $g.DrawString($line, $font, $brush, [float]$padding, [float]$y)
        $y += $lineHeight
    }

    $bmp.Save($outfile, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
}

# Files to convert
$proj = "c:\Users\Tapsa\OneDrive\Käyttöjärjestelmät\Project 1 Warmup to C and Unic programming"
Set-Location $proj

# Ensure program exists
if (-not (Test-Path .\reverse)) {
    gcc -std=c11 -Wall -Wextra reverse.c -o reverse
}

# Create outputs
Get-Content sample_input.txt | .\reverse | Out-File output_mode1.txt -Encoding utf8
.\reverse sample_input.txt | Out-File output_mode2.txt -Encoding utf8
.\reverse sample_input.txt output_mode3.txt

# Error cases
.\reverse sample_input.txt sample_input.txt 2> error_samefile.txt
.\reverse nofile.txt 2> error_nofile.txt
.\reverse a b c 2> error_toomany.txt

# Convert a list of text files to PNG

$mapping = @{
    'output_mode1.txt' = 'Mode 1: stdin -> stdout (piped input)'
    'output_mode2.txt' = 'Mode 2: input file -> stdout'
    'output_mode3.txt' = 'Mode 3: input file -> output file'
    'expected.txt' = 'Expected output (sample_expected.txt)'
    'error_samefile.txt' = 'Error: input and output are the same'
    'error_nofile.txt' = 'Error: input file does not exist'
    'error_toomany.txt' = 'Error: too many arguments (usage)'
}

foreach ($kv in $mapping.GetEnumerator()) {
    $f = $kv.Key
    $cap = $kv.Value
    if (Test-Path $f) {
        $png = [System.IO.Path]::ChangeExtension($f,'png')
        TextToPng $f $png $cap
        Write-Host "Created $png"
    }
}

Write-Host "Done"
