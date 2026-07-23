import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/promotion.dart';
import '../models/recipient.dart';

abstract final class MockData {
  static const recipients = <Recipient>[
    Recipient(
      name: 'Suparno',
      detail: 'GoPay: 088994509477',
      color: Color(0xFF49A8D1),
      icon: Icons.account_balance_wallet_rounded,
    ),
    Recipient(
      name: 'Aris Prasetiawan',
      detail: 'BRI: 650401026858532',
      color: AppColors.orange,
      icon: Icons.person_rounded,
    ),
    Recipient(
      name: 'Diaz Arman Maulana',
      detail: 'NEO COMMERCE...',
      color: AppColors.orange,
      icon: Icons.person_rounded,
    ),
    Recipient(
      name: 'Kuota 4 Gb 3 Hari',
      detail: 'No. Handphone: 088994509477',
      color: Color(0xFF24AF55),
      icon: Icons.sim_card_rounded,
    ),
    Recipient(
      name: 'Toko Maju Bersama',
      detail: 'BCA: 0127869912',
      color: Color(0xFF1A77BE),
      icon: Icons.storefront_rounded,
    ),
  ];

  static const flashDeals = <DepositPromotion>[
    DepositPromotion(term: '12 bulan', rate: '8% p.a.', previousRate: '6% p.a.', quota: '500 kuota'),
    DepositPromotion(term: '6 bulan', rate: '6,7% p.a.', previousRate: '5,75% p.a.', quota: '1,500 kuota'),
    DepositPromotion(term: '3 bulan', rate: '6,2% p.a.', previousRate: '5,25% p.a.', quota: '2,000 kuota'),
  ];
}
