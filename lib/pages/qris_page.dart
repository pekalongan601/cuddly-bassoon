import 'dart:math';

import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class QrisPage extends StatefulWidget {
  const QrisPage({super.key});

  @override
  State<QrisPage> createState() => _QrisPageState();
}

class _QrisPageState extends State<QrisPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(children: [
            Positioned.fill(child: Container(decoration: const BoxDecoration(gradient: RadialGradient(center: Alignment(0, -.1), radius: .95, colors: [Color(0xFF151515), Colors.black])))),
            Positioned(
              top: 22,
              left: 26,
              right: 26,
              child: Row(children: [
                IconButton(constraints: const BoxConstraints.tightFor(width: 42, height: 42), padding: EdgeInsets.zero, onPressed: () => Navigator.maybePop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 29)),
                const SizedBox(width: 8),
                const Expanded(child: FittedBox(alignment: Alignment.centerLeft, fit: BoxFit.scaleDown, child: Text('Scan QRIS', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700)))),
              ]),
            ),
            Center(
              child: Builder(
                builder: (context) {
                  final size = MediaQuery.sizeOf(context);
                  final verticalAllowance = size.height < 500 ? 164.0 : 262.0;
                  final square = min(size.width - 72, size.height - verticalAllowance)
                      .clamp(180.0, 420.0)
                      .toDouble();
                  return SizedBox(
                    width: square,
                    height: square,
                    child: Stack(children: [
                      Positioned.fill(child: CustomPaint(painter: _CornerPainter())),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) => Positioned(
                          left: 24,
                          right: 24,
                          top: 42 + (square - 84) * _controller.value,
                          child: Container(
                            height: 1.5,
                            decoration: BoxDecoration(
                              color: AppColors.orange.withValues(alpha: .65),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.orange.withValues(alpha: .6),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  );
                },
              ),
            ),
            const Align(alignment: Alignment(0, .2), child: Row(mainAxisSize: MainAxisSize.min, children: [Text('Scan Kode ', style: TextStyle(color: Colors.white, fontSize: 18)), Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 29)])),
            Positioned(
              left: 32,
              right: 32,
              bottom: MediaQuery.sizeOf(context).height < 500 ? 18 : 75,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _action(
                  _flashOn ? Icons.flashlight_on_rounded : Icons.flashlight_on_outlined,
                  'Flash',
                  () => setState(() => _flashOn = !_flashOn),
                  active: _flashOn,
                ),
                _action(Icons.qr_code_2_rounded, 'Tampilkan QR', () => _showQr(context)),
                _action(Icons.photo_outlined, 'Galeri', () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih kode QR dari galeri')))),
              ]),
            ),
          ]),
        ),
      );

  Widget _action(IconData icon, String label, VoidCallback onTap, {bool active = false}) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: label == 'Tampilkan QR' ? 130 : 75,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: active ? AppColors.orange : Colors.white, size: 39),
              const SizedBox(height: 14),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(color: active ? AppColors.orange : Colors.white, fontSize: 17),
              ),
            ],
          ),
        ),
      );

  void _showQr(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.white,
        showDragHandle: true,
        builder: (_) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('QR Saya', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            Container(height: 205, width: 205, color: Colors.black, child: const Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 190)),
            const SizedBox(height: 16),
            const Text('Tunjukkan kode ini untuk menerima pembayaran', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF676767))),
          ]),
        ),
      );
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 5.0;
    const length = 38.0;
    const inset = 4.0;
    final p = Paint()..color = AppColors.orange..strokeWidth = stroke..strokeCap = StrokeCap.square;
    canvas.drawLine(const Offset(inset, inset), const Offset(inset + length, inset), p);
    canvas.drawLine(const Offset(inset, inset), const Offset(inset, inset + length), p);
    canvas.drawLine(Offset(size.width - inset, inset), Offset(size.width - inset - length, inset), p);
    canvas.drawLine(Offset(size.width - inset, inset), Offset(size.width - inset, inset + length), p);
    canvas.drawLine(Offset(inset, size.height - inset), Offset(inset + length, size.height - inset), p);
    canvas.drawLine(Offset(inset, size.height - inset), Offset(inset, size.height - inset - length), p);
    canvas.drawLine(Offset(size.width - inset, size.height - inset), Offset(size.width - inset - length, size.height - inset), p);
    canvas.drawLine(Offset(size.width - inset, size.height - inset), Offset(size.width - inset, size.height - inset - length), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
