import 'package:dorak_app/features/group_details/logic/cubit/group_details_cubit.dart';
import 'package:dorak_app/features/group_details/logic/cubit/group_details_state.dart';
import 'package:dorak_app/features/group_details/ui/widget/group_info_card.dart';
import 'package:dorak_app/features/group_details/ui/widget/payments_data_table.dart';
import 'package:dorak_app/features/group_details/ui/widget/save_button.dart';
import 'package:dorak_app/features/home/data/model/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupDetailsScreen extends StatefulWidget {
  final String userId; // ✅ إضافة userId
  final List<DateTime> paymentDates;
  final GroupModel group;

  const GroupDetailsScreen({
    super.key,
    required this.userId,
    required this.paymentDates,
    required this.group,
  });

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  late final GroupDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = GroupDetailsCubit();
    _loadMembers();
  }

  void _loadMembers() {
    _cubit.fetchGroupMembers(
      userId: widget.userId,
      groupId: widget.group.id.toString(),
      paymentDates: widget.group.calculatePaymentDates(), // ← أهم خطوة!,
    );
  }

  void _showAddMemberDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("إضافة عضو جديد"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "اسم العضو",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("إلغاء"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("إضافة"),
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  await _cubit.addMembersToGroup(
                    userId: widget.userId,
                    groupId: widget.group.id.toString(),
                    memberNames: [name],
                    paymentDates: widget.paymentDates,
                  );
                  Navigator.pop(context);
                  _loadMembers();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text('تفاصيل المجموعة: ${widget.group.name}'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add),
              tooltip: 'إضافة عضو',
              onPressed: _showAddMemberDialog,
            ),
          ],
        ),
        body: BlocConsumer<GroupDetailsCubit, GroupDetailsState>(
          listener: (context, state) {
            if (state is GroupDetailsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state is GroupDetailsUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<GroupDetailsCubit>().fetchGroupMembers(
                userId: widget.userId,
                groupId: widget.group.id.toString(),
                paymentDates: widget.group.calculatePaymentDates(),
              );
            }
          },
          builder: (context, state) {
            if (state is GroupDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GroupDetailsLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GroupInfoCard(group: widget.group),
                    const SizedBox(height: 16),
                    PaymentsDataTable(
                      group: widget.group,
                      members: state.members,
                      paymentDates: widget.paymentDates,
                      payments: state.payments,
                      nameControllers:
                          state.members
                              .map((e) => TextEditingController(text: e.name))
                              .toList(),
                      onPaymentChanged: (memberIndex, paymentIndex, value) {
                        final member = state.members[memberIndex];
                        _cubit.updatePaymentStatus(
                          userId: widget.userId,
                          groupId: widget.group.id.toString(),
                          memberId: member.id,
                          paymentIndex:
                              widget.paymentDates[paymentIndex]
                                  .toIso8601String(),
                          value: value,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    SaveButton(
                      onPressed: () {
                        // إجراء معين عند الضغط
                      },
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('لا توجد بيانات.'));
          },
        ),
      ),
    );
  }
}
