
import 'package:flutter/material.dart';
import 'package:dalalstreetfantasy/features/contests/domain/entities/upload_review.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/pages/upload_review.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/review_model.dart';

@immutable
abstract class FetchReviewState {}

class FetchReviewInitial extends FetchReviewState {}

class FetchLoading extends FetchReviewState {}

class FetchSuccess extends FetchReviewState {
  List<UploadReviewModel> reviewList;

  FetchSuccess({required this.reviewList});
}

class FetchFaild extends FetchReviewState {}
