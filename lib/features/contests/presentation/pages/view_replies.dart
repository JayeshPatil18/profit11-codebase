import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:dalalstreetfantasy/constants/values.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/circle_button.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/line.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/snackbar.dart';
import 'package:dalalstreetfantasy/utils/dropdown_items.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

import '../../../../constants/boarder.dart';
import '../../../../constants/color.dart';
import '../../../../constants/cursor.dart';
import '../../../../constants/elevation.dart';
import '../../../../main.dart';
import '../../../../utils/fonts.dart';
import '../../../../utils/methods.dart';
import '../../data/repositories/category_brand_repo.dart';
import '../../data/repositories/review_repo.dart';
import '../../domain/entities/image_argument.dart';
import '../../domain/entities/two_string_argument.dart';
import '../../domain/entities/upload_review.dart';
import '../bloc/upload_review/upload_review_bloc.dart';
import '../bloc/upload_review/upload_review_event.dart';
import '../widgets/dropdown.dart';
import '../widgets/post_model.dart';
import '../widgets/review_model.dart';
import '../widgets/shadow.dart';
import '../widgets/view_post_model.dart';
import '../widgets/view_replies_model.dart';

class ViewReplies extends StatefulWidget {
  final String parentPostId;
  final String postId;
  const ViewReplies({super.key, required this.parentPostId, required this.postId});

  @override
  State<ViewReplies> createState() => _ViewRepliesState();
}

class _ViewRepliesState extends State<ViewReplies> {
  final FocusNode _focusPostTextNode = FocusNode();
  bool _hasPostTextFocus = false;
  late RichTextController postTextController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int hasImagePicked = -1;

