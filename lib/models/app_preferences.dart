import 'package:flutter/material.dart';

@immutable
class AppPreferences {
  const AppPreferences({
    required this.userName,
    required this.phoneNumber,
    required this.accountNumber,
    required this.balance,
    required this.savingsBalance,
    required this.isBalanceHidden,
    required this.themeMode,
  });

  static const defaultUserName = 'Diaz Arman Maulana';
  static const defaultPhoneNumber = '083*****350';
  static const defaultAccountNumber = '9014 3025 9290';
  static const defaultBalance = 212;
  static const defaultSavingsBalance = 212;

  static const defaults = AppPreferences(
    userName: defaultUserName,
    phoneNumber: defaultPhoneNumber,
    accountNumber: defaultAccountNumber,
    balance: defaultBalance,
    savingsBalance: defaultSavingsBalance,
    isBalanceHidden: false,
    themeMode: ThemeMode.light,
  );

  final String userName;
  final String phoneNumber;
  final String accountNumber;
  final num balance;
  final num savingsBalance;
  final bool isBalanceHidden;
  final ThemeMode themeMode;
}
