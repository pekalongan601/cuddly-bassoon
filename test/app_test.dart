import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seascape_banking/core/utils/currency.dart';
import 'package:seascape_banking/main.dart';
import 'package:seascape_banking/pages/developer_settings_page.dart';
import 'package:seascape_banking/pages/qris_page.dart';
import 'package:seascape_banking/providers/app_state_provider.dart';
import 'package:seascape_banking/routes/app_router.dart';
import 'package:seascape_banking/services/local_preferences_service.dart';

void main() {
  test('local settings preserve independent balances and user settings', () async {
    final store = LocalPreferencesService.inMemory();
    final notifier = AppStateNotifier(store);

    notifier.setBalance(150000000);
    notifier.setSavingsBalance(42000000);
    notifier.addBalance(5000000);
    expect(notifier.subtractBalance(200000000), isFalse);
    notifier.setBalanceHidden(true);
    notifier.setUserName('Nama Lokal');
    notifier.setAccountNumber('1234 5678 9012');
    notifier.setPhoneNumber('081234567890');

    await Future<void>.delayed(Duration.zero);
    final restored = AppStateNotifier(store).state;
    expect(restored.balance, 155000000);
    expect(restored.savingsBalance, 42000000);
    expect(restored.isBalanceHidden, isTrue);
    expect(restored.userName, 'Nama Lokal');
    expect(restored.accountNumber, '1234 5678 9012');
    expect(restored.phoneNumber, '081234567890');
    expect(rupiah(restored.balance), 'Rp155.000.000');
  });

  testWidgets('QRIS scanner remains usable in landscape', (tester) async {
    tester.view.physicalSize = const Size(800, 360);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: QrisPage()));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Scan QRIS'), findsOneWidget);
  });

  testWidgets('primary banking journeys render at compact Android width', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: SeaScapeApp()));
    await tester.pumpAndSettle();
    expect(find.text('Total Saldo'), findsOneWidget);

    await tester.tap(find.text('Bayar/Transfer'));
    await tester.pumpAndSettle();
    expect(find.text('Transfer ke'), findsOneWidget);

    await tester.tap(find.text('Deposito').last);
    await tester.pumpAndSettle();
    expect(find.text('Pilihan\nDeposito\nUntukmu'), findsOneWidget);

    await tester.tap(find.text('Saya'));
    await tester.pumpAndSettle();
    expect(find.text('Log in dengan sidik jari'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.qr_code_scanner_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(appRouter.routeInformationProvider.value.uri.path, '/qris');
    expect(find.byType(QrisPage), findsOneWidget);
    expect(find.text('Scan QRIS'), findsOneWidget);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: DeveloperSettingsPage()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Edit Total Balance'), findsOneWidget);
  });
}
