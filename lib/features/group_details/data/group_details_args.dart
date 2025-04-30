import 'package:dorak_app/features/home/data/model/group_model.dart';

class GroupDetailsArgs {
  final GroupModel group;
  final List<DateTime> paymentDates;
  final String userId;

  GroupDetailsArgs({
    required this.userId,
    required this.group,
    required this.paymentDates,
  });
}
