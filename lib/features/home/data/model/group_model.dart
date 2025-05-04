import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorak_app/features/group_details/data/model/member_model.dart';

// فئة تمثل العضو
// class MemberModel {
//   final String id;
//   final String name;
//   final Map<String, bool> payments;

//   MemberModel({required this.id, required this.name, required this.payments});

//   Map<String, dynamic> toMap() {
//     return {'id': id, 'name': name, 'payments': payments};
//   }

//   factory MemberModel.fromMap(
//     Map<String, dynamic> map, {
//     required String memberId,
//   }) {
//     return MemberModel(
//       id: memberId,
//       name: map['name'] ?? 'بدون اسم',
//       payments:
//           (map['payments'] as Map<String, dynamic>?)?.map(
//             (key, value) => MapEntry(key, value as bool),
//           ) ??
//           {},
//     );
//   }

//   @override
//   String toString() {
//     return 'MemberModel{id: $id, name: $name, payments: $payments}';
//   }
// }

// تعديل الـ GroupModel ليشمل الأعضاء
class GroupModel {
  final String? id;
  final String name;
  final int membersCount;
  final double dailyAmount;
  final int cycleDays;
  final DateTime startDate;
  final DateTime endDate;

  GroupModel({
    this.id,
    required this.name,
    required this.membersCount,
    required this.dailyAmount,
    required this.cycleDays,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'membersCount': membersCount,
      'dailyAmount': dailyAmount,
      'cycleDays': cycleDays,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  static DateTime _parseDate(dynamic date) {
    if (date is Timestamp) return date.toDate();
    if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
    return DateTime.now();
  }

  factory GroupModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    List<MemberModel> members = [];
    if (map['members'] != null && map['members'] is List) {
      for (var memberMap in map['members']) {
        if (memberMap is Map<String, dynamic>) {
          members.add(
            MemberModel.fromMap(memberMap, memberId: memberMap['id'] ?? ''),
          );
        }
      }
    }

    return GroupModel(
      id: docId,
      name: map['name'] ?? 'بدون اسم',
      membersCount: map['membersCount'] ?? 0,
      dailyAmount: (map['dailyAmount'] ?? 0).toDouble(),
      cycleDays: map['cycleDays'] ?? 0,
      startDate: _parseDate(map['startDate']),
      endDate: _parseDate(map['endDate']),
    );
  }

  @override
  String toString() {
    return 'GroupModel{id: $id, name: $name, membersCount: $membersCount, dailyAmount: $dailyAmount, cycleDays: $cycleDays, startDate: $startDate, endDate: $endDate, }';
  }

  GroupModel copyWith({
    String? id,
    String? name,
    int? membersCount,
    double? dailyAmount,
    int? cycleDays,
    DateTime? startDate,
    DateTime? endDate,
    List<MemberModel>? members,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      membersCount: membersCount ?? this.membersCount,
      dailyAmount: dailyAmount ?? this.dailyAmount,
      cycleDays: cycleDays ?? this.cycleDays,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  List<DateTime> calculatePaymentDates() {
    final List<DateTime> dates = [];
    DateTime currentDate = startDate;

    for (int i = 0; i < membersCount; i++) {
      dates.add(currentDate);
      currentDate = currentDate.add(Duration(days: cycleDays));
    }

    return dates;
  }

  double get totalAmount => dailyAmount * cycleDays * membersCount;
}
