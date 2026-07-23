import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/layout.dart';

class SoftCard extends StatelessWidget {
  const SoftCard({super.key, required this.child, this.padding, this.margin, this.radius = Layout.cardRadius, this.color, this.onTap});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Container(
        margin: margin,
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.045), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(radius),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
          ),
        ),
      );
}

class OrangeCircleIcon extends StatelessWidget {
  const OrangeCircleIcon({super.key, required this.icon, this.size = 42, this.iconSize = 24, this.background});
  final IconData icon;
  final double size;
  final double iconSize;
  final Color? background;

  @override
  Widget build(BuildContext context) => Container(
        height: size,
        width: size,
        decoration: BoxDecoration(color: background ?? AppColors.palePeach, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Icon(icon, size: iconSize, color: AppColors.orange),
      );
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.size = 62, this.color = AppColors.orange, this.iconColor = Colors.white});
  final double size;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(Icons.person_rounded, color: iconColor, size: size * .68),
      );
}

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key, this.dark = false});
  final bool dark;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 70,
        width: 70,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                shape: CircleBorder(side: BorderSide(color: dark ? Colors.white70 : const Color(0xFFB5B5B5))),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak ada notifikasi baru'))),
                  child: Icon(Icons.notifications_none_rounded, color: dark ? Colors.white : AppColors.ink, size: 32),
                ),
              ),
            ),
            Positioned(
              right: -2,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle),
                child: const Text('25', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      );
}

class AppTextButton extends StatelessWidget {
  const AppTextButton({super.key, required this.label, required this.onTap, this.filled = true, this.height = 48});
  final String label;
  final VoidCallback onTap;
  final bool filled;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        child: filled
            ? FilledButton(
                onPressed: onTap,
                style: FilledButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
                child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              )
            : OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.orange, side: const BorderSide(color: AppColors.orange, width: 1.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
                child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              ),
      );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.text, this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(child: Text(text, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700))),
          if (trailing != null) trailing!,
        ],
      );
}
