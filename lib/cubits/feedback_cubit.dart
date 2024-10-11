import 'package:eschool_teacher/data/models/feedbackmodel.dart';
import 'package:eschool_teacher/data/repositories/studentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FeedBack {}

class FeedbackIntial extends FeedBack {}

class FeedbackProgress extends FeedBack {}

class FeedbackFailere extends FeedBack {
  final String message;

  FeedbackFailere({required this.message});
}

class FeebackSuccess extends FeedBack {
  final List<FeedbackModel> list;

  FeebackSuccess({required this.list});
}

class FeedbackCubit extends Cubit<FeedBack> {
  FeedbackCubit(super.initialState);

  StudentRepository studentRepository = StudentRepository();

  Future getFeedbacks(int classSectionId) async {
    emit(FeedbackProgress());
    try {
      studentRepository
          .getParentsFeedbacks(classSectionId: classSectionId)
          .then((value) => emit(FeebackSuccess(list: value)))
          .catchError((e) => e.toString());
    } catch (e) {
      emit(FeedbackFailere(message: e.toString()));
    }
  }
}
