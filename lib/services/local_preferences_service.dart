import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_preferences.dart';

/// Small local-only persistence boundary for user-adjustable demo settings.
///
/// The in-memory constructor keeps widgets and tests independent from platform
/// channels while the production constructor uses SharedPreferences.
class LocalPreferencesService {
  LocalPreferencesService._(this._preferences);

  factory LocalPreferencesService.inMemory() => LocalPreferencesService._(null);

  static Future<LocalPreferencesService> create() async =>
      LocalPreferencesService._(await SharedPreferences.getInstance());

  static const _userNameKey = 'user_name';
  static const _phoneNumberKey = 'phone_number';
  static const _accountNumberKey = 'account_number';
  static const _balanceKey = 'balance';
  static const _savingsBalanceKey = 'savings_balance';
  static const _balanceHiddenKey = 'balance_hidden';
  static const _themeModeKey = 'theme_mode';

  final SharedPreferences? _preferences;
  AppPreferences _memory = AppPreferences.defaults;

  AppPreferences read() {
    final preferences = _preferences;
    if (preferences == null) return _memory;

    const defaults = AppPreferences.defaults;
    return AppPreferences(
      userName: preferences.getString(_userNameKey) ?? defaults.userName,
      phoneNumber: preferences.getString(_phoneNumberKey) ?? defaults.phoneNumber,
      accountNumber: preferences.getString(_accountNumberKey) ?? defaults.accountNumber,
      balance: preferences.getDouble(_balanceKey) ?? defaults.balance,
      savingsBalance: preferences.getDouble(_savingsBalanceKey) ?? defaults.savingsBalance,
      isBalanceHidden: preferences.getBool(_balanceHiddenKey) ?? defaults.isBalanceHidden,
      themeMode: _themeFromStorage(preferences.getString(_themeModeKey)),
    );
  }

  Future<void> save(AppPreferences settings) async {
    _memory = settings;
    final preferences = _preferences;
    if (preferences == null) return;

    await Future.wait([
      preferences.setString(_userNameKey, settings.userName),
      preferences.setString(_phoneNumberKey, settings.phoneNumber),
      preferences.setString(_accountNumberKey, settings.accountNumber),
      preferences.setDouble(_balanceKey, settings.balance.toDouble()),
      preferences.setDouble(_savingsBalanceKey, settings.savingsBalance.toDouble()),
      preferences.setBool(_balanceHiddenKey, settings.isBalanceHidden),
      preferences.setString(_themeModeKey, settings.themeMode.name),
    ]);
  }

  ThemeMode _themeFromStorage(String? value) => switch (value) {
        'dark' => ThemeMode.dark,
        'system' => ThemeMode.system,
        _ => ThemeMode.light,
      };
}
