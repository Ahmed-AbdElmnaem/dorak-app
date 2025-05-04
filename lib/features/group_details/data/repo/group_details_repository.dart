// features/group_details/data/repository/group_details_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorak_app/features/group_details/data/model/member_model.dart';

class GroupDetailsRepository {
  final FirebaseFirestore _firestore;

  GroupDetailsRepository(this._firestore);

  Future<List<MemberModel>> fetchMembers(String userId, String groupId) async {
    final snapshot =
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('groups')
            .doc(groupId)
            .collection('members')
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final rawPayments = data['payments'] as Map<String, dynamic>? ?? {};
      final safePayments = <String, bool>{};

      rawPayments.forEach((key, value) {
        if (value is bool) {
          safePayments[key] = value;
        }
      });

      return MemberModel(
        id: doc.id,
        name: data['name'] ?? '',
        payments: safePayments,
      );
    }).toList();
  }

  Future<String> addMember(
    String userId,
    String groupId,
    String name,
    Map<String, bool> payments,
  ) async {
    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('groups')
        .doc(groupId)
        .collection('members')
        .add({'name': name, 'payments': payments});

    return docRef.id;
  }

  Future<void> deleteMember(
    String userId,
    String groupId,
    String memberId,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('groups')
        .doc(groupId)
        .collection('members')
        .doc(memberId)
        .delete();
  }

  Future<void> updatePayments(
    String userId,
    String groupId,
    String memberId,
    Map<String, bool> payments,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('groups')
        .doc(groupId)
        .collection('members')
        .doc(memberId)
        .set({'payments': payments}, SetOptions(merge: true));
  }

  Future<void> updateMemberName({
    required String userId,
    required String groupId,
    required String memberId,
    required String newName,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .doc(memberId)
          .update({'name': newName});
    } catch (e) {
      rethrow;
    }
  }
}
