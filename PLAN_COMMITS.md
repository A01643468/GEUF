# Plan de commits por integrante

Cada integrante trabaja **EXCLUSIVAMENTE en su propia carpeta**. Así no hay conflictos y el profesor ve clarísimo quién contribuyó qué desde la pestaña "Insights → Contributors" de GitHub.

## Reglas de oro

1. **Cada uno toca SOLO su carpeta** (`integrante1_hardware/`, `integrante2_comunicacion/`, etc.).
2. Cada uno configura Git con su correo de GitHub real:
   ```bash
   git config user.name "Tu Nombre"
   git config user.email "tu-correo@github.com"
   ```
3. **Antes de cada `git push`**, hagan `git pull origin main`.
4. Repartan los commits en **3-4 días distintos** para que se vea progreso real.

---

## Setup inicial (una sola persona, una vez)

```bash
git init
git add README.md
git commit -m "Initial commit: estructura del proyecto"
git branch -M main
git remote add origin https://github.com/USUARIO/heart_monitor_app.git
git push -u origin main
```

Después invitan a los otros 3 como colaboradores en **Settings → Collaborators**.

---

## Integrante 1 — `integrante1_hardware/`

**Commit 1** – sube el código Arduino base
```bash
git add integrante1_hardware/ecg_bluetooth.ino
git commit -m "feat(arduino): codigo base AD8232 + UNO + HC-05"
git push origin main
```

**Commit 2** – ajusta el umbral de detección de pico R
```bash
# Edita threshold en ecg_bluetooth.ino (ej: 550 -> 500)
git add integrante1_hardware/ecg_bluetooth.ino
git commit -m "fix(arduino): ajuste de umbral de pico R a 500"
git push origin main
```

**Commit 3** – documentación del pinout
```bash
git add integrante1_hardware/PINOUT.md
git commit -m "docs(hardware): pinout y divisor de tension del HC-05"
git push origin main
```

---

## Integrante 2 — `integrante2_comunicacion/`

**Commit 1** – interfaz común y modo demo
```bash
git add integrante2_comunicacion/data_source.dart integrante2_comunicacion/demo_source.dart
git commit -m "feat(comunicacion): interfaz EcgDataSource y DemoSource"
git push origin main
```

**Commit 2** – fuente Bluetooth
```bash
git add integrante2_comunicacion/bluetooth_source.dart
git commit -m "feat(comunicacion): conexion al HC-05 con flutter_bluetooth_serial"
git push origin main
```

**Commit 3** – mejora la onda PQRST simulada
```bash
git add integrante2_comunicacion/demo_source.dart
git commit -m "fix(comunicacion): mejor forma de onda PQRST y variabilidad de BPM"
git push origin main
```

---

## Integrante 3 — `integrante3_ui/`

**Commit 1** – pantalla principal con gráfica
```bash
git add integrante3_ui/main.dart integrante3_ui/home_screen.dart
git commit -m "feat(ui): pantalla principal con grafica ECG y BPM"
git push origin main
```

**Commit 2** – pantalla de perfil
```bash
git add integrante3_ui/profile_screen.dart
git commit -m "feat(ui): pantalla de perfil con datos demograficos"
git push origin main
```

**Commit 3** – switch entre demo y bluetooth
```bash
git add integrante3_ui/home_screen.dart
git commit -m "feat(ui): switch para alternar entre demo y bluetooth"
git push origin main
```

---

## Integrante 4 — `integrante4_logica/` y `docs/`

**Commit 1** – lógica de clasificación
```bash
git add integrante4_logica/recommendation.dart
git commit -m "feat(logica): clasificacion de FC segun edad"
git push origin main
```

**Commit 2** – documentación de rangos clínicos
```bash
git add integrante4_logica/README_logica.md
git commit -m "docs(logica): rangos de FC y justificacion clinica"
git push origin main
```

**Commit 3** – sube mockups
```bash
git add docs/mockups/
git commit -m "docs: mockups de las pantallas en FlutterFlow"
git push origin main
```

**Commit 4** – sube video demostrativo
```bash
git add docs/video/demo.mp4
git commit -m "docs: video demostrativo del sistema funcionando"
git push origin main
```

---

## Verificación final

Antes de entregar, vayan a GitHub → repo → **Insights → Contributors**.

Deben aparecer **los 4 nombres** con sus respectivos commits y porcentajes balanceados. Si alguien no aparece, casi seguro fue porque tenía mal configurado el `user.email` en Git. Solución: revisar con `git log --pretty=format:"%an <%ae>"` y, si hace falta, ese integrante hace algunos commits extra con su correo bien configurado.

---

## Para el video demostrativo

El documento del profesor pide un video que muestre la integración del hardware con el software. Sugerencia:

1. **(0-15s)** App abriendo en el emulador en **modo Demo** — gráfica y BPM moviéndose.
2. **(15-30s)** App instalada en celular real con switch en **modo Bluetooth**.
3. **(30-60s)** Mostrar el armado físico: Arduino + AD8232 + electrodos + HC-05.
4. **(60-90s)** App conectándose al HC-05 y graficando la señal ECG real del paciente.
5. **(90s+)** Cambiar la edad en el perfil y ver cómo cambia la recomendación.