  String? _validateInput(String? input, int index) {
    if (input != null) {
      input = input.trim();
    }

    switch (index) {
      case 0:
        if ((input == null || input.isEmpty) && _selectedMedia == null) {
          return 'Write anonymous post';
        }
        break;

      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();

    postTextController = RichTextController(
      patternMatchMap: {
        RegExp(r'@\w+'): MainFonts.searchText(color: AppColors.secondaryColor10),
      },
      onMatch: (List<String> matches) {},
    );

    _focusPostTextNode.addListener(() {
      setState(() {
        _hasPostTextFocus = _focusPostTextNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  File? _selectedMedia;

  Future pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);

    if (image == null) return;

    setState(() {
      hasImagePicked = 1;
      _selectedMedia = File(image.path);
    });
  }

  double progress = 0;
  int currentCharacters = 0;

  _onTextChanged(){
    setState(() {
      currentCharacters = postTextController.text.length;
      progress = currentCharacters / AppValues.maxCharactersPost;
    });
  }

  @override
  Widget build(BuildContext context) {
    _onTextChanged();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(color: AppColors.backgroundColor60),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin:
                EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back_ios,
                              color: AppColors.textColor, size: 20),
                        ),
                        SizedBox(width: 10),
                        Text('View Replies', style: MainFonts.pageTitleText(fontSize: 22, weight: FontWeight.w400)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: ReviewRepo.reviewFireInstance.orderBy('date', descending: true).snapshots(),
                    builder: (context, snapshot) {
                      final documents;
                      if (snapshot.data != null) {
                        documents = snapshot.data!.docs;

                        UploadReviewModel? parentPost;
                        UploadReviewModel? childPost;
                        List<UploadReviewModel> documentList = [];
                        List<UploadReviewModel> childPostList = [];

                        // Getting comment count

                        int parentCommentCount = 0;
                        bool isParentCommented = false;

                        int childCommentCount = 0;
                        bool isChildCommented = false;

                        for(int i = 0; i < documents.length; i++){
                          UploadReviewModel post = UploadReviewModel.fromMap(documents[i].data() as Map<String, dynamic>);
                          documentList.add(post);

                          if(post.postId == widget.parentPostId){
                            parentPost = post;
                          }

                          if(post.postId == widget.postId){
                            childPost = post;
                          } else if(post.parentId == widget.postId){
                            childPostList.add(post);
                          }

                          if(widget.postId == post.parentId){
                            if(MyApp.userId == post.userId){
                              isChildCommented = true;
                            }
                            childCommentCount++;
                          }

                          if(widget.parentPostId == post.parentId){
                            if(MyApp.userId == post.userId){
                              isParentCommented = true;
                            }
                            parentCommentCount++;
                          }
                        }

                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              RepliesModel(
                                onCommentClick: () {
                                  String usernameText = parentPost?.username ?? '';
                                  postTextController.text = postTextController.text + (usernameText.isNotEmpty ? '@$usernameText ' : '');
                                  FocusScope.of(context).requestFocus(_focusPostTextNode);
                                },
                                commentCount: parentCommentCount,
                                isCommented: isParentCommented,
                                date: parentPost?.date ?? '',
                                likedBy: parentPost?.likedBy ?? [],
                                mediaUrl: parentPost?.mediaUrl ?? '',
                                gender: parentPost?.gender ?? '',
                                userProfileUrl: parentPost?.userProfileUrl ?? '',
                                parentId: parentPost?.parentId ?? '',
                                postId: parentPost?.postId ?? '',
                                text: parentPost?.text ?? '',
                                userId: parentPost?.userId ?? -1,
                                username: parentPost?.username ?? '',
                              ),
                              ViewPostModel(
                                onCommentClick: () {
                                  String usernameText = childPost?.username ?? '';
                                  postTextController.text = postTextController.text + (usernameText.isNotEmpty ? '@$usernameText ' : '');
                                  FocusScope.of(context).requestFocus(_focusPostTextNode);
                                },
                                commentCount: childCommentCount,
                                isCommented: isChildCommented,
                                date: childPost?.date ?? '',
                                likedBy: childPost?.likedBy ?? [],
                                mediaUrl: childPost?.mediaUrl ?? '',
                                gender: childPost?.gender ?? '',
                                userProfileUrl: childPost?.userProfileUrl ?? '',
                                parentId: childPost?.parentId ?? '',
                                postId: childPost?.postId ?? '',
                                text: childPost?.text ?? '',
                                userId: childPost?.userId ?? -1,
                                username: childPost?.username ?? '',
                              ),
                              childPostList.isNotEmpty ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(bottom: 100, top: 20),
                                  itemCount: childPostList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    UploadReviewModel post = childPostList[index];

                                    int commentCount = 0;
                                    bool isCommented = false;
                                    for(UploadReviewModel i in documentList){
                                      if(post.postId == i.parentId){
                                        if(MyApp.userId == i.userId){
                                          isCommented = true;
                                        }
                                        commentCount++;
                                      }
                                    }

                                    return RepliesModel(
                                      onCommentClick: () {
                                        postTextController.text = post.username.isNotEmpty ? '@${post.username} ' : '';
                                        FocusScope.of(context).requestFocus(_focusPostTextNode);
                                      },
                                      commentCount: commentCount,
                                      isCommented: isCommented,
                                      date: post.date,
                                      likedBy: post.likedBy,
                                      mediaUrl: post.mediaUrl,
                                      gender: post.gender,
                                      userProfileUrl: post.userProfileUrl,
                                      parentId: post.parentId,
                                      postId: post.postId,
                                      text: post.text,
                                      userId: post.userId,
                                      username: post.username,
                                    );
                                  }) : Container(
                                  margin: EdgeInsets.only(top: 40, bottom: 20), child: Center(child: Text('No Replies', style: MainFonts.filterText(color: AppColors.lightTextColor)))),
                            ],
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.lightTextColor,
                      width: 0.3,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      minLines: 1,
                      maxLines: 12,
                      maxLength: AppValues.maxCharactersPost,
                      style: MainFonts.searchText(color: AppColors.primaryColor30),
                      focusNode: _focusPostTextNode,
                      controller: postTextController,
                      onChanged: (value) {
                        _onTextChanged();
                        if (currentCharacters > AppValues.maxCharactersPost) {
                          mySnackBarShow(context, 'Character limit exceeded!');
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(right: 20, left: 20,
                            top: 10, bottom: 10),
                        fillColor: AppColors.transparentComponentColor.withOpacity(0.1/2),
                        filled: true,
                        hintText: 'Add a reply...',
                        hintStyle: MainFonts.searchText(color: AppColors.transparentComponentColor),
                          suffixIconConstraints: BoxConstraints(
                            minWidth: 2,
                            minHeight: 2,
                          ),
                          suffixIcon: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, 'upload', arguments: TwoStringArg(widget.postId, postTextController.text));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 14),
                                child: Icon(Icons.open_in_full_rounded, color: AppColors.transparentComponentColor,),
                              )),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                    ),
                    !_hasPostTextFocus ? SizedBox() : Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0).copyWith(
                          //     left: 15,
                          //     right: 15,
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       GestureDetector(
                          //         onTap: () {
                          //           pickImage(ImageSource.gallery);
                          //         },
                          //         child: SvgPicture.asset('assets/svg/gallery.svg', color: AppColors.textColor),
                          //       ),
                          //       SizedBox(width: 14),
                          //       GestureDetector(
                          //         onTap: () {
                          //           pickImage(ImageSource.camera);
                          //         },
                          //         child: Icon(Icons.camera_alt_outlined, color: AppColors.textColor),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Row(
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                padding: EdgeInsets.all(4),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      backgroundColor: AppColors.transparentComponentColor,
                                      value: progress,
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(currentCharacters < AppValues.maxCharactersPost ? AppColors.textColor : AppColors.errorColor),
                                    ),
                                    Text(
                                      '${currentCharacters <= AppValues.maxCharactersPost ? currentCharacters : AppValues.maxCharactersPost}',
                                      style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textColor
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 15)
                            ],
                          ),
                          BlocConsumer<UploadReviewBloc, UploadReviewState>(
                              listener: (context, state) {
                                if (state is UploadReviewSuccess) {
                                  postTextController.text = '';
                                  FocusScope.of(context).unfocus();

                                  Future.delayed(const Duration(milliseconds: 300), () {
                                    mySnackBarShow(context, 'Your Post sent.');
                                  });
                                } else if(state is UploadReviewFaild) {
                                  mySnackBarShow(context, 'Something went wrong.');
                                }
                              },
                              builder: (context, state) {
                                if (state is UploadReviewLoading) {
                                  return Container(
                                    height: 35,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.secondaryColor10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  20)),
                                          elevation: AppElevations.buttonElev,
                                        ),
                                        onPressed: () {
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 5, right: 5),
                                          child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: Center(
                                                  child: CircularProgressIndicator(
                                                      strokeWidth:
                                                      2,
                                                      color:
                                                      AppColors.primaryColor30))),
                                        )),
                                  );
                                }
                                return Container(
                                  height: 35,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: (postTextController.text.trim().length > 1) || _selectedMedia != null ? AppColors.secondaryColor10 : AppColors.transparentComponentColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20)),
                                        elevation: AppElevations.buttonElev,
                                      ),
                                      onPressed: () async {

                                        if ((postTextController.text.trim().length > 1) || _selectedMedia != null) {
                                          // Post anonymous post
                                          BlocProvider.of<UploadReviewBloc>(context)
                                              .add(UploadClickEvent(mediaSelected: null, postText: postTextController.text.trim(), parentId: widget.postId,
                                          ));
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5, right: 5),
                                        child: Text('Post',
                                            style: MainFonts.uploadButtonText(size: 16)),
                                      )),
                                );
                              }
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}