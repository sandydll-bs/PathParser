Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$fileInput = New-Object System.Windows.Forms.OpenFileDialog
$fileInput.Filter = "Text Files (*.txt)|*.txt"

if ($fileInput.ShowDialog() -ne "OK") {
    exit
}

$inputPath = $fileInput.FileName

if (-not (Test-Path $inputPath)) {
    [System.Windows.Forms.MessageBox]::Show(
        "File non trovato.",
        "Errore",
        "OK",
        "Error"
    )
    exit
}

function ControllaStato {
    param([string]$fileInput)
    if (-not (Test-Path -Path $fileInput -PathType Leaf)) {
        return "Not Found"
    }
    try {
        $sig =
            Get-AuthenticodeSignature `
            -FilePath $fileInput `
            -ErrorAction Stop
        if ($sig.Status -eq "Valid") {
            return "Signed"
        }
        return "Unsigned"
    }
    catch {
        return "Unsigned"
    }
}

function ElaboraPath {
    $results =
        [System.Collections.Generic.List[Object]]::new()
    $content =
        Get-Content $inputPath
    $total =
        $content.Count
    $i = 0
    foreach ($line in $content) {
        $i++
        Write-Progress `
            -Activity "Analisi file in corso..." `
            -Status "Elaborazione riga $i di $total" `
            -PercentComplete (($i / $total) * 100)
        $percorsoCorrente =
            $line.Trim()
        if ([string]::IsNullOrWhiteSpace($percorsoCorrente)) {
            continue
        }
        $statoFile =
            ControllaStato `
            -fileInput $percorsoCorrente
        $timestamp = "-"
        if (Test-Path $percorsoCorrente) {
            try {
                $timestamp =
                    (Get-Item $percorsoCorrente).LastWriteTime.
                    ToString("yyyy-MM-dd HH:mm:ss")
            }
            catch {}
        }
        $results.Add([PSCustomObject]@{
            Percorso  = $percorsoCorrente
            Timestamp = $timestamp
            Signature = $statoFile
        })
    }
    return $results
}

$risultati = @(ElaboraPath)

if ($risultati.Count -gt 0) {
    $risultati |
    Out-GridView `
    -Title "Paths Parser - DS: @imsandy.dll"
}
else {
    Write-Host `
    "Nessun dato estratto." `
    -ForegroundColor Yellow
}