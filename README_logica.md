# Lógica de recomendaciones

Este módulo clasifica la frecuencia cardíaca del usuario en una categoría clínica según su edad, y devuelve una recomendación de seguimiento.

## Rangos de FC en reposo usados

| Grupo | Edad | Rango normal (BPM) |
|---|---|---|
| Adolescentes | < 18 años | 70 – 110 |
| Adultos | 18 – 60 años | 60 – 100 |
| Adultos mayores | > 60 años | 60 – 95 |

## Categorías

- **Normal**: BPM dentro del rango → mensaje positivo, color verde.
- **Bradicardia**: BPM por debajo del rango → recomienda consulta si hay síntomas, color naranja.
- **Taquicardia**: BPM por encima del rango → recomienda descansar y volver a medir, color naranja.
- **Desconocido**: sin señal o electrodos desconectados, color gris.

## Función pública

```dart
Recommendation.getMessage(
  bpm: 75,
  age: 25,
  leadOn: true,
);
// "Frecuencia cardiaca normal para tu edad. Sigue asi!"

Recommendation.classify(45, 25);
// HeartRateCategory.bradicardia
```

## Justificación

Los rangos están basados en los valores de referencia comunes para adultos sanos en reposo. Para un producto clínico real estos rangos se ajustarían con guías específicas (American Heart Association, etc.), pero para el alcance del taller son suficientes.

## Ideas de mejora a futuro

- Considerar el sexo del usuario (las mujeres suelen tener FC en reposo ligeramente mayor).
- Considerar nivel de actividad física (atletas pueden tener FC < 60 sin patología).
- Añadir alertas si el BPM cambia rápidamente entre mediciones consecutivas.
