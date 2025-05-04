import 'dart:developer';

import 'package:dorak_app/features/home/data/model/group_model.dart';
import 'package:dorak_app/features/home/data/repo/groups_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'groups_state.dart';

class GroupsCubit extends Cubit<GroupsState> {
  final GroupsRepository _repo;

  GroupsCubit(this._repo) : super(GroupInitial());

  Future<void> addGroup(GroupModel group, String uid) async {
    emit(GroupLoading(action: "إضافة مجموعة"));
    try {
      final addedGroup = await _repo.addGroup(group, uid);
      emit(AddGroupSuccess(addedGroup));
    } catch (e) {
      emit(AddGroupFailure(message: "حدث خطأ أثناء إضافة المجموعة"));
      log(e.toString());
    }
  }

  Future<void> fetchGroups(String uid) async {
    emit(GroupLoading(action: "جلب المجموعات"));
    try {
      final groups = await _repo.fetchGroups(uid);
      emit(GroupDataLoaded(groups: groups));
    } catch (e) {
      emit(GroupDataError(message: "حدث خطأ أثناء جلب المجموعات"));
    }
  }

  Future<void> deleteGroup(String uid, String groupId) async {
    emit(GroupLoading(action: "حذف مجموعة"));
    try {
      await _repo.deleteGroup(uid, groupId);
      await fetchGroups(uid); // إعادة تحميل
    } catch (e) {
      emit(GroupDataError(message: 'حدث خطأ أثناء الحذف'));
    }
  }
}
