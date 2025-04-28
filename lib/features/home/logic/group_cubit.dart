import 'package:bloc/bloc.dart';
import 'package:dorak_app/features/home/data/model/group_model.dart';

part 'group_state.dart'; // هنجهزه كمان شوية

class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(GroupInitial());

  // باستخدام الـ state
  void addGroup(GroupModel group) {
    if (state is GroupLoaded) {
      final updatedGroups = List<GroupModel>.from((state as GroupLoaded).groups)
        ..add(group);
      emit(GroupLoaded(updatedGroups));
    } else {
      emit(GroupLoaded([group]));
    }
  }
}
