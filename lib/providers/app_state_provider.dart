import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_preferences.dart';
import '../services/local_preferences_service.dart';

@immutable
class AppState {
  const AppState({
    required this.userName,
    required this.phoneNumber,
    required this.accountNumber,
    required this.balance,
    required this.savingsBalance,
    required this.isBalanceHidden,
    required this.themeMode,
  });

  factory AppState.initial() => AppState.fromPreferences(AppPreferences.defaults);

  factory AppState.fromPreferences(AppPreferences preferences) => AppState(
        userName: preferences.userName,
        phoneNumber: preferences.phoneNumber,
        accountNumber: preferences.accountNumber,
        balance: preferences.balance,
        savingsBalance: preferences.savingsBalance,
        isBalanceHidden: preferences.isBalanceHidden,
        themeMode: preferences.themeMode,
      );

  final String userName;
  final String phoneNumber;
  final String accountNumber;
  final num balance;
  final num savingsBalance;
  final bool isBalanceHidden;
  final ThemeMode themeMode;

  AppPreferences toPreferences() => AppPreferences(
        userName: userName,
        phoneNumber: phoneNumber,
        accountNumber: accountNumber,
        balance: balance,
        savingsBalance: savingsBalance,
        isBalanceHidden: isBalanceHidden,
        themeMode: themeMode,
      );

  AppState copyWith({
    String? userName,
    String? phoneNumber,
    String? accountNumber,
    num? balance,
    num? savingsBalance,
    bool? isBalanceHidden,
    ThemeMode? themeMode,
  }) => AppState(
        userName: userName ?? this.userName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        accountNumber: accountNumber ?? this.accountNumber,
        balance: balance ?? this.balance,
        savingsBalance: savingsBalance ?? this.savingsBalance,
        isBalanceHidden: isBalanceHidden ?? this.isBalanceHidden,
        themeMode: themeMode ?? this.themeMode,
      );
}

final localPreferencesProvider = Provider<LocalPreferencesService>(
  (ref) => LocalPreferencesService.inMemory(),
);

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier(this._preferences) : super(AppState.fromPreferences(_preferences.read()));

  final LocalPreferencesService _preferences;
  Future<void> _pendingWrite = Future.value();

  void setBalance(num value) => _update(state.copyWith(balance: _nonNegative(value)));

  void setSavingsBalance(num value) =>
      _update(state.copyWith(savingsBalance: _nonNegative(value)));

  void addBalance(num value) {
    if (value <= 0) return;
    setBalance(state.balance + value);
  }

  bool subtractBalance(num value) {
    if (value <= 0 || value > state.balance) return false;
    setBalance(state.balance - value);
    return true;
  }

  void resetBalance() => _update(
        state.copyWith(
          balance: AppPreferences.defaultBalance,
          savingsBalance: AppPreferences.defaultSavingsBalance,
        ),
      );

  void setBalanceHidden(bool value) => _update(state.copyWith(isBalanceHidden: value));

  void setUserName(String value) {
    final normalized = value.trim();
    if (normalized.isNotEmpty) _update(state.copyWith(userName: normalized));
  }

  void setAccountNumber(String value) {
    final normalized = value.trim();
    if (normalized.isNotEmpty) _update(state.copyWith(accountNumber: normalized));
  }

  void setPhoneNumber(String value) {
    final normalized = value.trim();
    if (normalized.isNotEmpty) _update(state.copyWith(phoneNumber: normalized));
  }

  void setThemeMode(ThemeMode value) => _update(state.copyWith(themeMode: value));

  num _nonNegative(num value) => value < 0 ? 0 : value;

  void _update(AppState next) {
    state = next;
    _pendingWrite = _pendingWrite
        .catchError((_) {})
        .then((_) => _preferences.save(next.toPreferences()));
    unawaited(_pendingWrite.catchError((_) {}));
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(
  (ref) => AppStateNotifier(ref.watch(localPreferencesProvider)),
);
