import 'package:dorak_app/features/home/data/model/group_model.dart';

class GroupDetailsArgs {
  final GroupModel group;
  final List<DateTime> paymentDates;

  GroupDetailsArgs({required this.group, required this.paymentDates});
}
