# CrecemosUno PanoPilot
# Script PowerShell de referencia para la secuencia validada de 31 fotografías.
# Tablet Lenovo TB-J616F · 1200x2000 · aplicación Insta360 en vertical.
# Configuración de cámara: Foto · UHD 4:3 · 1x con gran angular · JPG + RAW.
# Antes de ejecutar, colocar manualmente la cámara mirando al centro.

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$adb = ".\adb.exe"

# Coordenadas calibradas
$joyX = 1056
$joyY = 1540
$leftX = 1012
$rightX = 1100
$upY = 1496
$downY = 1584
$shutterX = 600
$shutterY = 1832

# Tiempos calibrados
$moveMs = 500
$betweenMovesMs = 400
$saveSeconds = 7
$stabilizeSeconds = 5
$betweenPhotosSeconds = 2

# Recorrido horizontal validado para 9 fotos por fila
$stepsRight = @(2, 2, 2, 2, 2, 2, 3, 3)
$stepsLeft = @(3, 3, 2, 2, 2, 2, 2, 2)

$photoNumber = 0
$totalPhotos = 31

function Invoke-Swipe {
    param(
        [Parameter(Mandatory)] [int] $StartX,
        [Parameter(Mandatory)] [int] $StartY,
        [Parameter(Mandatory)] [int] $EndX,
        [Parameter(Mandatory)] [int] $EndY
    )

    & $adb shell input swipe $StartX $StartY $EndX $EndY $moveMs
    if ($LASTEXITCODE -ne 0) {
        throw "ADB no pudo ejecutar el movimiento."
    }
    Start-Sleep -Milliseconds $betweenMovesMs
}

function Move-Left {
    param([Parameter(Mandatory)] [int] $Count)
    1..$Count | ForEach-Object { Invoke-Swipe $joyX $joyY $leftX $joyY }
}

function Move-Right {
    param([Parameter(Mandatory)] [int] $Count)
    1..$Count | ForEach-Object { Invoke-Swipe $joyX $joyY $rightX $joyY }
}

function Move-Up {
    param([Parameter(Mandatory)] [int] $Count)
    1..$Count | ForEach-Object { Invoke-Swipe $joyX $joyY $joyX $upY }
}

function Move-Down {
    param([Parameter(Mandatory)] [int] $Count)
    1..$Count | ForEach-Object { Invoke-Swipe $joyX $joyY $joyX $downY }
}

function Take-Photo {
    param([Parameter(Mandatory)] [string] $Label)

    $script:photoNumber++
    Write-Host "Foto $script:photoNumber de $totalPhotos - $Label"

    & $adb shell input tap $shutterX $shutterY
    if ($LASTEXITCODE -ne 0) {
        throw "ADB no pudo pulsar el disparador."
    }

    Start-Sleep -Seconds $saveSeconds
}

function Capture-Row {
    param(
        [Parameter(Mandatory)] [string] $Name,
        [Parameter(Mandatory)] [ValidateSet("Right", "Left")] [string] $Direction,
        [Parameter(Mandatory)] [int[]] $Steps
    )

    for ($index = 0; $index -lt 9; $index++) {
        Take-Photo "$Name $($index + 1)/9"

        if ($index -lt 8) {
            $count = $Steps[$index]
            if ($Direction -eq "Right") {
                Move-Right $count
            }
            else {
                Move-Left $count
            }
            Start-Sleep -Seconds $betweenPhotosSeconds
        }
    }
}

if (-not (Test-Path $adb)) {
    throw "No se encuentra adb.exe. Ejecuta el script desde C:\platform-tools."
}

Write-Host ""
Write-Host "CRECEMOSUNO PANOPILOT - 31 FOTOGRAFIAS"
Write-Host "Coloca manualmente la camara mirando al centro."
Write-Host "La secuencia comenzara en 10 segundos."
Write-Host ""

& $adb devices
if ($LASTEXITCODE -ne 0) {
    throw "No se pudo ejecutar ADB."
}

Start-Sleep -Seconds 10

# 1. Fila central: extremo izquierdo y barrido izquierda -> derecha
Write-Host "Preparando fila central"
Move-Left 4
Start-Sleep -Seconds $stabilizeSeconds
Capture-Row "Central" "Right" $stepsRight

# 2. Fila superior +3: barrido derecha -> izquierda
Write-Host "Preparando fila superior +3"
Move-Up 3
Start-Sleep -Seconds $stabilizeSeconds
Capture-Row "Superior +3" "Left" $stepsLeft

# 3. Volver al centro horizontal y subir al límite mecánico
Write-Host "Preparando cenit"
Move-Right 4
Start-Sleep -Seconds 3
Move-Up 5
Start-Sleep -Seconds $stabilizeSeconds

# 4. Cuatro fotografías de cenit: -3, -1, +1 y +3
Move-Left 3
Start-Sleep -Seconds 3
Take-Photo "Cenit -3"

Move-Right 2
Start-Sleep -Seconds 3
Take-Photo "Cenit -1"

Move-Right 2
Start-Sleep -Seconds 3
Take-Photo "Cenit +1"

Move-Right 2
Start-Sleep -Seconds 3
Take-Photo "Cenit +3"

# 5. Fila inferior: desde +3, bajar 14 y mover 7 a la izquierda
Write-Host "Preparando fila inferior"
Move-Down 14
Move-Left 7
Start-Sleep -Seconds $stabilizeSeconds
Capture-Row "Inferior" "Right" $stepsRight

Write-Host ""
Write-Host "PROCESO TERMINADO"
Write-Host "Total de disparos enviados: $photoNumber"
Write-Host "Debes tener 31 JPG y 31 RAW."
