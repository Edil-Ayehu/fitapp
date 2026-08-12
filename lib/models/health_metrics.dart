class WeightLogEntry {
  final String id;
  final double weightKg;
  final double? bodyFatPercentage;
  final DateTime date;

  WeightLogEntry({
    required this.id,
    required this.weightKg,
    this.bodyFatPercentage,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'weightKg': weightKg,
        'bodyFatPercentage': bodyFatPercentage,
        'date': date.toIso8601String(),
      };

  factory WeightLogEntry.fromJson(Map<String, dynamic> json) => WeightLogEntry(
        id: json['id'],
        weightKg: (json['weightKg'] as num).toDouble(),
        bodyFatPercentage: (json['bodyFatPercentage'] as num?)?.toDouble(),
        date: DateTime.parse(json['date']),
      );
}

class BodyMeasurements {
  final String id;
  final DateTime date;
  final double chestCm;
  final double waistCm;
  final double armsCm;
  final double thighsCm;
  final double shouldersCm;
  final double hipsCm;

  BodyMeasurements({
    required this.id,
    required this.date,
    required this.chestCm,
    required this.waistCm,
    required this.armsCm,
    required this.thighsCm,
    required this.shouldersCm,
    required this.hipsCm,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'chestCm': chestCm,
        'waistCm': waistCm,
        'armsCm': armsCm,
        'thighsCm': thighsCm,
        'shouldersCm': shouldersCm,
        'hipsCm': hipsCm,
      };

  factory BodyMeasurements.fromJson(Map<String, dynamic> json) => BodyMeasurements(
        id: json['id'],
        date: DateTime.parse(json['date']),
        chestCm: (json['chestCm'] as num).toDouble(),
        waistCm: (json['waistCm'] as num).toDouble(),
        armsCm: (json['armsCm'] as num).toDouble(),
        thighsCm: (json['thighsCm'] as num).toDouble(),
        shouldersCm: (json['shouldersCm'] as num).toDouble(),
        hipsCm: (json['hipsCm'] as num).toDouble(),
      );
}

class ProgressPhoto {
  final String id;
  final DateTime date;
  final String viewAngle; // Front, Side, Back
  final double weightKg;
  final String imagePath;

  ProgressPhoto({
    required this.id,
    required this.date,
    required this.viewAngle,
    required this.weightKg,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'viewAngle': viewAngle,
        'weightKg': weightKg,
        'imagePath': imagePath,
      };

  factory ProgressPhoto.fromJson(Map<String, dynamic> json) => ProgressPhoto(
        id: json['id'],
        date: DateTime.parse(json['date']),
        viewAngle: json['viewAngle'],
        weightKg: (json['weightKg'] as num).toDouble(),
        imagePath: json['imagePath'],
      );
}

class SleepEntry {
  final String id;
  final DateTime date;
  final double durationHours;
  final String bedtime; // e.g. "23:00"
  final String wakeTime; // e.g. "07:00"
  final int qualityRating; // 1 to 5 stars

  SleepEntry({
    required this.id,
    required this.date,
    required this.durationHours,
    required this.bedtime,
    required this.wakeTime,
    required this.qualityRating,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'durationHours': durationHours,
        'bedtime': bedtime,
        'wakeTime': wakeTime,
        'qualityRating': qualityRating,
      };

  factory SleepEntry.fromJson(Map<String, dynamic> json) => SleepEntry(
        id: json['id'],
        date: DateTime.parse(json['date']),
        durationHours: (json['durationHours'] as num).toDouble(),
        bedtime: json['bedtime'],
        wakeTime: json['wakeTime'],
        qualityRating: json['qualityRating'],
      );
}

class StepsEntry {
  final DateTime date;
  final int stepCount;
  final double distanceKm;
  final int caloriesBurned;
  final int activeMinutes;

  StepsEntry({
    required this.date,
    required this.stepCount,
    required this.distanceKm,
    required this.caloriesBurned,
    required this.activeMinutes,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'stepCount': stepCount,
        'distanceKm': distanceKm,
        'caloriesBurned': caloriesBurned,
        'activeMinutes': activeMinutes,
      };

  factory StepsEntry.fromJson(Map<String, dynamic> json) => StepsEntry(
        date: DateTime.parse(json['date']),
        stepCount: json['stepCount'],
        distanceKm: (json['distanceKm'] as num).toDouble(),
        caloriesBurned: json['caloriesBurned'],
        activeMinutes: json['activeMinutes'],
      );
}
