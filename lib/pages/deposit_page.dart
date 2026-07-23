import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../widgets/common.dart';
import '../widgets/flash_deals.dart';

class DepositPage extends StatelessWidget {
  const DepositPage({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        bottom: false,
        child: CustomScrollView(
          key: const PageStorageKey('deposit-scroll'),
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              sliver: SliverList(delegate: SliverChildListDelegate([
                const Text('Deposito', style: TextStyle(fontSize: 31, fontWeight: FontWeight.w500)),
                const SizedBox(height: 20),
                _hero(),
                const SizedBox(height: 19),
                const FlashDeals(),
                const SizedBox(height: 25),
                _depositList(context),
                const SizedBox(height: 25),
                _faq(context),
                const SizedBox(height: 26),
              ])),
            ),
          ],
        ),
      );

  Widget _hero() => Container(
        height: 210,
        padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFFF0E7), Color(0xFFFFD8C7)])),
        child: Row(children: [
          const Expanded(
            child: FittedBox(
              alignment: Alignment.topLeft,
              fit: BoxFit.scaleDown,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Pilihan\nDeposito\nUntukmu', style: TextStyle(fontSize: 37, fontWeight: FontWeight.w800, color: AppColors.orange, height: 1.12)),
                SizedBox(height: 17),
                Text('Tumbuhkan dana dan dapatkan\nkeuntungan maksimal!', style: TextStyle(color: Color(0xFFC85B19), fontSize: 16, height: 1.3)),
              ]),
            ),
          ),
          SizedBox(width: 120, child: Stack(alignment: Alignment.center, children: [
            Positioned(bottom: 12, child: Container(width: 94, height: 78, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .1), blurRadius: 12)]), child: const Icon(Icons.savings_rounded, size: 54, color: AppColors.orange))),
            const Positioned(right: 2, bottom: 2, child: CircleAvatar(radius: 28, backgroundColor: Color(0xFF7699E9), child: Icon(Icons.schedule_rounded, color: Colors.white, size: 36))),
            const Positioned(top: 8, right: 25, child: CircleAvatar(radius: 13, backgroundColor: Color(0xFFFFB100), child: Icon(Icons.attach_money_rounded, size: 21, color: Colors.white))),
          ])),
        ]),
      );

  Widget _depositList(BuildContext context) => SoftCard(
        padding: const EdgeInsets.fromLTRB(24, 23, 24, 13),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Deposito Lainnya', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600)),
          const SizedBox(height: 18),
          _depositRow(context, 'Deposito SeaBank', 'Hingga 6% p.a'),
          const Divider(height: 29),
          _depositRow(context, 'Deposito Cashback Xtra', 'Cashback hingga\nRp161.300.000'),
        ]),
      );

  Widget _depositRow(BuildContext context, String title, String subtitle) => Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: AppColors.orange, fontSize: 20, fontWeight: FontWeight.w700)), const SizedBox(height: 8), Text(subtitle, style: const TextStyle(fontSize: 18, height: 1.3))])),
        const SizedBox(width: 10),
        SizedBox(width: 148, child: AppTextButton(label: 'Buka Deposito', onTap: () => _openDeposit(context))),
      ]);

  Widget _faq(BuildContext context) {
    const items = [
      'Berapa Bunga dan tenor Deposito SeaBank?',
      'Apa itu Produk Deposito Berjangka SeaBank?',
      'Bagaimana cara membuka Deposito?',
    ];
    return SoftCard(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Pertanyaan Umum', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600)),
        const SizedBox(height: 14),
        ...items.map((item) => _faqItem(context, item)),
        InkWell(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Menampilkan seluruh pertanyaan umum'))),
          child: const Padding(padding: EdgeInsets.symmetric(vertical: 22), child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [Text('Lihat lebih banyak', style: TextStyle(color: AppColors.muted, fontSize: 17)), SizedBox(width: 7), Icon(Icons.chevron_right_rounded, color: AppColors.muted)]))),
        ),
      ]),
    );
  }

  Widget _faqItem(BuildContext context, String item) => InkWell(
        onTap: () => showDialog<void>(context: context, builder: (_) => AlertDialog(title: Text(item), content: const Text('Informasi deposito tersedia langsung di aplikasi. Suku bunga dan ketentuan dapat berubah sesuai program yang berlaku.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Mengerti'))])),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 19),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.line))),
          child: Row(children: [Expanded(child: Text(item, style: const TextStyle(fontSize: 18, height: 1.3))), const Icon(Icons.chevron_right_rounded, color: AppColors.muted)]),
        ),
      );

  void _openDeposit(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (_) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Buka Deposito', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 23)),
            const SizedBox(height: 10),
            const Text('Pilih tenor dan nominal deposito Anda pada langkah berikutnya.'),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: AppTextButton(label: 'Mulai', onTap: () => Navigator.pop(context))),
          ]),
        ),
      );
}
