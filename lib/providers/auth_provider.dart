import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final StorageService _storageService;
  UserProfile _userProfile;
  bool _isLoggedIn = true; // Default logged in for easy test driving
  bool _isLoading = false;
  String? _authError;

  AuthProvider(this._storageService) : _userProfile = _storageService.getUserProfile();

  UserProfile get userProfile => _userProfile;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get authError => _authError;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _authError = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    if (email.contains('@')) {
      _userProfile.email = email;
      _isLoggedIn = true;
      await _storageService.saveUserProfile(_userProfile);
    } else {
      _authError = 'Invalid email or password.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signup(String name, String email, String password) async {
    _isLoading = true;
    _authError = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _userProfile = UserProfile(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
    );
    _isLoggedIn = true;
    await _storageService.saveUserProfile(_userProfile);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> socialLogin(String provider) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _userProfile.name = provider == 'Google' ? 'Alex (Google)' : 'Alex (Apple)';
    _isLoggedIn = true;
    await _storageService.saveUserProfile(_userProfile);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(UserProfile newProfile) async {
    _userProfile = newProfile;
    _userProfile.recalculatePersonalizedTargets();
    await _storageService.saveUserProfile(_userProfile);
    notifyListeners();
  }

  Future<void> toggleBiometrics(bool enabled) async {
    _userProfile.isBiometricEnabled = enabled;
    await _storageService.saveUserProfile(_userProfile);
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    _userProfile = UserProfile.defaultUser();
    _isLoggedIn = false;
    await _storageService.saveUserProfile(_userProfile);
    notifyListeners();
  }
}
