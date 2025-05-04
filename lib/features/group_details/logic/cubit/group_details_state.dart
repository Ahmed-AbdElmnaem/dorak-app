// features/group_details/logic/cubit/group_details_state.dart
import 'package:dorak_app/features/group_details/data/model/member_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class GroupDetailsState {}

class GroupDetailsInitial extends GroupDetailsState {}

class GroupDetailsLoading extends GroupDetailsState {}

class GroupDetailsLoaded extends GroupDetailsState {
  final List<MemberModel> members;
  final List<List<bool>> payments;

  GroupDetailsLoaded({required this.members, required this.payments});

  GroupDetailsLoaded copyWith({
    List<MemberModel>? members,
    List<List<bool>>? payments,
  }) {
    return GroupDetailsLoaded(
      members: members ?? this.members,
      payments: payments ?? this.payments,
    );
  }
}

class GroupDetailsUpdated extends GroupDetailsState {
  final String message;

  GroupDetailsUpdated({required this.message});
}

class GroupDetailsError extends GroupDetailsState {
  final String message;

  GroupDetailsError({required this.message});
}

class GroupNameUpdated extends GroupDetailsState {
  final String message;

  GroupNameUpdated({required this.message});
}
