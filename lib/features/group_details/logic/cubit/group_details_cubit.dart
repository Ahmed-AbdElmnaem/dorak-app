// features/group_details/logic/cubit/group_details_cubit.dart
import 'package:dorak_app/core/helpers/date_helper.dart';
import 'package:dorak_app/features/group_details/data/model/member_model.dart';
import 'package:dorak_app/features/group_details/data/repo/group_details_repository.dart';
import 'package:dorak_app/features/group_details/logic/cubit/group_details_state.dart';
import 'package:dorak_app/features/group_details/logic/local_group_state_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupDetailsCubit extends Cubit<GroupDetailsState> {
  final GroupDetailsRepository _repository;
  final LocalGroupStateManager _localState;
  late List<DateTime> _paymentDates;

  GroupDetailsCubit(this._repository)
    : _localState = LocalGroupStateManager(),
      super(GroupDetailsInitial());

  Future<void> fetchGroupMembers({
    required String userId,
    required String groupId,
    required List<DateTime> paymentDates,
  }) async {
    emit(GroupDetailsLoading());
    _paymentDates = paymentDates;

    try {
      final members = await _repository.fetchMembers(userId, groupId);
      _localState.resetMembers(
        members,
      ); // Use public method instead of accessing _members directly

      emit(
        GroupDetailsLoaded(
          members: _localState.members,
          payments: _generatePaymentsTable(),
        ),
      );
    } catch (e) {
      emit(GroupDetailsError(message: 'فشل في تحميل بيانات الأعضاء'));
    }
  }

  void addMemberLocally(String name) {
    _localState.addMember(name);
    _emitUpdated();
  }

  void deleteMemberLocally(MemberModel member) {
    _localState.deleteMember(member);
    _emitUpdated();
  }

  void updatePaymentLocally({
    required String memberId,
    required String paymentKey,
    required bool value,
  }) {
    _localState.updatePayment(memberId, paymentKey, value);
    _emitUpdated();
  }

  Future<void> saveChanges({
    required String userId,
    required String groupId,
    required List<DateTime> paymentDates,
  }) async {
    emit(GroupDetailsLoading());

    try {
      for (final name in _localState.newMemberNames) {
        final payments = {
          for (var date in _paymentDates)
            DateHelper.toIso8601String(date): false,
        };
        await _repository.addMember(userId, groupId, name, payments);
      }

      // حذف الأعضاء
      for (final id in _localState.deletedMemberIds) {
        await _repository.deleteMember(userId, groupId, id);
      }

      // تحديث المدفوعات
      for (final entry in _localState.localPaymentChanges.entries) {
        await _repository.updatePayments(
          userId,
          groupId,
          entry.key,
          entry.value,
        );
      }

      _localState.clearChanges();
      emit(GroupDetailsUpdated(message: 'تم حفظ التغييرات بنجاح'));
    } catch (e) {
      emit(GroupDetailsError(message: 'فشل في حفظ البيانات'));
    }
  }

  List<List<bool>> _generatePaymentsTable() {
    return _localState.members.map((member) {
      return _paymentDates.map((date) {
        return member.payments[DateHelper.toIso8601String(date)] ?? false;
      }).toList();
    }).toList();
  }

  void _emitUpdated() {
    emit(
      GroupDetailsLoaded(
        members: _localState.members,
        payments: _generatePaymentsTable(),
      ),
    );
  }

  void updateMemberNameLocally(String memberId, String newName) {
    _localState.updateMemberName(memberId, newName);
    _emitUpdated();
  }

  Future<void> updateMemberName({
    required String userId,
    required String groupId,
    required String memberId,
    required String newName,
  }) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      await _repository.updateMemberName(
        userId: userId,
        groupId: groupId,
        memberId: memberId,
        newName: newName,
      );
      emit(
        GroupNameUpdated(message: 'تم تحديث الاسم بنجاح'),
      ); // تحديث الحالة بعد النجاح
    } catch (e) {
      print('❌ خطأ في تحديث الاسم: $e');
      emit(GroupDetailsError(message: e.toString()));
    }
  }
}
