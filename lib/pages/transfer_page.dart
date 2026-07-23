import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/recipient.dart';
import '../services/mock_data.dart';
import '../widgets/common.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  bool _favorite = false;
  String _query = '';

  List<Recipient> get _shownRecipients {
    final query = _query.toLowerCase();
    return MockData.recipients.where((r) => !_favorite || r.name == 'Suparno' || r.name == 'Aris Prasetiawan').where((r) => r.name.toLowerCase().contains(query) || r.detail.toLowerCase().contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned.fill(child: Container(color: Theme.of(context).scaffoldBackgroundColor)),
          const Positioned(top: 0, left: 0, right: 0, height: 365, child: ColoredBox(color: AppColors.orange)),
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              key: const PageStorageKey('transfer-scroll'),
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 15, 24, 24),
                  sliver: SliverList(delegate: SliverChildListDelegate([
                    const Row(children: [Expanded(child: Text('Bayar/Transfer', style: TextStyle(color: Colors.white, fontSize: 31, fontWeight: FontWeight.w600))), NotificationButton(dark: true)]),
                    const SizedBox(height: 33),
                    _transferOptions(),
                    const SizedBox(height: 24),
                    _recipientPanel(),
                    const SizedBox(height: 25),
                  ])),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _transferOptions() {
    const actions = [
      _TransferAction('SeaBank', Icons.sailing_rounded),
      _TransferAction('Bank Lain', Icons.account_balance_rounded),
      _TransferAction('Virtual\nAccount', Icons.confirmation_number_rounded),
      _TransferAction('Top Up\nE-Wallet', Icons.account_balance_wallet_rounded, 'Baru'),
      _TransferAction('Top Up &\nTagihan', Icons.receipt_long_rounded),
      _TransferAction('Transfer\nGrup', Icons.group_add_rounded),
      _TransferAction('Transfer\nTerjadwal', Icons.event_available_rounded),
      _TransferAction('Tampilkan\nQR Bayar', Icons.qr_code_2_rounded),
    ];
    return SoftCard(
      radius: 14,
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.only(left: 8), child: Text('Transfer ke', style: TextStyle(fontSize: 29, fontWeight: FontWeight.w600))),
        const SizedBox(height: 23),
        GridView.builder(
          itemCount: actions.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisExtent: 138),
          itemBuilder: (_, index) => _actionButton(actions[index]),
        ),
      ]),
    );
  }

  Widget _actionButton(_TransferAction action) => InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showAction(action.label.replaceAll('\n', ' ')),
        child: Column(children: [
          Stack(clipBehavior: Clip.none, children: [
            OrangeCircleIcon(icon: action.icon, size: 54, iconSize: 29),
            if (action.badge != null) Positioned(right: -26, top: -6, child: Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFFD5A2), borderRadius: BorderRadius.circular(7)), child: Text(action.badge!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF633100))))),
          ]),
          const SizedBox(height: 9),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topCenter,
              child: Text(action.label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, height: 1.12, color: Color(0xFF626262))),
            ),
          ),
        ]),
      );

  Widget _recipientPanel() => SoftCard(
        radius: 15,
        padding: const EdgeInsets.only(top: 0),
        child: Column(children: [
          SizedBox(
            height: 83,
            child: Row(children: [
              Expanded(child: _tab('Terakhir', !_favorite, () => setState(() => _favorite = false))),
              Expanded(child: _tab('Favorit', _favorite, () => setState(() => _favorite = true))),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(hintText: 'Cari penerima di sini', hintStyle: TextStyle(color: Color(0xFFC6C6C6), fontSize: 18), prefixIcon: Icon(Icons.search_rounded, size: 30, color: Color(0xFF666666)), contentPadding: EdgeInsets.symmetric(vertical: 2)),
            ),
          ),
          if (_shownRecipients.isEmpty)
            const Padding(padding: EdgeInsets.all(45), child: Text('Penerima tidak ditemukan', style: TextStyle(color: AppColors.muted)))
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 7, 24, 9),
              itemCount: _shownRecipients.length,
              separatorBuilder: (context, index) => const Divider(height: 21),
              itemBuilder: (_, index) => _recipientTile(_shownRecipients[index]),
            ),
        ]),
      );

  Widget _tab(String label, bool active, VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: active ? AppColors.orange : const Color(0xFFE4E4E4), width: active ? 4 : 1))),
          child: Text(label, style: TextStyle(fontSize: 23, fontWeight: active ? FontWeight.w600 : FontWeight.w500, color: active ? AppColors.orange : const Color(0xFF292929))),
        ),
      );

  Widget _recipientTile(Recipient recipient) => InkWell(
        onTap: () => _showRecipient(recipient),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Row(children: [
            Container(width: 59, height: 59, decoration: BoxDecoration(color: recipient.color, shape: BoxShape.circle), alignment: Alignment.center, child: Icon(recipient.icon, color: Colors.white, size: 33)),
            const SizedBox(width: 20),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(recipient.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)), const SizedBox(height: 5), Text(recipient.detail, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, color: AppColors.muted))])),
            const Icon(Icons.star_border_rounded, color: Color(0xFFFFC400), size: 34),
          ]),
        ),
      );

  void _showAction(String label) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label dipilih')));

  void _showRecipient(Recipient recipient) => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Transfer ke ${recipient.name}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(recipient.detail, style: const TextStyle(color: AppColors.muted)),
            const SizedBox(height: 22),
            SizedBox(width: double.infinity, child: AppTextButton(label: 'Lanjutkan', onTap: () => Navigator.pop(context))),
          ]),
        ),
      );
}

class _TransferAction {
  const _TransferAction(this.label, this.icon, [this.badge]);
  final String label;
  final IconData icon;
  final String? badge;
}
