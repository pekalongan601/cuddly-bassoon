import '../../providers/app_state_provider.dart';

String rupiah(num amount) {
  final rounded = amount.round();
  final absolute = rounded.abs().toString();
  final buffer = StringBuffer();

  for (var index = 0; index < absolute.length; index++) {
    final remaining = absolute.length - index;
    buffer.write(absolute[index]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write('.');
  }

  return '${rounded.isNegative ? '-' : ''}Rp$buffer';
}

num? parseRupiahInput(String input) {
  final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return null;
  return num.tryParse(digits);
}

String visibleMoney(AppState state, num amount) =>
    state.isBalanceHidden ? '••••••••' : rupiah(amount);
