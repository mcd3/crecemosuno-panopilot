# CrecemosUno PanoPilot

Aplicación Android para automatizar la captura de panoramas esféricos de alta resolución mediante los controles en pantalla de la aplicación Insta360.

Desarrollada y validada inicialmente con:

- Tablet Lenovo TB-J616F en vertical, resolución 1200 × 2000.
- Cámara Insta360 conectada desde su aplicación Android.
- Modo Foto · UHD 4:3 · objetivo 1× con gran angular · JPG + RAW.
- Procesado posterior en PTGui.

Web: https://crecemos.uno

## Secuencia validada

La captura completa realiza 31 fotografías:

1. 9 fotografías en la fila central.
2. 9 fotografías en la fila superior, tras subir 3 pasos.
3. 4 fotografías de cenit en las posiciones horizontales −3, −1, +1 y +3.
4. 9 fotografías en la fila inferior.

La secuencia cubre la esfera completa con el montaje y la configuración indicados.

## Funciones

- Control flotante sobre la aplicación Insta360.
- Iniciar captura.
- Pausar y continuar.
- Detener la secuencia.
- Cuenta atrás de 10 segundos.
- Progreso de 0 a 31 fotografías.
- Mantiene la pantalla activa durante la captura.
- No utiliza el botón de centrado de la cámara.
- Enlace directo a crecemos.uno.

## Instalación y uso

1. Instalar la APK.
2. Abrir **CrecemosUno PanoPilot**.
3. Pulsar **Activar accesibilidad**.
4. Activar **Control CrecemosUno PanoPilot**.
5. Abrir Insta360 y conectar la cámara.
6. Configurar Foto · UHD 4:3 · 1× con gran angular · JPG + RAW.
7. Colocar manualmente la cámara mirando al centro.
8. Mostrar el panel flotante y pulsar **INICIAR**.

## APK

La APK no debe guardarse dentro del código fuente del repositorio. GitHub Actions la compila y la deja como artefacto descargable de cada ejecución.

Para distribuir una versión estable, la APK firmada debe publicarse en **Releases**, acompañada de su número de versión y notas de cambios. La clave privada de firma nunca debe subirse al repositorio.

## Script PowerShell final

El script ADB validado se conserva como referencia y sistema alternativo en:

```text
scripts/CrecemosUno-PanoPilot-31-fotos.ps1
```

Debe ejecutarse desde `C:\platform-tools`, con `adb.exe` disponible y la tablet conectada:

```powershell
.\CrecemosUno-PanoPilot-31-fotos.ps1
```

El script reproduce exactamente la misma secuencia validada de 31 fotografías que la aplicación Android.

## Compilación local

Requiere Java 17 y Android SDK 35.

```powershell
gradle --no-daemon :app:assembleDebug
```

La APK de depuración se genera en:

```text
app/build/outputs/apk/debug/app-debug.apk
```

## Firma estable

Las APK de Android solo pueden actualizar una instalación existente cuando están firmadas con la misma clave. No debe publicarse una clave privada en el repositorio.

El proyecto admite una firma privada mediante un archivo local `keystore.properties`, excluido de Git:

```properties
storeFile=C:/ruta/privada/crecemosuno-panopilot.jks
storePassword=CAMBIAR
keyAlias=panopilot
keyPassword=CAMBIAR
```

Copia `keystore.properties.example` como `keystore.properties`, completa los datos y compila:

```powershell
gradle --no-daemon :app:assembleRelease
```

Conserva siempre el archivo JKS y sus contraseñas. Sin esa clave no será posible publicar actualizaciones compatibles.

## Seguridad y privacidad

El servicio de accesibilidad se utiliza exclusivamente para reproducir los gestos calibrados del joystick y del disparador. La aplicación no solicita acceso a Internet, no lee textos, contraseñas ni contenido de otras aplicaciones y no recopila datos.

## Estado

Beta funcional validada sobre Lenovo TB-J616F. Las coordenadas se escalan proporcionalmente desde la resolución de referencia 1200 × 2000.

© CrecemosUno · https://crecemos.uno
