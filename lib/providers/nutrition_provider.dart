import 'package:flutter/foundation.dart';
import '../models/nutrition_log.dart';
import '../services/storage_service.dart';

class NutritionProvider extends ChangeNotifier {
  final StorageService _storageService;

  List<FoodItem> _foodDatabase = [];
  List<LoggedMealEntry> _loggedMeals = [];
  List<DailyMealPlan> _mealPlans = [];

  String _searchQuery = '';

  NutritionProvider(this._storageService) {
    _foodDatabase = FoodItem.sampleDatabase;
    _loggedMeals = _storageService.getLoggedMeals();
    _mealPlans = DailyMealPlan.samplePlans;
  }

  List<FoodItem> get foodDatabase => _foodDatabase;
  List<LoggedMealEntry> get loggedMeals => _loggedMeals;
  List<DailyMealPlan> get mealPlans => _mealPlans;
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<FoodItem> get filteredFoodDatabase {
    if (_searchQuery.isEmpty) return _foodDatabase;
    return _foodDatabase
        .where((f) => f.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            f.category.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  // Daily totals
  int get totalCaloriesToday {
    int sum = 0;
    for (var m in _loggedMeals) {
      sum += m.totalCalories;
    }
    return sum;
  }

  double get totalProteinToday {
    double sum = 0;
    for (var m in _loggedMeals) {
      sum += m.totalProtein;
    }
    return double.parse(sum.toStringAsFixed(1));
  }

  double get totalCarbsToday {
    double sum = 0;
    for (var m in _loggedMeals) {
      sum += m.totalCarbs;
    }
    return double.parse(sum.toStringAsFixed(1));
  }

  double get totalFatToday {
    double sum = 0;
    for (var m in _loggedMeals) {
      sum += m.totalFat;
    }
    return double.parse(sum.toStringAsFixed(1));
  }

  Future<void> logFood(FoodItem item, String mealType, double quantity) async {
    final entry = LoggedMealEntry(
      id: 'lm_${DateTime.now().millisecondsSinceEpoch}',
      mealType: mealType,
      food: item,
      quantity: quantity,
    );
    _loggedMeals.add(entry);
    await _storageService.saveLoggedMeals(_loggedMeals);
    notifyListeners();
  }

  Future<void> deleteLoggedMeal(String id) async {
    _loggedMeals.removeWhere((m) => m.id == id);
    await _storageService.saveLoggedMeals(_loggedMeals);
    notifyListeners();
  }

  Future<void> addCustomFood(FoodItem food) async {
    _foodDatabase.insert(0, food);
    notifyListeners();
  }
}
