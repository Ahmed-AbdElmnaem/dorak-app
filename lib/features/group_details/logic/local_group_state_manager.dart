// features/group_details/logic/local_group_state_manager.dart
import 'package:dorak_app/features/group_details/data/model/member_model.dart';

class LocalGroupStateManager {
  final List<MemberModel> _members = [];
  final List<String> _deletedMemberIds = [];
  final List<String> _newMemberNames = [];
  final Map<String, Map<String, bool>> _localPaymentChanges = {};

  List<MemberModel> get members => List.unmodifiable(_members);
  List<String> get deletedMemberIds => List.unmodifiable(_deletedMemberIds);
  List<String> get newMemberNames => List.unmodifiable(_newMemberNames);
  Map<String, Map<String, bool>> get localPaymentChanges =>
      Map.unmodifiable(_localPaymentChanges);

  // Add this method to properly reset members
  void resetMembers(List<MemberModel> newMembers) {
    _members.clear();
    _members.addAll(newMembers);
  }

  void addMember(String name) {
    _newMemberNames.add(name);
    _members.add(MemberModel(id: '', name: name, payments: {}));
  }

  void deleteMember(MemberModel member) {
    if (member.id.isNotEmpty) _deletedMemberIds.add(member.id);
    _members.remove(member);
  }

  void updatePayment(String memberId, String paymentKey, bool value) {
    _localPaymentChanges.putIfAbsent(memberId, () => {});
    _localPaymentChanges[memberId]![paymentKey] = value;

    final member = _members.firstWhere(
      (m) => m.id == memberId,
      orElse: () => MemberModel(id: memberId, name: 'غير معروف', payments: {}),
    );
    member.payments[paymentKey] = value;
  }

  void updateMemberName(String memberId, String newName) {
    final member = _members.firstWhere((m) => m.id == memberId);
    member.name = newName;
  }

  void clearChanges() {
    _deletedMemberIds.clear();
    _newMemberNames.clear();
    _localPaymentChanges.clear();
  }
}
