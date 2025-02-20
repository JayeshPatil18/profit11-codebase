
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dalalstreetfantasy/features/contests/data/repositories/review_repo.dart';
import 'package:dalalstreetfantasy/features/contests/domain/entities/upload_review.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/bloc/upload_review/upload_review_event.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/review_model.dart';

part 'upload_review_state.dart';

class UploadReviewBloc extends Bloc<UploadReviewEvent, UploadReviewState> {
  UploadReviewBloc() : super(UploadReviewInitial()) {
    on<UploadReviewEvent>((event, emit) async {
      if (event is UploadClickEvent) {
        emit(UploadReviewLoading());
        UploadReviewModel reviewModel = UploadReviewModel(
          date : '', //
          likedBy : [],
          mediaUrl : '', //
          userProfileUrl: '',
          gender: '',
          parentId: event.parentId, //
          postId: '-1',
          text : event.postText,
          userId : -1, //
          username : '', //
        );

        ReviewRepo reviewRepo = ReviewRepo();
        bool isUploaded = await reviewRepo.uploadReview(reviewModel, event.mediaSelected);
        if(isUploaded){
          emit(UploadReviewSuccess());
        } else{
          emit(UploadReviewFaild());
        }
      }
    });
  }
}
