import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorak_app/features/home/data/model/group_model.dart';

class GroupsRepository {
  final FirebaseFirestore firestore;

  GroupsRepository(this.firestore);

  Future<GroupModel> addGroup(GroupModel group, String uid) async {
    final docRef = await firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .add(group.toMap());
    return group.copyWith(id: docRef.id);
  }

  Future<List<GroupModel>> fetchGroups(String uid) async {
    final snapshot =
        await firestore.collection('users').doc(uid).collection('groups').get();

    return snapshot.docs
        .map((doc) => GroupModel.fromMap(doc.data(), docId: doc.id))
        .toList();
  }

  Future<void> deleteGroup(String uid, String groupId) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .doc(groupId)
        .delete();
  }
}
