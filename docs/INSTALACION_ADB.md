# Instalación mediante ADB

Con la tablet conectada y la depuración USB autorizada:

```powershell
.\adb.exe devices
.\adb.exe install -r .\CrecemosUno_PanoPilot.apk
```

Cuando la firma o el identificador de paquete no coincidan con una instalación anterior, será necesario desinstalar primero esa versión.
