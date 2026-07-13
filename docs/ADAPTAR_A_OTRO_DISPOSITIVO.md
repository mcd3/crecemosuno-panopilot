# Adaptar CrecemosUno PanoPilot a otro móvil o tablet

## Alcance actual

La versión actual está validada con una Lenovo TB-J616F en posición vertical y una pantalla real de 1200 × 2000 píxeles. El perfil controla la aplicación Insta360 mediante coordenadas de pantalla y gestos deterministas.

La aplicación escala las coordenadas de referencia de forma proporcional:

```text
x_nueva = x_referencia × ancho_nuevo / 1200
y_nueva = y_referencia × alto_nuevo / 2000
```

Este escalado puede funcionar en dispositivos con una proporción de pantalla y una interfaz muy similares, pero no garantiza compatibilidad. La aplicación Insta360 puede cambiar la posición del joystick, el disparador y otros controles según:

- Resolución y relación de aspecto.
- Densidad de pantalla.
- Barras de navegación y estado.
- Modelo y fabricante del dispositivo.
- Versión de Android.
- Versión de la aplicación Insta360.
- Cámara conectada y modo de captura seleccionado.

Por este motivo, cada dispositivo nuevo debe comprobarse y, cuando sea necesario, calibrarse.

## Perfil validado de referencia

```text
Pantalla: 1200 × 2000
Orientación: vertical
Centro joystick: 1056,1540
Izquierda: 1012,1540
Derecha: 1100,1540
Arriba: 1056,1496
Abajo: 1056,1584
Disparador: 600,1832
Duración del gesto: 500 ms
Espera entre gestos: 400 ms
Espera tras cada foto: 7 s
Estabilización entre filas: 5 s
Espera adicional entre fotos: 2 s
```

Secuencia horizontal validada:

```text
Derecha: 2,2,2,2,2,2,3,3
Izquierda: 3,3,2,2,2,2,2,2
```

## 1. Preparar el dispositivo

1. Instalar la aplicación Insta360 y conectar la cámara.
2. Activar las opciones de desarrollador y la depuración USB.
3. Colocar el dispositivo en vertical.
4. Configurar la cámara exactamente igual que en el perfil que se desea reproducir.
5. Desactivar temporalmente el giro automático de pantalla.
6. Evitar que aparezcan teclados, ventanas flotantes o notificaciones durante la calibración.

## 2. Obtener resolución y densidad

Desde la carpeta donde se encuentre `adb.exe`:

```powershell
.\adb.exe devices
.\adb.exe shell wm size
.\adb.exe shell wm density
```

Anotar el tamaño físico que devuelve Android. No debe confundirse con la resolución comercial anunciada por el fabricante.

## 3. Hacer una captura de referencia

Con la pantalla de control de la cámara abierta:

```powershell
.\adb.exe shell screencap -p /sdcard/panopilot_calibracion.png
.\adb.exe pull /sdcard/panopilot_calibracion.png .
```

Guardar la captura junto con el nombre del dispositivo, versión de Android y versión de Insta360.

## 4. Localizar las coordenadas

La forma más práctica es activar **Ubicación del puntero** en las opciones de desarrollador de Android. Al tocar la pantalla se muestran las coordenadas X e Y.

Anotar:

- Centro exacto del joystick.
- Punto final de un gesto hacia la izquierda.
- Punto final de un gesto hacia la derecha.
- Punto final de un gesto hacia arriba.
- Punto final de un gesto hacia abajo.
- Centro del botón disparador.

Formulario:

```text
Dispositivo:
Android:
Versión Insta360:
Ancho real:
Alto real:
Densidad:

JOY_X:
JOY_Y:
LEFT_X:
RIGHT_X:
UP_Y:
DOWN_Y:
SHUTTER_X:
SHUTTER_Y:
```

## 5. Verificar los gestos antes de disparar

No ejecutar inmediatamente la secuencia completa.

Orden recomendado:

