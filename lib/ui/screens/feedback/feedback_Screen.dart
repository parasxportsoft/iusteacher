import 'package:eschool_teacher/cubits/feedback_cubit.dart';
import 'package:eschool_teacher/cubits/myClassesCubit.dart';
import 'package:eschool_teacher/cubits/subjectsOfClassSectionCubit.dart';
import 'package:eschool_teacher/data/repositories/teacherRepository.dart';
import 'package:eschool_teacher/ui/widgets/customBackButton.dart';
import 'package:eschool_teacher/ui/widgets/customDropDownMenu.dart';
import 'package:eschool_teacher/ui/widgets/customShimmerContainer.dart';
import 'package:eschool_teacher/ui/widgets/errorContainer.dart';
import 'package:eschool_teacher/ui/widgets/myClassesDropDownMenu.dart';
import 'package:eschool_teacher/ui/widgets/noDataContainer.dart';
import 'package:eschool_teacher/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:eschool_teacher/ui/widgets/shimmerLoadingContainer.dart';
import 'package:eschool_teacher/utils/animationConfiguration.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  static Route route(RouteSettings routeSettings) {
    // final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<FeedbackCubit>(
                  create: (context) => FeedbackCubit(FeedbackIntial()),
                ),
                BlocProvider<SubjectsOfClassSectionCubit>(
                  create: (context) => SubjectsOfClassSectionCubit(
                    TeacherRepository(),
                  ),
                ),
              ],
              child: const FeedbackScreen(),
            ));
  }

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FeedbackCubit>().getFeedbacks(context
        .read<MyClassesCubit>()
        .getClassSectionDetails(
          index: currentSelectedClassSection.index,
        )
        .id);
  }

  late CustomDropDownItem currentSelectedClassSection =
      CustomDropDownItem(index: 0, title: "Click to Select");
  Widget _buildAppBar(BuildContext context) {
    return ScreenTopBackgroundContainer(
      heightPercentage: UiUtils.appBarSmallerHeightPercentage,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const CustomBackButton(),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              UiUtils.getTranslatedLabel(context, "Feedback"),
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: UiUtils.screenTitleFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentFilters() {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return Column(
          children: [
            MyClassesDropDownMenu(
              currentSelectedItem: currentSelectedClassSection,
              width: boxConstraints.maxWidth,
              changeSelectedItem: (result) {
                setState(() {
                  currentSelectedClassSection = result;
                });
                context.read<FeedbackCubit>().getFeedbacks(context
                    .read<MyClassesCubit>()
                    .getClassSectionDetails(
                      index: currentSelectedClassSection.index,
                    )
                    .id);
                // context
                //     .read<AssignmentCubit>()
                //     .updateState(AssignmentInitial());
              },
            ),

            //
            // BlocListener<SubjectsOfClassSectionCubit,
            //     SubjectsOfClassSectionState>(
            //   listener: (context, state) {
            //     if (state is SubjectsOfClassSectionFetchSuccess) {
            //       if (state.subjects.isEmpty) {
            //         // context
            //         //     .read<AssignmentCubit>()
            //         //     .updateState(AssignmentsFetchSuccess(
            //         //       assignment: [],
            //         //       fetchMoreAssignmentsInProgress: false,
            //         //       moreAssignmentsFetchError: false,
            //         //       totalPage: 0,
            //         //       currentPage: 0,
            //         //     ));
            //       }
            //     }
            //   },
            //   child: ClassSubjectsDropDownMenu(
            //     changeSelectedItem: (result) {
            //       setState(() {
            //         index = 1;
            //         currentSelectedSubject = result;
            //       });

            //       fetchAssignment();
            //     },
            //     currentSelectedItem: currentSelectedSubject,
            //     width: boxConstraints.maxWidth,
            //   ),
            // ),
          ],
        );
      },
    );
  }

  Widget feedBacksList() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.17),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildAssignmentFilters(),
          BlocBuilder<FeedbackCubit, FeedBack>(
              bloc: context.read<FeedbackCubit>(),
              builder: (context, state) {
                if (state is FeebackSuccess) {
                  return Container(
                    child: state.list.isEmpty
                        ? const NoDataContainer(titleKey: "No FeedBack Found")
                        : ListView.builder(
                            itemCount: state.list.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Animate(
                                effects: customItemFadeAppearanceEffects(),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  width:
                                      MediaQuery.of(context).size.width * (0.9),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Student Name: " +
                                                      state.list[index]
                                                          .firstName +
                                                      " " +
                                                      state
                                                          .list[index].lastName,
                                                  overflow: TextOverflow.clip,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                                Text(
                                                  "Subject Name: " +
                                                      state.list[index].subject,
                                                  overflow: TextOverflow.clip,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          state.list[index].feedback,
                                          maxLines: 10,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                  );
                } else if (state is FeedbackFailere) {
                  return ErrorContainer(
                    errorMessageText: "Something Went Wrong",
                    showRetryButton: true,
                    onTapRetry: () {
                      context.read<FeedbackCubit>().getFeedbacks(context
                          .read<MyClassesCubit>()
                          .getClassSectionDetails(
                            index: currentSelectedClassSection.index,
                          )
                          .id);
                    },
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: List.generate(4, (index) {
                      return _buildInformationShimmerLoadingContainer(
                          context: context);
                    }),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget _buildInformationShimmerLoadingContainer({
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        width: MediaQuery.of(context).size.width * (0.85),
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.7),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.7),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.5),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          feedBacksList(),
          Align(
            alignment: Alignment.topCenter,
            child: _buildAppBar(context),
          ),
        ],
      ),
    );
  }
}
