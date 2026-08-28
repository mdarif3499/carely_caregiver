import 'package:carely_caregiver/screens/care_giver_screens/earning_screen/controller/earning_screen_controller.dart';
import 'package:carely_caregiver/screens/care_giver_screens/earning_screen/widgets/earning_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:carely_caregiver/widgets/home_widgets.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../constant/app_colors.dart';

class EarningScreen extends StatelessWidget {
  const EarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<EarningScreenController>();
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Wallet & Earnings',
      hideBackButton: true,
      actions: [
     const   AppIconButton(
          icon: Icons.notifications_none_outlined,
          hasBadge: true,
        ),
        10.width,
      ],
      child: Obx(
        () => Skeletonizer(
          enabled: c.isLoading.value,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Weekly Earnings Large Card ───────────────
                WeeklyEarningsChartCard(
                  totalEarnings: c.totalWeeklyEarnings.value,
                  bars: c.weeklyBars,
                ),
                const SizedBox(height: 20),

                // ── Info Cards Row (Pending + Payout) ────────
                Row(
                  children: [
                    EarningInfoCard(
                      label: 'Pending Earnings',
                      value: '\$${c.pendingEarnings.value.toStringAsFixed(2)}',
                    ),
                    const SizedBox(width: 16),
                    EarningInfoCard(
                      label: 'Payout Methods',
                      value: c.payoutMethod.value,
                      isLink: true,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // ── Recent Transactions Header ───────────────
                CommonText(
                  text: 'Recent Transactions',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  textColor: colors.textPrimary,
                ),
                const SizedBox(height: 16),

                // ── Transaction List ─────────────────────────
                if (c.transactions.isEmpty && !c.isLoading.value)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: CommonText(
                        text: 'No transactions found.',
                        fontSize: 16,
                        textColor: Colors.grey,
                      ),
                    ),
                  )
                else
                  ...c.transactions.map((t) => EarningTransactionCard(transaction: t)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