1. Probar un único movimiento a la izquierda.
2. Probar un único movimiento a la derecha.
3. Probar un movimiento hacia arriba.
4. Probar un movimiento hacia abajo.
5. Probar un único disparo.
6. Comprobar que no se ha pulsado ningún control diferente.

Si un gesto cae fuera del joystick o el disparo no coincide con el botón, no continuar.

## 6. Calibrar el recorrido horizontal

1. Colocar manualmente la cámara en el centro.
2. Contar cuántos gestos iguales son necesarios para llegar al límite izquierdo.
3. Capturar una fila de prueba con suficiente solapamiento.
4. Ajustar el número de gestos entre fotografías.
5. Comprobar la fila en PTGui antes de continuar con el resto de la esfera.

La matriz horizontal no debe copiarse automáticamente de otro dispositivo. El comportamiento depende de cómo la aplicación interpreta la duración y el recorrido del gesto.

Registrar:

```text
Gestos centro → límite izquierdo:
Gestos entre foto 1 y 2:
Gestos entre foto 2 y 3:
Gestos entre foto 3 y 4:
Gestos entre foto 4 y 5:
Gestos entre foto 5 y 6:
Gestos entre foto 6 y 7:
Gestos entre foto 7 y 8:
Gestos entre foto 8 y 9:
```

## 7. Calibrar las filas verticales

Determinar por separado:

- Pasos desde la fila central hasta la fila superior.
- Pasos desde la fila superior hasta el límite mecánico superior.
- Posiciones horizontales necesarias para cerrar el cenit.
- Pasos desde el límite superior hasta la fila inferior.
- Desplazamiento horizontal necesario para iniciar la fila inferior.

Comprobar el resultado en PTGui. Un perfil se considera validado únicamente cuando la esfera queda completamente cubierta y con solapamiento suficiente.

## 8. Modificar el perfil en el código

Archivo principal:

```text
app/src/main/java/uno/crecemos/panopilot/PanoPilotAccessibilityService.java
```

Constantes que normalmente deben revisarse:

```java
REFERENCE_WIDTH
REFERENCE_HEIGHT
JOY_X
JOY_Y
LEFT_X
RIGHT_X
UP_Y
DOWN_Y
SHUTTER_X
SHUTTER_Y
MOVE_DURATION_MS
BETWEEN_MOVES_MS
SAVE_PHOTO_MS
STABILIZE_ROW_MS
BETWEEN_PHOTOS_MS
STEPS_RIGHT
STEPS_LEFT
```

También deben revisarse los movimientos de `runCaptureSequence()` cuando la mecánica vertical u horizontal sea diferente.

## 9. Compilar una APK de prueba

```powershell
gradle --no-daemon :app:assembleDebug
```

Resultado:

```text
app/build/outputs/apk/debug/app-debug.apk
```

Instalar:

```powershell
.\adb.exe install -r .\app-debug.apk
```

Cuando la firma sea distinta a la aplicación instalada, será necesario desinstalar primero el paquete anterior.

## 10. Validación final

Un nuevo dispositivo debe superar estas pruebas:

- El panel flotante no tapa el joystick ni el disparador.
- Todos los gestos se ejecutan dentro de los controles correctos.
- Se generan exactamente 31 disparos o el número definido por su perfil.
- Ninguna fotografía queda duplicada por falta de movimiento.
- Las filas mantienen solapamiento suficiente.
- PTGui cierra horizontalmente la esfera.
- El cenit queda cubierto.
- La fila inferior cubre la zona prevista.
- El dispositivo no entra en suspensión durante la captura.
- No aparecen avisos térmicos o de almacenamiento durante una secuencia normal.

## Recomendación de producto

Para convertir la aplicación en una solución compatible con muchos teléfonos, el siguiente desarrollo debería ser un **asistente de calibración** dentro de la propia app. El usuario tocaría el joystick, las cuatro direcciones y el disparador; después introduciría los pasos de cada fila. La aplicación guardaría perfiles independientes por dispositivo, cámara y versión de Insta360.

Hasta disponer de ese asistente, cada nuevo dispositivo debe venderse o entregarse como una configuración validada expresamente, no como compatibilidad universal.
