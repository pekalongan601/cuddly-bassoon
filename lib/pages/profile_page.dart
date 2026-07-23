import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../providers/app_state_provider.dart';
import '../widgets/common.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    return Stack(children: [
      Positioned(top: 0, left: 0, right: 0, height: 230, child: Container(color: AppColors.orange)),
      SafeArea(
        bottom: false,
        child: CustomScrollView(
          key: const PageStorageKey('profile-scroll'),
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 26),
              sliver: SliverList(delegate: SliverChildListDelegate([
                _profileHeader(state),
                const SizedBox(height: 43),
                _notice(Icons.fingerprint_rounded, 'Log in dengan sidik jari', 'Aktifkan verifikasi sidik jari untuk log in lebih\ncepat dan aman tanpa password!', 'Aktifkan Sekarang'),
                const SizedBox(height: 19),
                _notice(Icons.mark_email_read_outlined, 'Verifikasi Email Kamu Sekarang', 'Dapatkan info transaksi & promo, serta\npulihkan password dengan mudah!', 'Verifikasi Email'),
                const SizedBox(height: 20),
                _settings(context),
                const SizedBox(height: 21),
                _logout(context),
                const SizedBox(height: 25),
              ])),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _profileHeader(AppState state) => Row(children: [
        const UserAvatar(size: 74, color: Colors.white, iconColor: AppColors.orange),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(state.userName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600)), const SizedBox(height: 5), Text(state.phoneNumber, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500))])),
        const NotificationButton(dark: true),
      ]);

  Widget _notice(IconData icon, String title, String description, String action) => SoftCard(
        radius: 14,
        padding: const EdgeInsets.fromLTRB(18, 20, 14, 20),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: const EdgeInsets.only(top: 2), child: OrangeCircleIcon(icon: icon, size: 40, iconSize: 22)),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)), const SizedBox(height: 6), Text(description, style: const TextStyle(fontSize: 16, color: AppColors.muted, height: 1.25)), const SizedBox(height: 3), Text(action, style: const TextStyle(fontSize: 17, color: Color(0xFF1483A5), fontWeight: FontWeight.w500))])),
          const Icon(Icons.close_rounded, size: 30, color: AppColors.muted),
        ]),
      );

  Widget _settings(BuildContext context) {
    const primary = <_ProfileItem>[
      _ProfileItem('Profil Saya', Icons.person_outline_rounded),
      _ProfileItem('Keamanan Akun', Icons.verified_user_outlined),
      _ProfileItem('e-Statement', Icons.receipt_long_outlined),
      _ProfileItem('Pengaturan Limit dan Pembayaran', Icons.credit_card_outlined),
      _ProfileItem('Pengaturan BI-FAST', Icons.phonelink_setup_outlined),
      _ProfileItem('Pengaturan Umum', Icons.settings_outlined),
      _ProfileItem('Undang Teman', Icons.group_add_outlined),
      _ProfileItem('Pusat Bantuan', Icons.lightbulb_outline_rounded),
      _ProfileItem('Chat dengan SeaBank', Icons.chat_bubble_outline_rounded),
      _ProfileItem('Lokasi SeaBank', Icons.location_city_outlined),
      _ProfileItem('Beri Masukan', Icons.feedback_outlined),
    ];
    return SoftCard(
      radius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(children: [
        ...primary.map((item) => _settingRow(context, item)),
        _settingRow(context, const _ProfileItem('Developer Settings', Icons.developer_mode_rounded), developer: true),
      ]),
    );
  }

  Widget _settingRow(BuildContext context, _ProfileItem item, {bool developer = false}) => InkWell(
        onTap: () {
          if (developer) {
            context.push('/developer-settings');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.label} dipilih')));
          }
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 96),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.line))),
          child: Row(children: [
            Icon(item.icon, size: 32, color: developer ? AppColors.orange : const Color(0xFF202124)),
            const SizedBox(width: 28),
            Expanded(child: Text(item.label, style: TextStyle(fontSize: 20, fontWeight: developer ? FontWeight.w600 : FontWeight.w400, color: developer ? AppColors.orange : null))),
            const Icon(Icons.chevron_right_rounded, size: 31, color: AppColors.muted),
          ]),
        ),
      );

  Widget _logout(BuildContext context) => SoftCard(
        radius: 12,
        onTap: () => showDialog<void>(context: context, builder: (_) => AlertDialog(title: const Text('Log Out'), content: const Text('Anda akan keluar dari sesi demo lokal ini.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')), TextButton(onPressed: () => Navigator.pop(context), child: const Text('Log Out'))])),
        child: const SizedBox(height: 76, child: Center(child: Text('Log Out', style: TextStyle(color: AppColors.orange, fontSize: 21, fontWeight: FontWeight.w700)))),
      );
}

class _ProfileItem {
  const _ProfileItem(this.label, this.icon);
  final String label;
  final IconData icon;
}
