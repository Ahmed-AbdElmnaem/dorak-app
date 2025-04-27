class GroupModel {
  final String name;
  final int membersCount;
  final double dailyAmount;
  final int cycleDays;
  final DateTime startDate;
  final DateTime endDate;

  GroupModel({
    required this.name,
    required this.membersCount,
    required this.dailyAmount,
    required this.cycleDays,
    required this.startDate,
    required this.endDate,
  });
  double get totalAmount => dailyAmount * cycleDays * membersCount;
  List<DateTime> calculatePaymentDates() {
    List<DateTime> dates = [];
    DateTime currentDate = startDate;
    for (int i = 0; i < membersCount; i++) {
      dates.add(currentDate);
      currentDate = currentDate.add(Duration(days: cycleDays));
    }
    return dates;
  }
}
