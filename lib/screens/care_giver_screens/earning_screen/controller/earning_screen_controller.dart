import 'package:carely_caregiver/repositories/caregiver_repository.dart';
import 'package:carely_caregiver/screens/care_giver_screens/earning_screen/model/caregiver_earnings_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../care_giver_home_screen/controller/care_giver_home_controller.dart';

// ─────────────────────────────────────────────
//  Model
// ─────────────────────────────────────────────
class EarningTransaction {
  final String title;
  final String subtitle;
  final double amount;
  final String status;

  const EarningTransaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.status,
  });
}

// ─────────────────────────────────────────────
//  Controller
// ─────────────────────────────────────────────
class EarningScreenController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxDouble totalWeeklyEarnings = 0.0.obs;
  final RxDouble pendingEarnings = 0.0.obs;
  final RxString payoutMethod = 'Not set'.obs;

  final RxList<WeeklyBarData> weeklyBars = <WeeklyBarData>[].obs;
  final RxList<EarningTransaction> transactions = <EarningTransaction>[].obs;

  @override
  void onInit() {
    super.onInit();
    _setPlaceholders();
    _loadAllData();
  }

  void _setPlaceholders() {
    weeklyBars.value = List.generate(7, (index) => WeeklyBarData(
      day: DateFormat('EEE').format(DateTime.now().add(Duration(days: index))),
      value: 0.5,
    ));
    
    transactions.assignAll([
      const EarningTransaction(
        title: 'Home Visit - Sarah J.',
        subtitle: 'Oct 24 . 2h Nursing Care',
        amount: 85.00,
        status: 'Completed',
      ),
      const EarningTransaction(
        title: 'Home Visit - Mark T.',
        subtitle: 'Oct 23 . 3h Dementia Care',
        amount: 105.00,
        status: 'Completed',
      ),
    ]);
  }

  Future<void> _loadAllData() async {
    try {
      isLoading.value = true;
      update();
      await Future.wait([
        fetchEarningsSummary(),
        fetchEarnings(),
      ]);
    } catch (e) {
      debugPrint("Error loading earnings data: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> fetchEarningsSummary() async {
    try {
      final response = await CaregiverRepository.instance.getEarningsSummary();

      if (response.isSuccess) {
        final model = CaregiverEarningsModel.fromJson(response.data['data'] ?? {});
        
        totalWeeklyEarnings.value = model.paidTotal;
        pendingEarnings.value = model.pendingTotal;
        payoutMethod.value = model.payoutMethod ?? "Not set";

        // Map breakdown to bars
        final List<WeeklyBarData> bars = [];
        final String currentDay = DateFormat('EEE').format(DateTime.now());

        double maxAmount = 0;
        for (var e in model.weeklyBreakdown) {
          if (e.amount > maxAmount) maxAmount = e.amount;
        }

        for (var e in model.weeklyBreakdown) {
          bars.add(WeeklyBarData(
            day: e.day,
            value: maxAmount > 0 ? (e.amount / maxAmount).clamp(0.1, 1.0) : 0.1,
            isToday: e.day.toLowerCase() == currentDay.toLowerCase(),
          ));
        }
        weeklyBars.assignAll(bars);
      }
    } catch (e) {
      debugPrint("Error fetching earnings summary: $e");
    }
  }

  Future<void> fetchEarnings() async {
    try {
      final response = await CaregiverRepository.instance.getEarnings();

      if (response.isSuccess) {
        final List dataList = response.data['data']?['data'] ?? [];
        final List<EarningTransaction> items = [];

        for (var json in dataList) {
          final booking = json['booking'] ?? {};
          final client = booking['client'] ?? {};
          final service = booking['serviceCategory'] ?? {};

          String formattedDate = "";
          try {
             final dt = DateTime.parse(booking['date']);
             formattedDate = DateFormat('MMM d').format(dt);
          } catch (_) {
             formattedDate = booking['date']?.toString().split('T')[0] ?? "";
          }

          int duration = 0;
          try {
            final start = int.parse(booking['slotStartTime'].split(':')[0]);
            final end = int.parse(booking['slotEndTime'].split(':')[0]);
            duration = end - start;
          } catch (_) {}

          items.add(EarningTransaction(
            title: 'Home Visit - ${client['name'] ?? 'Unknown'}',
            subtitle: '$formattedDate . ${duration}h ${service['name'] ?? 'General Care'}',
            amount: (json['amount'] ?? 0.0).toDouble(),
            status: _formatStatus(json['status'] ?? 'PENDING', booking['status'] ?? ""),
          ));
        }
        transactions.assignAll(items);
      }
    } catch (e) {
      debugPrint("Error fetching earnings list: $e");
    }
  }

  String _formatStatus(String earningStatus, String bookingStatus) {
    if (bookingStatus.toUpperCase() == 'COMPLETED' || earningStatus.toUpperCase() == 'PAID') {
       return 'Completed';
    }
    String text = earningStatus.toLowerCase();
    if (text.isEmpty) return "";
    return text[0].toUpperCase() + text.substring(1);
  }
}
