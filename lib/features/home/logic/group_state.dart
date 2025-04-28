part of 'group_cubit.dart';

abstract class GroupState {}

class GroupInitial extends GroupState {}

class GroupLoaded extends GroupState {
  final List<GroupModel> groups;

  GroupLoaded(this.groups);
}
