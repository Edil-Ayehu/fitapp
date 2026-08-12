import 'package:flutter/foundation.dart';
import '../models/subscription.dart';
import '../services/storage_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  final StorageService _storageService;
  late SubscriptionState _subscriptionState;

  SubscriptionProvider(this._storageService) {
    _subscriptionState = _storageService.getSubscription();
  }

  SubscriptionState get subscriptionState => _subscriptionState;
  bool get isPremium => _subscriptionState.isPremium;

  Future<void> activatePlan(SubscriptionPlan plan) async {
    _subscriptionState.plan = plan;
    _subscriptionState.isTrialActive = false;
    _subscriptionState.subscriptionEndDate = DateTime.now().add(
      plan == SubscriptionPlan.yearly ? const Duration(days: 365) : const Duration(days: 30),
    );
    await _storageService.saveSubscription(_subscriptionState);
    notifyListeners();
  }

  Future<void> startFreeTrial() async {
    _subscriptionState.isTrialActive = true;
    _subscriptionState.trialEndDate = DateTime.now().add(const Duration(days: 7));
    await _storageService.saveSubscription(_subscriptionState);
    notifyListeners();
  }

  Future<void> cancelSubscription() async {
    _subscriptionState.plan = SubscriptionPlan.free;
    _subscriptionState.isTrialActive = false;
    await _storageService.saveSubscription(_subscriptionState);
    notifyListeners();
  }

  Future<void> restorePurchases() async {
    await Future.delayed(const Duration(milliseconds: 700));
    _subscriptionState.plan = SubscriptionPlan.monthly;
    await _storageService.saveSubscription(_subscriptionState);
    notifyListeners();
  }

  bool isFeatureLocked(String featureKey) {
    if (isPremium) return false;

    // Locked features for Free users
    const lockedKeys = [
      'advanced_analytics',
      'ai_coach_unlimited',
      'ai_workout_generator',
      'meal_planner',
      'progress_photos_compare',
      'wearable_sync',
    ];
    return lockedKeys.contains(featureKey);
  }
}
