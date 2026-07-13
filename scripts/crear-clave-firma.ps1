param(
    [string]$OutputPath = "$PSScriptRoot\..\crecemosuno-panopilot.jks",
    [string]$Alias = "panopilot",
    [int]$ValidityDays = 10000
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command keytool -ErrorAction SilentlyContinue)) {
    throw "No se encuentra keytool. Instala Java 17 y añade su carpeta bin al PATH."
}

if (Test-Path $OutputPath) {
    throw "Ya existe el archivo: $OutputPath. No se sobrescribe para evitar perder la clave anterior."
}

$secureStorePassword = Read-Host "Contraseña del almacén JKS" -AsSecureString
$secureKeyPassword = Read-Host "Contraseña de la clave" -AsSecureString

$storePtr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureStorePassword)
$keyPtr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureKeyPassword)

try {
    $storePassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($storePtr)
    $keyPassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($keyPtr)

    & keytool `
        -genkeypair `
        -v `
        -keystore $OutputPath `
        -storetype JKS `
        -storepass $storePassword `
        -keypass $keyPassword `
        -alias $Alias `
        -keyalg RSA `
        -keysize 4096 `
        -validity $ValidityDays `
        -dname "CN=CrecemosUno PanoPilot, OU=CrecemosUno, O=CrecemosUno, L=Spain, C=ES"

    if ($LASTEXITCODE -ne 0) {
        throw "keytool terminó con el código $LASTEXITCODE."
    }

    Write-Host ""
    Write-Host "Clave creada correctamente:" -ForegroundColor Green
    Write-Host $OutputPath
    Write-Host ""
    Write-Host "Guárdala en al menos dos ubicaciones privadas y seguras." -ForegroundColor Yellow
    Write-Host "No la subas al repositorio ni la envíes por correo." -ForegroundColor Yellow
}
finally {
    if ($storePtr -ne [IntPtr]::Zero) {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($storePtr)
    }
    if ($keyPtr -ne [IntPtr]::Zero) {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($keyPtr)
    }
    Remove-Variable storePassword, keyPassword -ErrorAction SilentlyContinue
}
