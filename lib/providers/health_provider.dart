import 'package:flutter/foundation.dart';
import '../models/health_metrics.dart';
import '../services/storage_service.dart';

class HealthProvider extends ChangeNotifier {
  final StorageService _storageService;

  int _waterMlToday = 1800;
  int _stepsToday = 7420;
  bool _isHealthPlatformSynced = true;

  SleepEntry _latestSleep = SleepEntry(
    id: 's1',
    date: DateTime.now(),
    durationHours: 7.5,
    bedtime: '23:15',
    wakeTime: '06:45',
    qualityRating: 4,
  );

  HealthProvider(this._storageService) {
    _waterMlToday = _storageService.getWaterMlToday();
    _stepsToday = _storageService.getStepsToday();
  }

  int get waterMlToday => _waterMlToday;
  int get stepsToday => _stepsToday;
  SleepEntry get latestSleep => _latestSleep;
  bool get isHealthPlatformSynced => _isHealthPlatformSynced;

  double get waterLitersToday => double.parse((_waterMlToday / 1000).toStringAsFixed(1));
  double get distanceKmToday => double.parse((_stepsToday * 0.00075).toStringAsFixed(2));
  int get activeCaloriesBurnedToday => (_stepsToday * 0.04).round();

  Future<void> addWater(int ml) async {
    _waterMlToday += ml;
    await _storageService.saveWaterMlToday(_waterMlToday);
    notifyListeners();
  }

  Future<void> setWaterMl(int ml) async {
    _waterMlToday = ml;
    await _storageService.saveWaterMlToday(_waterMlToday);
    notifyListeners();
  }

  Future<void> addSteps(int steps) async {
    _stepsToday += steps;
    await _storageService.saveStepsToday(_stepsToday);
    notifyListeners();
  }

  Future<void> logSleep(double duration, String bedtime, String wakeTime, int quality) async {
    _latestSleep = SleepEntry(
      id: 's_${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      durationHours: duration,
      bedtime: bedtime,
      wakeTime: wakeTime,
      qualityRating: quality,
    );
    notifyListeners();
  }

  void toggleHealthPlatformSync(bool enabled) {
    _isHealthPlatformSynced = enabled;
    notifyListeners();
  }
}
