# Pinout del hardware

## AD8232 → Arduino UNO

| Pin AD8232 | Pin Arduino |
|---|---|
| OUTPUT | A0 |
| LO+ | D10 |
| LO- | D11 |
| 3.3V | 3.3V |
| GND | GND |

## HC-05 → Arduino UNO

| Pin HC-05 | Pin Arduino |
|---|---|
| VCC | 5V |
| GND | GND |
| TXD | D2 |
| RXD | D3 (con divisor 1kΩ / 2kΩ) |

## Divisor de tensión obligatorio

El RX del HC-05 acepta máximo 3.3V, pero el TX del Arduino UNO da 5V. Si los conectas directo, **se quema el HC-05**.

```
  D3 (Arduino) ---[1kΩ]---+---[2kΩ]--- GND
                          |
                       RX (HC-05)
```

Esto baja los 5V a aproximadamente 3.3V.

## Electrodos

Conectar los 3 cables del AD8232 a los electrodos del paciente:
- **RA** (rojo): brazo derecho
- **LA** (amarillo): brazo izquierdo
- **RL** (verde): pierna derecha (referencia)

## Notas

- Velocidad serial del HC-05: **9600 baudios** por defecto.
- Cuando se carga el sketch al Arduino, **desconectar el cable RX del Arduino del HC-05** o la carga falla porque el HC-05 mete ruido al puerto serial. (Aunque usamos SoftwareSerial en D2/D3, vale la pena hacerlo por seguridad).
- El umbral de detección de pico R (`threshold = 550` en el código) **se calibra con la señal real**. Probar valores entre 480-580.
