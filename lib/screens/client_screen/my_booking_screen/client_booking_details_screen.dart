import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/client_screen/my_booking_screen/controller/client_booking_details_controller.dart';
import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class ClientBookingDetailsScreen extends StatelessWidget {
  const ClientBookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ClientBookingDetailsController());
    final colors = AppColors.instance;

    return DefaultBackgroundTemplate(
      appBarTitle: 'Booking Details',
      child: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final b = c.booking.value;
        if (b == null) {
          return const Center(child: CommonText(text: "Booking not found"));
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Caregiver Header ──
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: colors.boxBg,
                          backgroundImage: b.caregiverAvatar.isNotEmpty ? NetworkImage(b.caregiverAvatar) : null,
                          child: b.caregiverAvatar.isEmpty ? Icon(Icons.person, color: colors.primary, size: 40) : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText(
                                text: b.caregiverName,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                textColor: colors.textPrimary,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                                  const SizedBox(width: 4),
                                  CommonText(
                                    text: "4.9 (120 reviews)", // Fallback if rating not in model
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    textColor: colors.secondaryText,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 16, color: colors.secondaryText),
                                  const SizedBox(width: 4),
                                  CommonText(
                                    text: "New York, NY", // Fallback
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    textColor: colors.secondaryText,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // ── Schedule & Price Card ──
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colors.boxBg),
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CommonText(
                                text: 'SCHEDULE',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                textColor: Color(0xff7F8C8D),
                              ),
                              const CommonText(
                                text: 'TOTAL PAID',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                textColor: Color(0xff7F8C8D),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonText(
                                text: _formatDate(b.date),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                textColor: colors.textPrimary,
                              ),
                              CommonText(
                                text: '\$${b.amount.toStringAsFixed(2)}',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                textColor: colors.secondaryColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CommonText(
                              text: b.formattedTimeRange,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textColor: colors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Care Details ──
                    const CommonText(
                      text: 'Care Details',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 16),
                    _DetailRow(
                      icon: Icons.medical_services_outlined,
                      label: 'Service:',
                      value: b.serviceName,
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.person_outline_rounded,
                      label: 'For:',
                      value: '${b.recipientName} (${b.relationship})',
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.info_outline_rounded,
                      label: 'Status:',
                      value: b.status.replaceAll('_', ' '),
                      isStatus: true,
                    ),
                    const SizedBox(height: 32),

                    // ── Instructions ──
                    if (b.instructions.isNotEmpty) ...[
                      const CommonText(
                        text: 'Additional Instructions',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.boxBg.withAlpha(30),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: CommonText(
                          text: b.instructions,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          textColor: colors.textPrimary,
                          textAlign: TextAlign.start,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ── Chat Button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: CommonButton(
                titleText: 'Chat with Caregiver',
                onTap: c.onChat,
                prefix: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 20),
                buttonWidth: double.infinity,
                buttonHeight: 56,
                buttonRadius: 16,
              ),
            ),
          ],
        );
      }),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('EEEE, MMM d').format(dt);
    } catch (_) {
      return dateStr;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isStatus;

  const _DetailRow({required this.icon, required this.label, required this.value, this.isStatus = false});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.instance;
    return Row(
      children: [
        Icon(icon, size: 20, color: colors.primary),
        const SizedBox(width: 12),
        CommonText(
          text: label,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          textColor: colors.secondaryText,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CommonText(
            text: value,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            textColor: isStatus ? colors.primary : colors.textPrimary,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
