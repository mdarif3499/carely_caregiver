import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/privacy_policy_screen/widgets/privacy_policy_widgets.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Privacy Policy',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Last Updated Banner ──
            const LastUpdatedBanner(date: 'October 24, 2023'),
            const SizedBox(height: 24),

            // ── Intro Text ──
            CommonText(
              text: 'At CareConnect, your privacy is our highest priority. This policy explains how we collect, use, and safeguard the sensitive health and personal information shared within our home healthcare platform.',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              textColor: colors.textPrimary,
              textAlign: TextAlign.start,
              height: 1.5,
            ),
            const SizedBox(height: 32),

            // ── Section: Information We Collect ──
            const PolicySectionHeader(title: 'Information We Collect'),
            const SizedBox(height: 20),
            const BulletPointItem(
              title: 'Personal Identification',
              description: 'Full names, contact details, and government-issued identification for verification.',
            ),
            const BulletPointItem(
              title: 'Health & Wellness Data',
              description: 'Medical history, care requirements, medication schedules, and daily progress logs.',
            ),
            const BulletPointItem(
              title: 'Location Services',
              description: 'GPS data for caregiver arrival tracking and home visit coordination.',
            ),
            const SizedBox(height: 16),

            // ── Section: How We Use Your Data ──
            const PolicySectionHeader(title: 'How We Use Your Data'),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  CheckmarkItem(text: 'To facilitate caregiver matching based on patient needs.'),
                  CheckmarkItem(text: 'To provide emergency notification services to family members.'),
                  CheckmarkItem(text: 'To process payments and manage insurance claims.'),
                  CheckmarkItem(text: 'To improve our care protocols via anonymized analytics.'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── Section: Data Security ──
            const PolicySectionHeader(title: 'Data Security'),
            const SizedBox(height: 20),
            const SecurityBox(
              text: 'All health-related information is stored with AES-256 bit encryption. Our servers are HIPAA-compliant and undergo quarterly security audits by third-party experts. We never sell your personal data to advertisers.',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
