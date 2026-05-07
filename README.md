# Heart Monitor App – Monitor de Frecuencia Cardíaca con AD8232

Aplicación móvil desarrollada en **Flutter** (Android Studio) que muestra en tiempo real la señal ECG y la frecuencia cardíaca (BPM) adquirida desde un sensor **AD8232** conectado a un **Arduino UNO**, transmitida por **Bluetooth Clásico** mediante un módulo **HC-05**.

## Modos de la app

- **Modo Demo**: genera datos ECG sintéticos para probar la app en el emulador de Android Studio.
- **Modo Bluetooth**: se conecta al HC-05 cuando se instala en un celular real con el hardware armado.

## Arquitectura del sistema

```
[ Electrodos ] → [ AD8232 ] → [ Arduino UNO ] → [ HC-05 ] → Bluetooth → [ App Flutter ]
```

| Componente | Función |
|---|---|
| AD8232 | Acondiciona la señal ECG (filtra y amplifica) |
| Arduino UNO | Lee la señal analógica, calcula BPM y la envía al HC-05 |
| HC-05 | Módulo Bluetooth Clásico (SPP) que transmite por serial |
| Flutter App | Recibe los datos, los grafica y emite recomendaciones |

## Variables y medio de transmisión

- **Variables**: voltaje ECG (0-1023 ADC), BPM, estado de electrodos
- **Medio**: Bluetooth Clásico (SPP) vía HC-05
- **Microcontrolador**: Arduino UNO (ATmega328P)

## Estructura del repositorio

El repo está organizado **por integrante**, para que cada uno haga sus commits sobre sus propios archivos sin conflictos:

```
heart_monitor_app/
├── integrante1_hardware/        # NOMBRE INTEGRANTE 1
│   ├── ecg_bluetooth.ino        # Codigo del Arduino UNO
│   └── PINOUT.md                # Conexiones del hardware
│
├── integrante2_comunicacion/    # NOMBRE INTEGRANTE 2
│   ├── data_source.dart         # Interfaz comun
│   ├── demo_source.dart         # Generador de datos sinteticos
│   └── bluetooth_source.dart    # Conexion al HC-05
│
├── integrante3_ui/              # NOMBRE INTEGRANTE 3
│   ├── main.dart                # Entrada de la app
│   ├── home_screen.dart         # Pantalla principal con grafica
│   └── profile_screen.dart      # Pantalla de perfil
│
├── integrante4_logica/          # NOMBRE INTEGRANTE 4
│   ├── recommendation.dart      # Logica de recomendaciones segun edad
│   └── README_logica.md         # Explicacion de los rangos clinicos
│
├── flutter_app/                 # Proyecto Flutter ensamblado
│   ├── lib/                     # Aqui se copian los .dart de cada integrante
│   └── pubspec.yaml
│
├── docs/
│   ├── GUIA_ANDROID_STUDIO.md
│   ├── PLAN_COMMITS.md
│   ├── mockups/
│   └── video/
│
└── README.md
```

## Cómo se ensambla

Cada integrante trabaja en su carpeta. Cuando todos terminan, **los archivos `.dart` se copian a `flutter_app/lib/`** para compilar el proyecto. Esto se puede hacer manual o con un script (incluido en `docs/ensamblar.sh`).

## Integrantes

| Carpeta | Integrante | Rol |
|---|---|---|
| `integrante1_hardware/` | _NOMBRE_ | Arduino + AD8232 + HC-05 |
| `integrante2_comunicacion/` | _NOMBRE_ | Modo Demo y Bluetooth |
| `integrante3_ui/` | _NOMBRE_ | Pantallas Flutter |
| `integrante4_logica/` | _NOMBRE_ | Recomendaciones clínicas y mockups |

Reemplazar `_NOMBRE_` con el nombre real antes de la entrega.
