import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorak_app/features/group_details/logic/cubit/group_details_state.dart';
import 'package:dorak_app/features/home/data/model/group_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupDetailsCubit extends Cubit<GroupDetailsState> {
  GroupDetailsCubit() : super(GroupDetailsInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<DateTime> _paymentDates;

  Future<void> fetchGroupMembers({
    required String userId,
    required String groupId,
    required List<DateTime> paymentDates,
  }) async {
    emit(GroupDetailsLoading());
    _paymentDates = paymentDates;

    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('groups')
              .doc(groupId)
              .collection('members')
              .get();

      final members =
          snapshot.docs.map((doc) {
            final data = doc.data();
            final rawPayments = data['payments'] as Map<String, dynamic>? ?? {};
            final safePayments = <String, bool>{};

            rawPayments.forEach((key, value) {
              if (value is bool) {
                safePayments[key] = value;
              } else if (value is Map) {
                // لو القيمة Map (شكل خاطئ)، ناخد منها أول قيمة boolean فقط
                value.forEach((innerKey, innerVal) {
                  if (innerVal is bool) {
                    safePayments[innerKey] = innerVal;
                  }
                });
              }
            });

            return MemberModel(
              id: doc.id,
              name: data['name'] ?? '',
              payments: safePayments,
            );
          }).toList();

      final paymentsTable = _generatePaymentsTable(members);

      emit(GroupDetailsLoaded(members: members, payments: paymentsTable));
    } catch (e) {
      log('Error fetching group members: $e');
      emit(GroupDetailsError(message: 'فشل في تحميل بيانات الأعضاء'));
    }
  }

  Future<void> updatePaymentStatus({
    required String userId,
    required String groupId,
    required String memberId,
    required String paymentIndex,
    required bool value,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .doc(memberId);

      final snapshot = await docRef.get();

      if (!snapshot.exists) {
        emit(GroupDetailsError(message: 'العضو غير موجود'));
        return;
      }

      final data = snapshot.data()!;
      final oldPayments = Map<String, dynamic>.from(data['payments'] ?? {});

      // تنظيف الداتا: إزالة أي قيم nested
      final newPayments = <String, bool>{};
      oldPayments.forEach((key, val) {
        if (val is bool) {
          newPayments[key] = val;
        } else if (val is Map) {
          for (final entry in val.entries) {
            if (entry.key is String && entry.value is bool) {
              newPayments[entry.key] = entry.value;
            }
          }
        }
      });

      // تحديث القيمة المطلوبة
      newPayments[paymentIndex] = value;

      // حفظ الـ Map الجديد بالكامل
      await docRef.update({'payments': newPayments});

      emit(GroupDetailsUpdated(message: 'تم تحديث حالة الدفع بنجاح'));
      log('✅ Payment updated for $memberId → $paymentIndex = $value');
    } catch (e) {
      log('❌ Error updating payment status: $e');
      emit(GroupDetailsError(message: 'حدث خطأ أثناء تحديث حالة الدفع'));
    }
  }

  Future<void> addMembersToGroup({
    required String userId,
    required String groupId,
    required List<String> memberNames,
    required List<DateTime> paymentDates,
  }) async {
    try {
      final membersCollection = _firestore
          .collection('users')
          .doc(userId)
          .collection('groups')
          .doc(groupId)
          .collection('members');

      for (final name in memberNames) {
        final paymentsMap = {
          for (final date in paymentDates) date.toIso8601String(): false,
        };

        await membersCollection.add({'name': name, 'payments': paymentsMap});
      }

      emit(GroupDetailsUpdated(message: 'تمت إضافة الأعضاء'));
    } catch (e) {
      log('Error adding members: $e');
      emit(GroupDetailsError(message: 'فشل في إضافة الأعضاء'));
    }
  }

  List<List<bool>> _generatePaymentsTable(List<MemberModel> members) {
    return members.map((member) {
      return _paymentDates.map((date) {
        return member.payments[date.toIso8601String()] ?? false;
      }).toList();
    }).toList();
  }
}
