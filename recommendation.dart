import 'package:flutter/material.dart';

/// Categoria de la frecuencia cardiaca segun BPM y edad
enum HeartRateCategory {
  normal,
  bradicardia,
  taquicardia,
  desconocido,
}

extension HeartRateCategoryExtension on HeartRateCategory {
  Color get color {
    switch (this) {
      case HeartRateCategory.normal:
        return Colors.green;
      case HeartRateCategory.bradicardia:
      case HeartRateCategory.taquicardia:
        return Colors.orange;
      case HeartRateCategory.desconocido:
        return Colors.grey;
    }
  }
}

/// Logica clinica para clasificar y recomendar segun BPM y edad
class Recommendation {
  /// Rango normal de FC en reposo segun edad
  static (int min, int max) _rangeForAge(int age) {
    if (age < 18) return (70, 110);   // adolescentes
    if (age > 60) return (60, 95);    // adultos mayores
    return (60, 100);                 // adultos
  }

  /// Clasifica el BPM en una categoria
  static HeartRateCategory classify(int bpm, int age) {
    if (bpm == 0) return HeartRateCategory.desconocido;

    final (min, max) = _rangeForAge(age);

    if (bpm < min) return HeartRateCategory.bradicardia;
    if (bpm > max) return HeartRateCategory.taquicardia;
    return HeartRateCategory.normal;
  }

  /// Devuelve el mensaje de recomendacion para el usuario
  static String getMessage({
    required int bpm,
    required int age,
    required bool leadOn,
  }) {
    if (!leadOn) return 'Coloca bien los electrodos';
    if (bpm == 0) return 'Esperando senal...';

    final category = classify(bpm, age);

    switch (category) {
      case HeartRateCategory.bradicardia:
        return 'Bradicardia: tu FC es baja. Si presentas mareos, fatiga o desmayos, consulta a un medico.';
      case HeartRateCategory.taquicardia:
        return 'Taquicardia: tu FC es alta. Descansa 5 minutos y vuelve a medir. Si persiste, consulta.';
      case HeartRateCategory.normal:
        return 'Frecuencia cardiaca normal para tu edad. Sigue asi!';
      case HeartRateCategory.desconocido:
        return 'Esperando senal...';
    }
  }
}
