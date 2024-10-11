import 'package:eschool_teacher/cubits/deleteLeaveCubit.dart';
import 'package:eschool_teacher/cubits/leavesCubit.dart';
import 'package:eschool_teacher/data/models/leave.dart';
import 'package:eschool_teacher/data/repositories/leaveRepository.dart';
import 'package:eschool_teacher/ui/screens/leave/widgets/leaveDetailsBottomsheetContainer.dart';
import 'package:eschool_teacher/ui/styles/colors.dart';
import 'package:eschool_teacher/ui/widgets/confirmDeleteDialog.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveContainer extends StatelessWidget {
  final Leave leave;
  final int index;
  const LeaveContainer({super.key, required this.leave, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary.withOpacity(.1),
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  (index + 1).toString().padLeft(2, '0'),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  leave.formattedDateRange(context: context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: leave.statusColor.withOpacity(.1),
                ),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  UiUtils.getTranslatedLabel(context, leave.statusKey),
                  style: TextStyle(
                      color: leave.statusColor, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Divider(
            color: Theme.of(context).colorScheme.secondary.withOpacity(.1),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            UiUtils.getTranslatedLabel(context, leaveReasonKey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            leave.reason,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.76),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Divider(
            color: Theme.of(context).colorScheme.secondary.withOpacity(.1),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "${UiUtils.getTranslatedLabel(context, totalDaysKey)} : ${leave.days.toString().endsWith('.0') ? leave.days.toStringAsFixed(0).padLeft(2, '0') : leave.days.toStringAsFixed(1)}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              if (leave.showDeleteButton) ...[
                BlocProvider<DeleteLeaveCubit>(
                  create: (context) => DeleteLeaveCubit(LeaveRepository()),
                  child: Builder(builder: (context) {
                    return BlocConsumer<DeleteLeaveCubit, DeleteLeaveState>(
                      listener: (context, state) {
                        if (state is DeleteLeaveSuccess) {
                          context
                              .read<LeaveCubit>()
                              .removeLeave(leaveId: leave.id);
                        } else if (state is DeleteLeaveFailure) {
                          UiUtils.showBottomToastOverlay(
                            context: context,
                            errorMessage: UiUtils.getErrorMessageFromErrorCode(
                              context,
                              state.errorMessage,
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          );
                        }
                      },
                      builder: (context, state) {
                        return InkWell(
                          onTap: () {
                            if (state is DeleteLeaveInProgress) {
                              return;
                            }
                            showDialog<bool>(
                              context: context,
                              builder: (_) => const ConfirmDeleteDialog(),
                            ).then((value) {
                              if (value != null && value) {
                                context
                                    .read<DeleteLeaveCubit>()
                                    .deleteLeave(leaveId: leave.id);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: redColor.withOpacity(0.1),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: state is DeleteLeaveInProgress
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Padding(
                                      padding: EdgeInsets.all(3),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: redColor,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.delete_outline,
                                    color: redColor,
                                  ),
                          ),
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
              InkWell(
                onTap: () {
                  UiUtils.showBottomSheet(
                    child: LeaveDetailsBottomsheetContainer(leave: leave),
                    context: context,
                  );
                },
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    UiUtils.getTranslatedLabel(context, viewMoreKey),
                    style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
