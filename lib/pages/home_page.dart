import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/layout.dart';
import '../core/utils/currency.dart';
import '../providers/app_state_provider.dart';
import '../widgets/common.dart';
import '../widgets/flash_deals.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        key: const PageStorageKey('home-scroll'),
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(Layout.pagePadding, 18, Layout.pagePadding, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _header(context, ref, state),
                const SizedBox(height: 38),
                _balanceCard(context, ref, state),
                const SizedBox(height: 22),
                _quickActions(context),
                const SizedBox(height: 23),
                const FlashDeals(compact: true),
                const SizedBox(height: 23),
                _banner(),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, WidgetRef ref, AppState state) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UserAvatar(size: 74),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(state.userName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Row(children: [
                  Flexible(child: Text('No. Rekening: ${state.accountNumber}', overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17, color: AppColors.muted))),
                  const SizedBox(width: 8),
                  InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nomor rekening disalin'))),
                    child: const Icon(Icons.copy_outlined, size: 23, color: AppColors.muted),
                  ),
                ]),
              ]),
            ),
          ),
          const SizedBox(width: 8),
          const NotificationButton(),
        ],
      );

  Widget _balanceCard(BuildContext context, WidgetRef ref, AppState state) => Container(
        height: 354,
        padding: const EdgeInsets.fromLTRB(32, 28, 26, 27),
        decoration: BoxDecoration(
          color: AppColors.orange,
          borderRadius: BorderRadius.circular(Layout.cardRadius),
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFF7200), Color(0xFFF25800)]),
        ),
        child: Stack(
          children: [
            Positioned(right: -65, top: -78, child: Icon(Icons.currency_exchange_rounded, color: Colors.white.withValues(alpha: .08), size: 330)),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Text('Total Saldo', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                      const SizedBox(width: 7),
                      InkWell(
                        onTap: () => ref.read(appStateProvider.notifier).setBalanceHidden(!state.isBalanceHidden),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Icon(state.isBalanceHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.white, size: 27),
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(width: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Material(
                    color: const Color(0xFFCF4D00),
                    borderRadius: BorderRadius.circular(26),
                    child: InkWell(
                      onTap: () => context.go('/transfer'),
                      borderRadius: BorderRadius.circular(26),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [Text('Riwayat', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)), SizedBox(width: 6), Icon(Icons.chevron_right_rounded, color: Colors.white)]),
                      ),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(visibleMoney(state, state.balance), key: ValueKey('${state.isBalanceHidden}-${state.balance}'), style: const TextStyle(color: Colors.white, fontSize: 43, fontWeight: FontWeight.w500, letterSpacing: -.7)),
              ),
              const Spacer(),
              Container(height: 1, color: Colors.white.withValues(alpha: .28)),
              const SizedBox(height: 30),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: _accountColumn(context, 'Tabungan', visibleMoney(state, state.savingsBalance), '2,5% p.a. cair harian')),
                const SizedBox(width: 15),
                Expanded(child: _depositColumn(context, state)), 
              ]),
            ]),
          ],
        ),
      );

  Widget _accountColumn(BuildContext context, String title, String amount, String sub) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(mainAxisSize: MainAxisSize.min, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 21)), const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 26)]),
        ),
        const SizedBox(height: 13),
        FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(amount, style: const TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w600))),
        const SizedBox(height: 8),
        FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(sub, style: const TextStyle(color: Color(0xFFFFD2AF), fontSize: 17))),
      ]);

  Widget _depositColumn(BuildContext context, AppState state) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Row(mainAxisSize: MainAxisSize.min, children: [Text('Deposito', style: TextStyle(color: Colors.white, fontSize: 21)), Icon(Icons.chevron_right_rounded, color: Colors.white, size: 26)])),
        const SizedBox(height: 13),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(visibleMoney(state, 0), style: const TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w600)), 
            const SizedBox(width: 6),
            InkWell(onTap: () => context.go('/deposit'), child: Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7), decoration: BoxDecoration(color: const Color(0xFFFFD19A), borderRadius: BorderRadius.circular(7)), child: const Text('Buka Deposito', style: TextStyle(color: Color(0xFF713600), fontSize: 15, fontWeight: FontWeight.w700)))),
          ]),
        ),
        const SizedBox(height: 8),
        const FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text('Hingga 6% p.a.', style: TextStyle(color: Color(0xFFFFD2AF), fontSize: 17))),
      ]);

  Widget _quickActions(BuildContext context) {
    final actions = <_QuickAction>[
      _QuickAction('Transfer', Icons.swap_horiz_rounded, () => context.go('/transfer')),
      _QuickAction('Top Up &\nTagihan', Icons.receipt_long_rounded, () => context.go('/transfer')),
      _QuickAction('Top Up\nE-Wallet', Icons.account_balance_wallet_rounded, () => context.go('/transfer'), badge: 'Baru'),
      _QuickAction('Undang\nTeman', Icons.group_rounded, () => context.go('/profile')),
      _QuickAction('Deposito', Icons.savings_rounded, () => context.go('/deposit')),
      _QuickAction('Tarik Tunai', Icons.download_rounded, () => _snack(context, 'Tarik tunai gratis hingga 7x/bulan'), badge: 'Gratis 7x'),
      _QuickAction('Pinjaman', Icons.volunteer_activism_rounded, () => _snack(context, 'Produk pinjaman sedang disiapkan')),
      _QuickAction('Lihat Semua', Icons.more_horiz_rounded, () => _snack(context, 'Semua layanan')),
    ];
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 25),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: actions.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisExtent: 157),
        itemBuilder: (_, index) => _quickAction(actions[index]),
      ),
    );
  }

  Widget _quickAction(_QuickAction action) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: action.onTap,
          borderRadius: BorderRadius.circular(14),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Stack(clipBehavior: Clip.none, children: [
              Container(width: 50, height: 50, alignment: Alignment.center, child: Icon(action.icon, color: AppColors.orange, size: 35)),
              if (action.badge != null) Positioned(right: -24, top: -4, child: Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFFFD5A2), borderRadius: BorderRadius.circular(7)), child: Text(action.badge!, style: const TextStyle(color: Color(0xFF6A370D), fontWeight: FontWeight.w600, fontSize: 12))))
            ]),
            const SizedBox(height: 12),
            Text(action.label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Color(0xFF545454), height: 1.18)),
          ]),
        ),
      );

  Widget _banner() => Container(
        height: 118,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(color: const Color(0xFF1C61E7), borderRadius: BorderRadius.circular(16)),
        child: const Row(children: [Icon(Icons.workspace_premium_rounded, size: 54, color: Color(0xFFFF9800)), SizedBox(width: 14), Expanded(child: Text('BUNGA DEPOSITO SPESIAL\nUntuk masa depan yang lebih pasti', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800, height: 1.25)))]),
      );

  void _snack(BuildContext context, String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class _QuickAction {
  const _QuickAction(this.label, this.icon, this.onTap, {this.badge});
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final String? badge;
}
