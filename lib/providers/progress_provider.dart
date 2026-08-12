import 'package:flutter/foundation.dart';
import '../models/health_metrics.dart';
import '../services/storage_service.dart';

class ProgressProvider extends ChangeNotifier {
  final StorageService _storageService;

  List<WeightLogEntry> _weightLogs = [];
  List<BodyMeasurements> _measurements = [];
  List<ProgressPhoto> _photos = [];

  ProgressProvider(this._storageService) {
    _weightLogs = _storageService.getWeightLogs();
    _measurements = [
      BodyMeasurements(
        id: 'm1',
        date: DateTime.now().subtract(const Duration(days: 30)),
        chestCm: 104.0,
        waistCm: 84.0,
        armsCm: 38.5,
        thighsCm: 60.0,
        shouldersCm: 118.0,
        hipsCm: 98.0,
      ),
      BodyMeasurements(
        id: 'm2',
        date: DateTime.now(),
        chestCm: 106.5,
        waistCm: 82.5,
        armsCm: 39.8,
        thighsCm: 61.5,
        shouldersCm: 120.5,
        hipsCm: 97.5,
      ),
    ];
    _photos = [
      ProgressPhoto(
        id: 'p1',
        date: DateTime.now().subtract(const Duration(days: 60)),
        viewAngle: 'Front',
        weightKg: 80.0,
        imagePath: 'assets/images/sample_photo_before.jpg',
      ),
      ProgressPhoto(
        id: 'p2',
        date: DateTime.now(),
        viewAngle: 'Front',
        weightKg: 78.5,
        imagePath: 'assets/images/sample_photo_after.jpg',
      ),
    ];
  }

  List<WeightLogEntry> get weightLogs => _weightLogs;
  List<BodyMeasurements> get measurements => _measurements;
  List<ProgressPhoto> get photos => _photos;

  double get latestWeight => _weightLogs.isNotEmpty ? _weightLogs.last.weightKg : 78.5;
  double? get latestBodyFat => _weightLogs.isNotEmpty ? _weightLogs.last.bodyFatPercentage : 16.4;

  double calculateBMI(double heightCm) {
    if (heightCm <= 0) return 22.5;
    final hMeters = heightCm / 100;
    return double.parse((latestWeight / (hMeters * hMeters)).toStringAsFixed(1));
  }

  Future<void> addWeightEntry(double weightKg, {double? bodyFat}) async {
    final entry = WeightLogEntry(
      id: 'w_${DateTime.now().millisecondsSinceEpoch}',
      weightKg: weightKg,
      bodyFatPercentage: bodyFat,
      date: DateTime.now(),
    );
    _weightLogs.add(entry);
    await _storageService.saveWeightLogs(_weightLogs);
    notifyListeners();
  }

  Future<void> addMeasurement(BodyMeasurements m) async {
    _measurements.add(m);
    notifyListeners();
  }
}
