import 'package:get/get.dart';
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
  final RxDouble totalWeeklyEarnings = 1248.50.obs;
  final RxDouble pendingEarnings = 350.00.obs;
  final String payoutMethod = 'Bank ... 4231';

  final RxList<WeeklyBarData> weeklyBars = <WeeklyBarData>[].obs;

  final List<EarningTransaction> transactions = const [
    EarningTransaction(
      title: 'Home Visit - Sarah J.',
      subtitle: 'Oct 24 . 2h Nursing Care',
      amount: 85.00,
      status: 'Completed',
    ),
    EarningTransaction(
      title: 'Home Visit - Mark T.',
      subtitle: 'Oct 23 . 3h Dementia Care',
      amount: 105.00,
      status: 'Completed',
    ),
    EarningTransaction(
      title: 'Home Visit - Linda M.',
      subtitle: 'Oct 22 . 2h Post-Op Support',
      amount: 85.00,
      status: 'Completed',
    ),
    EarningTransaction(
      title: 'Home Visit - James W.',
      subtitle: 'Oct 21 . 2h Medication Mgmt',
      amount: 85.00,
      status: 'Pending',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadWeeklyData();
  }

  void _loadWeeklyData() {
    weeklyBars.assignAll([
      const WeeklyBarData(day: 'Mon', value: 0.45),
      const WeeklyBarData(day: 'Tue', value: 0.55),
      const WeeklyBarData(day: 'Wed', value: 0.35),
      const WeeklyBarData(day: 'Thu', value: 0.60),
      const WeeklyBarData(day: 'Fri', value: 0.50),
      const WeeklyBarData(day: 'Sat', value: 0.65),
      const WeeklyBarData(day: 'Sun', value: 0.90, isToday: true),
    ]);
  }
}
