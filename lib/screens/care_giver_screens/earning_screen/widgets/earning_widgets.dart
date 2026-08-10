import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/care_giver_screens/care_giver_home_screen/controller/care_giver_home_controller.dart';
import 'package:carely_caregiver/screens/care_giver_screens/earning_screen/controller/earning_screen_controller.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class WeeklyEarningsChartCard extends StatelessWidget {
  final double totalEarnings;
  final List<WeeklyBarData> bars;

  const WeeklyEarningsChartCard({
    super.key,
    required this.totalEarnings,
    required this.bars,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: 'Weekly Earnings',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 4),
                  CommonText(
                    text: '\$${totalEarnings.toStringAsFixed(2)}',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    textColor: Colors.white,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Simple Bar Chart
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: bars.map((bar) => _Bar(data: bar)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final WeeklyBarData data;
  const _Bar({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 40 * data.value,
      decoration: BoxDecoration(
        color: data.isToday ? Colors.white : Colors.white.withAlpha(80),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class EarningInfoCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isLink;

  const EarningInfoCard({
    super.key,
    required this.label,
    required this.value,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.boxBg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              text: label,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              textColor: colors.secondaryText,
            ),
            const SizedBox(height: 8),
            CommonText(
              text: value,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              textColor: isLink ? colors.secondaryColor : colors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}

class EarningTransactionCard extends StatelessWidget {
  final EarningTransaction transaction;
  const EarningTransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    final isPending = transaction.status.toLowerCase() == 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.boxBg),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.secondaryColor.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.medical_services_outlined, color: colors.secondaryColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: transaction.title,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  textColor: colors.textPrimary,
                ),
                CommonText(
                  text: transaction.subtitle,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: colors.secondaryText,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CommonText(
                text: '+\$${transaction.amount.toStringAsFixed(2)}',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                textColor: colors.primary,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isPending ? colors.orange.withAlpha(20) : colors.success.withAlpha(20),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: CommonText(
                  text: transaction.status,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  textColor: isPending ? colors.orange : colors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
