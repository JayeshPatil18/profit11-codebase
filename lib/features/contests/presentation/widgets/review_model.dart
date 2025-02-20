import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:dalalstreetfantasy/constants/boarder.dart';
import 'package:dalalstreetfantasy/constants/color.dart';
import 'package:dalalstreetfantasy/features/contests/data/repositories/review_repo.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/shadow.dart';
import 'package:dalalstreetfantasy/utils/fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../constants/values.dart';
import '../../../../main.dart';
import '../../domain/entities/id_argument.dart';
import 'image_shimmer.dart';
import 'loginRequiredBottomSheet.dart';

class ReviewModel extends StatefulWidget {
  final int reviewId;
  final String imageUrl;
  final String price;
  final bool isLiked;
  final String title;
  final String brand;
  final String category;
  final String date;
  final int rating;

  const ReviewModel({
    required this.reviewId,
    required this.imageUrl,
    required this.price,
    required this.isLiked,
    required this.title,
    required this.brand,
    required this.category,
    required this.date,
    required this.rating,
  });

  @override
  State<ReviewModel> createState() => _ReviewModelState();
}

class _ReviewModelState extends State<ReviewModel> {

  LoginRequiredState loginRequiredObj = LoginRequiredState();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'view_review', arguments: IdArguments(widget.reviewId));
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.primaryColor30,
            borderRadius:
            BorderRadius.circular(AppBoarderRadius.reviewModelRadius),
            boxShadow: ContainerShadow.boxShadow),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(6),
              child: Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(
                          AppBoarderRadius.reviewModelImageRadius),
                      child: widget.imageUrl == 'null'
                          ? SizedBox(
                        height: 156,
                        width: 156,
                        child: Shimmer.fromColors(
                          baseColor: Color(0xFFe4e4e4),
                          highlightColor: Color(0xFFCDCDCD),
                          child: Container(
                            height: 156,
                            width: 156,
                            color: Colors.white,
                          ),
                        ),
                      )
                          : CustomImageShimmer(imageUrl: widget.imageUrl, width: 156, height: 156, fit: BoxFit.fitHeight)),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Row(
                      children: [
                        Text(widget.price[0],
                            style: ReviewModelFonts.subReviewPrice(
                                color: AppColors.secondaryColor10,
                                boxShadow: TextShadow.textShadow)),
                        Text(
                            widget.price.substring(1).length > 9
                                ? widget.price.substring(1, 9) + '...'
                                : widget.price.substring(1),
                            style: ReviewModelFonts.subReviewPrice(
                                boxShadow: TextShadow.textShadow)),
                      ],
                    ),
                  ),
                  Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: (() {
                          if(MyApp.userId == -1){
                            loginRequiredObj.showLoginRequiredDialog(context);
                          } else{
                            // ReviewRepo reviewRepo = ReviewRepo();
                            // reviewRepo.likeReview(widget.reviewId, widget.isLiked);
                          }
                        }),
                        child: SizedBox(
                          child: widget.isLiked
                              ? Icon(
                            Icons.favorite,
                            color: AppColors.heartColor,
                            shadows: [TextShadow.textShadow],
                          )
                              : Icon(
                            Icons.favorite,
                            color: AppColors.iconLightColor,
                            shadows: [TextShadow.textShadow],
                          ),
                        ),
                      ))
                ],
              ),
            ),
            Container(
              child: Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2),
                      Text(widget.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: ReviewModelFonts.reviewTitle()),
                      SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              widget.brand.length > 9
                                  ? widget.brand.substring(0, 8) + '..'
                                  : widget.brand,
                              style: ReviewModelFonts.reviewSubTitle()),
                          Text('  ○  ',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor)),
                          Text(
                              widget.category.length > 9
                                  ? widget.category.substring(0, 8) + '..'
                                  : widget.category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: ReviewModelFonts.reviewSubTitle()),
                        ],
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      widget.date.length > 10
                          ? widget.date.substring(0, 9) + '...'
                          : widget.date,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ReviewModelFonts.dateReview()),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      height: 16,
                      child: ListView.builder(
                        reverse: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: AppValues.maxRating,
                        itemBuilder: (BuildContext context, int index) {
                          return Icon(Icons.star,
                              size: 16,
                              color: index < AppValues.maxRating - widget.rating
                                  ? AppColors.iconLightColor
                                  : AppColors.starColor);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
