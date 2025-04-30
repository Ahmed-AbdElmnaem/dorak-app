part of 'groups_cubit.dart';

abstract class GroupsState {}

class GroupInitial extends GroupsState {}

class GroupLoading extends GroupsState {
  final String action;
  GroupLoading({required this.action});
}

class GroupDataLoaded extends GroupsState {
  final List<GroupModel> groups;

  GroupDataLoaded({required this.groups});
}

class GroupDataError extends GroupsState {
  final String message;
  GroupDataError({required this.message});
}

class AddGroupLoading extends GroupsState {}

class AddGroupSuccess extends GroupsState {
  final GroupModel group;
  AddGroupSuccess(this.group);
}

class AddGroupFailure extends GroupsState {
  final String message;
  AddGroupFailure({required this.message});
}

class GroupUpdatedSuccess extends GroupsState {
  final GroupModel group;
  GroupUpdatedSuccess(this.group);
}

class GroupDeletedSuccess extends GroupsState {
  final String groupId;
  GroupDeletedSuccess(this.groupId);
}
