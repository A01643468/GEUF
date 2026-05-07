# Guía: cómo correrlo en Android Studio

## Paso 0: ensamblar el proyecto

El código está dividido por integrante. Antes de correr, hay que copiar todos los archivos `.dart` a `flutter_app/lib/`.

Desde la raíz del repo:

**Linux/Mac:**
```bash
bash docs/ensamblar.sh
```

**Windows:**
```bash
docs\ensamblar.bat
```

Esto deja todos los archivos en `flutter_app/lib/`.

## Paso 1: crear el proyecto Flutter en Android Studio

Hay dos opciones:

### Opción A: abrir directamente la carpeta
1. **File → Open** → seleccionar la carpeta `flutter_app/`.
2. Android Studio detecta que es un proyecto Flutter incompleto (le faltan las carpetas `android/` e `ios/`).
3. Para generarlas, en la terminal:
   ```bash
   cd flutter_app
   flutter create .
   ```
   Esto NO sobreescribe los archivos `lib/` ni el `pubspec.yaml`.

### Opción B: crear desde cero y copiar
1. **File → New → New Flutter Project** → `heart_monitor_app`.
2. Reemplazar el `pubspec.yaml` y los archivos de `lib/` con los del repo.

## Paso 2: permisos de Android

Abrir `android/app/src/main/AndroidManifest.xml` y agregar **antes del `<application>`:**

```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

En `android/app/build.gradle`, asegurarse:
```gradle
defaultConfig {
    minSdkVersion 21
}
```

## Paso 3: instalar dependencias

```bash
flutter pub get
```

## Paso 4: correr en el emulador

1. **Tools → Device Manager → Create Virtual Device**.
2. Elige cualquier Pixel con Android 11+.
3. Inicia el emulador.
4. Run ▶.
5. La app abre en **Modo Demo** y muestra la señal ECG simulada.

## Paso 5 (opcional): probar con el HC-05 en celular real

1. Activa Opciones de Desarrollador y Depuración USB en el celular.
2. Conecta el celular por USB.
3. Empareja el HC-05 desde los ajustes de Bluetooth del celular (PIN `1234` o `0000`).
4. En Android Studio elige el celular como dispositivo y Run ▶.
5. En la app, mueve el switch a **Modo Bluetooth** y elige el HC-05.

## Errores comunes

| Error | Solución |
|---|---|
| `Could not find lib/main.dart` | Olvidaste correr el script de ensamble. Corre `bash docs/ensamblar.sh` |
| Lista de Bluetooth vacía en celular | El HC-05 no está emparejado. Empareja primero desde los ajustes del celular. |
| Permisos de Bluetooth en Android 12+ | Acepta los permisos cuando la app los pida. Si no aparecen, revisa el `AndroidManifest.xml`. |
| El emulador no tiene Bluetooth | Es normal. Usa modo Demo en el emulador. |
