# Firma estable de la APK

Android exige que todas las actualizaciones de una aplicación estén firmadas con la misma clave privada.

## 1. Crear la clave una sola vez

Desde PowerShell, con Java 17 instalado:

```powershell
.\scripts\crear-clave-firma.ps1
```

El script crea `crecemosuno-panopilot.jks` en la raíz local del proyecto. El archivo está excluido de Git.

Guarda tres elementos:

- El archivo JKS.
- La contraseña del almacén.
- El alias y la contraseña de la clave.

Mantén al menos dos copias privadas. Perder la clave significa perder la posibilidad de actualizar la aplicación instalada.

## 2. Compilar firmando localmente

Copia `keystore.properties.example` como `keystore.properties` y completa:

```properties
storeFile=C:/ruta/privada/crecemosuno-panopilot.jks
storePassword=CONTRASEÑA_ALMACEN
keyAlias=panopilot
keyPassword=CONTRASEÑA_CLAVE
```

Compila:

```powershell
gradle --no-daemon :app:assembleRelease
```

Resultado:

```text
app/build/outputs/apk/release/app-release.apk
```

## 3. Compilar una APK firmada en GitHub Actions

No subas nunca el JKS al repositorio público. Crea estos secretos en:

`Settings → Secrets and variables → Actions → New repository secret`

### ANDROID_KEYSTORE_BASE64

En PowerShell convierte la clave a Base64:

```powershell
[Convert]::ToBase64String(
    [IO.File]::ReadAllBytes("C:\ruta\crecemosuno-panopilot.jks")
) | Set-Clipboard
```

Pega el resultado completo como valor del secreto.

### Otros secretos

- `ANDROID_STORE_PASSWORD`: contraseña del almacén.
- `ANDROID_KEY_ALIAS`: normalmente `panopilot`.
- `ANDROID_KEY_PASSWORD`: contraseña de la clave.

Después ejecuta manualmente el flujo:

`Actions → Build signed release APK → Run workflow`

El artefacto `crecemosuno-panopilot-release` contendrá la APK firmada.

## Importante

La APK de depuración generada automáticamente sirve para validar el código, pero no debe utilizarse como canal estable de actualización. Las versiones que se distribuyan y actualicen deben proceder siempre de la misma clave JKS privada.
