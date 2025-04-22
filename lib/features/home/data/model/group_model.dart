// lib/features/home/data/model/group_model.dart

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
}
