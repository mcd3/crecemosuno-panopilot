# CrecemosUno PanoPilot

Aplicación Android para automatizar la captura de panoramas esféricos de alta resolución mediante los controles en pantalla de la aplicación Insta360.

Desarrollada y validada inicialmente con:

- Tablet Lenovo TB-J616F en vertical, resolución 1200 × 2000.
- Cámara Insta360 conectada desde su aplicación Android.
- Modo Foto · UHD 4:3 · objetivo 1× con el accesorio físico gran angular · JPG + RAW.
- Procesado posterior en PTGui.

Web: https://crecemos.uno

## Requisito obligatorio: accesorio gran angular

Para que la secuencia validada de 31 fotografías cubra correctamente toda la esfera, la cámara debe utilizar el **accesorio físico gran angular que viene incluido con la cámara**.

No basta con seleccionar un modo digital de gran angular en la aplicación. El accesorio debe estar colocado físicamente en la óptica antes de comenzar la captura y la aplicación Insta360 debe configurarse en **1×**.

Sin este accesorio, el campo de visión es menor y las filas pueden no tener suficiente solapamiento; en ese caso, PTGui puede no cerrar correctamente el panorama 360.

Configuración validada:

```text
Foto · UHD 4:3 · 1× · accesorio físico gran angular instalado · JPG + RAW
```

## Muestra real en interior

Se incluye una muestra de captura realizada en interior con la secuencia automatizada de 31 fotografías y el accesorio físico gran angular instalado.

[Ver muestra interior en Google Drive](https://drive.google.com/drive/folders/1pm2fcEH9XNV4lcs1A8Ac_v6Q4zFPY4oP?usp=sharing)

La carpeta permite revisar los archivos de ejemplo y comprobar el resultado obtenido antes del montaje o durante las pruebas en PTGui.

## Proyecto abierto y gratuito

CrecemosUno PanoPilot se comparte públicamente para que cualquier persona pueda usarlo, estudiarlo, modificarlo y adaptarlo a otros dispositivos.

El proyecto se distribuye con licencia **MIT**. Deben conservarse el aviso de copyright y el texto de la licencia cuando se copie o redistribuya una parte sustancial del software.

No es una aplicación oficial de Insta360 ni existe vinculación comercial con dicha marca.

## Aviso importante

Este es un proyecto experimental ofrecido **sin garantía**. Se ha validado inicialmente con la Lenovo TB-J616F, resolución real de 1200 × 2000, y la configuración de cámara indicada en este documento.

El uso en otro teléfono, tablet, versión de Android o versión de la aplicación Insta360 puede requerir una calibración específica. Cada usuario es responsable de comprobar los movimientos antes de realizar una sesión completa y de vigilar la temperatura, el almacenamiento y el funcionamiento del equipo.

## Compatibilidad

La versión actual está validada únicamente con el equipo y la configuración indicados. Las coordenadas se escalan proporcionalmente desde 1200 × 2000, pero un móvil con otra relación de aspecto, densidad o distribución de la interfaz Insta360 puede necesitar una calibración propia.

Manual completo para adaptar y validar otro teléfono o tablet:

```text
docs/ADAPTAR_A_OTRO_DISPOSITIVO.md
```

Hasta disponer de un asistente de calibración dentro de la aplicación, no debe anunciarse como compatible de forma universal con cualquier dispositivo Android.

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
5. Colocar físicamente en la cámara el accesorio gran angular incluido con ella.
6. Abrir Insta360 y conectar la cámara.
7. Configurar Foto · UHD 4:3 · 1× · JPG + RAW.
8. Colocar manualmente la cámara mirando al centro.
9. Mostrar el panel flotante y pulsar **INICIAR**.

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

## Licencia

Este proyecto se distribuye bajo la licencia MIT. Consulta el archivo [`LICENSE`](LICENSE).

## Estado

Beta funcional validada sobre Lenovo TB-J616F. Las coordenadas se escalan proporcionalmente desde la resolución de referencia 1200 × 2000.

© 2026 José Alfonso Benito Guerras / CrecemosUno · https://crecemos.uno