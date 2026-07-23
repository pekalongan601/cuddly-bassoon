import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({super.key, required this.location});

  final String location;

  int get _selectedIndex {
    if (location.startsWith('/transfer')) return 1;
    if (location.startsWith('/qris')) return 2;
    if (location.startsWith('/deposit')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    const routes = ['/home', '/transfer', '/qris', '/deposit', '/profile'];
    const labels = ['Beranda', 'Bayar/Transfer', 'QRIS', 'Deposito', 'Saya'];
    const inactiveIcons = [
      Icons.home_outlined,
      Icons.swap_horiz_rounded,
      Icons.qr_code_scanner_rounded,
      Icons.savings_outlined,
      Icons.person_outline_rounded,
    ];
    const activeIcons = [
      Icons.home_rounded,
      Icons.swap_horiz_rounded,
      Icons.qr_code_scanner_rounded,
      Icons.savings_rounded,
      Icons.person_rounded,
    ];
    final selected = _selectedIndex;

    return SizedBox(
      height: 94,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 74,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .04),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(5, (index) {
                  final active = selected == index;
                  return Expanded(
                    child: _NavItem(
                      active: active,
                      center: index == 2,
                      icon: active ? activeIcons[index] : inactiveIcons[index],
                      label: labels[index],
                      onTap: () => context.go(routes[index]),
                    ),
                  );
                }),
              ),
            ),
          ),
          Semantics(
            button: true,
            selected: selected == 2,
            label: 'QRIS',
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () => context.go('/qris'),
                customBorder: const CircleBorder(),
                child: Container(
                  height: 62,
                  width: 62,
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.surface,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.orange.withValues(alpha: .25),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.active,
    required this.center,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool active;
  final bool center;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.orange : const Color(0xFF767676);
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (center)
              const SizedBox(height: 24)
            else
              Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
