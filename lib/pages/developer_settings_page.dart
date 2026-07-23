import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/currency.dart';
import '../providers/app_state_provider.dart';
import '../widgets/common.dart';

class DeveloperSettingsPage extends ConsumerStatefulWidget {
  const DeveloperSettingsPage({super.key});

  @override
  ConsumerState<DeveloperSettingsPage> createState() =>
      _DeveloperSettingsPageState();
}

class _DeveloperSettingsPageState
    extends ConsumerState<DeveloperSettingsPage> {
  late final TextEditingController _totalBalance;
  late final TextEditingController _savingsBalance;
  final TextEditingController _adjustment = TextEditingController();
  late final TextEditingController _name;
  late final TextEditingController _account;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    final state = ref.read(appStateProvider);
    _totalBalance = TextEditingController(text: state.balance.round().toString());
    _savingsBalance =
        TextEditingController(text: state.savingsBalance.round().toString());
    _name = TextEditingController(text: state.userName);
    _account = TextEditingController(text: state.accountNumber);
    _phone = TextEditingController(text: state.phoneNumber);
  }

  @override
  void dispose() {
    _totalBalance.dispose();
    _savingsBalance.dispose();
    _adjustment.dispose();
    _name.dispose();
    _account.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text(
          'Developer Settings',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 32),
          children: [
            const Text(
              'Local testing only',
              style: TextStyle(
                color: AppColors.orange,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Perubahan disimpan secara lokal dan tetap tersedia setelah aplikasi dibuka kembali.',
              style: TextStyle(color: AppColors.muted, height: 1.35),
            ),
            const SizedBox(height: 18),
            _group('Edit Total Balance', [
              _currentValue('Saldo saat ini', state.balance, state.isBalanceHidden),
              const SizedBox(height: 12),
              _amountField(
                _totalBalance,
                'Total Balance',
                hidden: state.isBalanceHidden,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: AppTextButton(
                  label: 'Simpan Total Balance',
                  onTap: _saveTotalBalance,
                ),
              ),
            ]),
            const SizedBox(height: 16),
            _group('Edit Savings Balance', [
              _currentValue('Tabungan saat ini', state.savingsBalance, state.isBalanceHidden),
              const SizedBox(height: 12),
              _amountField(
                _savingsBalance,
                'Savings Balance',
                hidden: state.isBalanceHidden,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: AppTextButton(
                  label: 'Simpan Savings Balance',
                  onTap: _saveSavingsBalance,
                ),
              ),
            ]),
            const SizedBox(height: 16),
            _group('Tambah atau Kurangi Balance', [
              const Text(
                'Nominal ini hanya mengubah Total Balance.',
                style: TextStyle(color: AppColors.muted, height: 1.35),
              ),
              const SizedBox(height: 12),
              _amountField(_adjustment, 'Nominal Penyesuaian'),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final vertical = constraints.maxWidth < 290;
                  final addButton = AppTextButton(
                    label: 'Tambah Balance',
                    onTap: _addBalance,
                  );
                  final subtractButton = AppTextButton(
                    label: 'Kurangi Balance',
                    filled: false,
                    onTap: _subtractBalance,
                  );
                  if (vertical) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        addButton,
                        const SizedBox(height: 10),
                        subtractButton,
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: addButton),
                      const SizedBox(width: 12),
                      Expanded(child: subtractButton),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: AppTextButton(
                  label: 'Reset Semua Balance',
                  filled: false,
                  onTap: _resetBalances,
                ),
              ),
            ]),
            const SizedBox(height: 16),
            _group('Privasi Balance', [
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.orange,
                activeTrackColor: AppColors.orange.withValues(alpha: .35),
                title: const Text(
                  'Sembunyikan Balance',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Tampilkan •••••••• pada seluruh balance.'),
                value: state.isBalanceHidden,
                onChanged: ref.read(appStateProvider.notifier).setBalanceHidden,
              ),
            ]),
            const SizedBox(height: 16),
            _group('Edit User Name', [
              TextField(
                controller: _name,
                onChanged: ref.read(appStateProvider.notifier).setUserName,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'User Name'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: AppTextButton(
                  label: 'Simpan Nama',
                  onTap: () => _saveText(
                    _name,
                    ref.read(appStateProvider.notifier).setUserName,
                    'Nama diperbarui',
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 16),
            _group('Edit Account Number', [
              TextField(
                controller: _account,
                onChanged: ref.read(appStateProvider.notifier).setAccountNumber,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Account Number'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: AppTextButton(
                  label: 'Simpan Nomor Rekening',
                  onTap: () => _saveText(
                    _account,
                    ref.read(appStateProvider.notifier).setAccountNumber,
                    'Nomor rekening diperbarui',
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 16),
            _group('Edit Phone Number', [
              TextField(
                controller: _phone,
                onChanged: ref.read(appStateProvider.notifier).setPhoneNumber,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: AppTextButton(
                  label: 'Simpan Nomor Telepon',
                  onTap: () => _saveText(
                    _phone,
                    ref.read(appStateProvider.notifier).setPhoneNumber,
                    'Nomor telepon diperbarui',
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 16),
            _group('Theme', [
              const Text(
                'Pilih tema untuk aplikasi demo lokal ini.',
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('System'),
                      icon: Icon(Icons.brightness_auto_outlined),
                    ),
                  ],
                  selected: {state.themeMode},
                  onSelectionChanged: (values) => ref
                      .read(appStateProvider.notifier)
                      .setThemeMode(values.first),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _currentValue(String label, num value, bool hidden) => Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.muted),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                hidden ? '••••••••' : rupiah(value),
                style: const TextStyle(
                  color: AppColors.orange,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      );

  Widget _amountField(
    TextEditingController controller,
    String label, {
    bool hidden = false,
  }) =>
      TextField(
        controller: controller,
        obscureText: hidden,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(labelText: label, prefixText: 'Rp'),
      );

  Widget _group(String title, List<Widget> children) => SoftCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      );

  void _saveTotalBalance() {
    final value = parseRupiahInput(_totalBalance.text);
    if (value == null) return _invalidAmount();
    ref.read(appStateProvider.notifier).setBalance(value);
    _totalBalance.text = value.round().toString();
    _confirmation('Total Balance diperbarui menjadi ${rupiah(value)}');
  }

  void _saveSavingsBalance() {
    final value = parseRupiahInput(_savingsBalance.text);
    if (value == null) return _invalidAmount();
    ref.read(appStateProvider.notifier).setSavingsBalance(value);
    _savingsBalance.text = value.round().toString();
    _confirmation('Savings Balance diperbarui menjadi ${rupiah(value)}');
  }

  void _addBalance() {
    final value = parseRupiahInput(_adjustment.text);
    if (value == null || value <= 0) return _invalidAmount();
    ref.read(appStateProvider.notifier).addBalance(value);
    _adjustment.clear();
    _totalBalance.text = ref.read(appStateProvider).balance.round().toString();
    _confirmation('Balance bertambah ${rupiah(value)}');
  }

  void _subtractBalance() {
    final value = parseRupiahInput(_adjustment.text);
    if (value == null || value <= 0) return _invalidAmount();
    final didSubtract = ref.read(appStateProvider.notifier).subtractBalance(value);
    if (!didSubtract) {
      _confirmation('Balance tidak boleh menjadi negatif');
      return;
    }
    _adjustment.clear();
    _totalBalance.text = ref.read(appStateProvider).balance.round().toString();
    _confirmation('Balance berkurang ${rupiah(value)}');
  }

  void _resetBalances() {
    ref.read(appStateProvider.notifier).resetBalance();
    final state = ref.read(appStateProvider);
    _totalBalance.text = state.balance.round().toString();
    _savingsBalance.text = state.savingsBalance.round().toString();
    _adjustment.clear();
    _confirmation('Semua balance dikembalikan ke nilai awal');
  }

  void _saveText(
    TextEditingController controller,
    void Function(String value) update,
    String confirmation,
  ) {
    update(controller.text);
    _confirmation(confirmation);
  }

  void _invalidAmount() =>
      _confirmation('Masukkan nominal Rupiah yang valid');

  void _confirmation(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
