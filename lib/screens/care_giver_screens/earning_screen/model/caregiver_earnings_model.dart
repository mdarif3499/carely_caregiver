class CaregiverEarningsModel {
  final double weeklyTotal;
  final List<EarningBreakdown> weeklyBreakdown;
  final double pendingTotal;
  final double paidTotal;
  final String? payoutMethod;

  CaregiverEarningsModel({
    required this.weeklyTotal,
    required this.weeklyBreakdown,
    required this.pendingTotal,
    required this.paidTotal,
    this.payoutMethod,
  });

  factory CaregiverEarningsModel.fromJson(Map<String, dynamic> json) {
    final List breakdownList = json['weeklyBreakdown'] ?? [];
    return CaregiverEarningsModel(
      weeklyTotal: (json['weeklyTotal'] ?? 0.0).toDouble(),
      weeklyBreakdown: breakdownList.map((e) => EarningBreakdown.fromJson(e)).toList(),
      pendingTotal: (json['pendingTotal'] ?? 0.0).toDouble(),
      paidTotal: (json['paidTotal'] ?? 0.0).toDouble(),
      payoutMethod: json['payoutMethod'],
    );
  }
}

class EarningBreakdown {
  final String day;
  final double amount;

  EarningBreakdown({required this.day, required this.amount});

  factory EarningBreakdown.fromJson(Map<String, dynamic> json) {
    return EarningBreakdown(
      day: json['day'] ?? "",
      amount: (json['amount'] ?? 0.0).toDouble(),
    );
  }
}
