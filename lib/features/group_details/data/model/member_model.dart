class MemberModel {
  final String id;
  String name;
  final Map<String, bool> payments;

  MemberModel({required this.id, required this.name, required this.payments});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'payments': payments};
  }

  factory MemberModel.fromMap(
    Map<String, dynamic> map, {
    required String memberId,
  }) {
    return MemberModel(
      id: memberId,
      name: map['name'] ?? 'بدون اسم',
      payments:
          (map['payments'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value as bool),
          ) ??
          {},
    );
  }

  MemberModel copyWith({
    String? id,
    String? name,
    Map<String, bool>? payments,
  }) {
    return MemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      payments: payments ?? Map<String, bool>.from(this.payments),
    );
  }

  @override
  String toString() {
    return 'MemberModel{id: $id, name: $name, payments: $payments}';
  }
}
