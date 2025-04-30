import 'package:dorak_app/features/home/data/model/group_model.dart';
import 'package:equatable/equatable.dart';

abstract class GroupDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GroupDetailsInitial extends GroupDetailsState {}

class GroupDetailsLoading extends GroupDetailsState {}

class GroupDetailsLoaded extends GroupDetailsState {
  final List<MemberModel> members;
  final List<List<bool>> payments;

  GroupDetailsLoaded({required this.members, required this.payments});

  @override
  List<Object?> get props => [members, payments];
}

class GroupDetailsUpdated extends GroupDetailsState {
  final String message;

  GroupDetailsUpdated({required this.message});

  @override
  List<Object?> get props => [message];
}

class GroupDetailsError extends GroupDetailsState {
  final String message;

  GroupDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
