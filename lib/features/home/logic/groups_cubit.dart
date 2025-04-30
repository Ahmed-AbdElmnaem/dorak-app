import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorak_app/features/home/data/model/group_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'groups_state.dart';

class GroupsCubit extends Cubit<GroupsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GroupsCubit() : super(GroupInitial());

  // إضافة مجموعة جديدة
  Future<void> addGroup(GroupModel group, String uid) async {
    try {
      emit(GroupLoading(action: "إضافة مجموعة"));

      final docRef = await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .add(group.toMap());

      final addedGroup = group.copyWith(id: docRef.id);

      // بدل fetch، ممكن تبعت الحالة دي لو عندك مجموعة قديمة في الـ state
      emit(AddGroupSuccess(addedGroup));
    } catch (e) {
      emit(AddGroupFailure(message: "حدث خطأ أثناء إضافة المجموعة"));
      log("Firebase Add Error: ${e.toString()}");
    }
  }

  // جلب المجموعات من Firestore
  Future<List<GroupModel>> fetchGroups(String uid) async {
    try {
      emit(GroupLoading(action: "جلب المجموعات"));

      final groups =
          await _firestore
              .collection('users')
              .doc(uid)
              .collection('groups')
              .get();

      List<GroupModel> groupList =
          groups.docs
              .map((doc) => GroupModel.fromMap(doc.data(), docId: doc.id))
              .toList();

      emit(GroupDataLoaded(groups: groupList));
      log("Fetched groups: ${groupList.toString()}");

      return groupList;
    } catch (e) {
      emit(GroupDataError(message: "حدث خطأ أثناء جلب المجموعات"));
      log("Error in fetching groups: $e");
      return [];
    }
  }
}
