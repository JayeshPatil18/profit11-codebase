import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/choose_profile_icon.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../constants/boarder.dart';
import '../../../../constants/color.dart';
import '../../../../constants/cursor.dart';
import '../../../../constants/elevation.dart';
import '../../../../constants/values.dart';
import '../../../../main.dart';
import '../../../../utils/fonts.dart';
import '../../../../utils/methods.dart';
import '../../../authentication/data/repositories/users_repo.dart';
import '../../data/repositories/review_repo.dart';
import '../../domain/entities/image_argument.dart';
import '../../domain/entities/upload_review.dart';
import '../../domain/entities/user.dart';
import '../widgets/image_shimmer.dart';
import '../widgets/shadow.dart';
import '../widgets/snackbar.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {

  final FocusNode _focusUsernameNode = FocusNode();
  bool _hasUsernameFocus = false;

  final FocusNode _focusBioNode = FocusNode();
  bool _hasBioFocus = false;

  final FocusNode _focusGenderNode = FocusNode();
  bool _hasGenderFocus = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  static String profileImageUrl = 'null';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validateInput(String? input, int index) {
    if (input != null) {
      input = input.trim();
    }

    switch (index) {

      case 0:
        if (input == null || input.isEmpty) {
          return 'Field empty';
        } else if (input.length < 2) {
          return 'Username is too short';
        } else if (input.length > 30) {
          return 'Username is too long';
        } else if (!doesNotContainSpaces(input)) {
          return 'Username should not contain any spaces';
        }
        break;

      // case 1:
      //   if (input.toString().length > 136) {
      //     return 'Bio should be within 136 characters';
      //   }
      //   break;

      case 2:
        if (input == null || input.isEmpty) {
          return 'Field empty';
        }
        break;

      default:
        return null;
    }
  }

  _loadProfileData() async {

    var document = await UsersRepo.userFireInstance.doc('usersdoc').get();

    List<Map<String, dynamic>> usersData =
        List<Map<String, dynamic>>.from(document.data()?["userslist"] ?? []);

    List<User> usersList =
        usersData.map((userData) => User.fromMap(userData)).toList();

    List<User> users =
        usersList.where((user) => user.uid == MyApp.userId).toList();
    user = users.first;

    // Set Text to TextFields & Profile Image Url
    setState(() {
      profileImageUrl = user?.profileUrl ?? '';
    });
    genderController.text = user?.gender.capitalize() ?? '-';
    usernameController.text = user?.username ?? '_';
    bioController.text = user?.bio ?? '_';
  }

  User? user;

  @override
  void initState() {
    super.initState();

    // Load Profile Data
    _loadProfileData();

    _focusUsernameNode.addListener(() {
      setState(() {
        _hasUsernameFocus = _focusUsernameNode.hasFocus;
      });
    });

    _focusBioNode.addListener(() {
      setState(() {
        _hasBioFocus = _focusBioNode.hasFocus;
      });
    });

    _focusGenderNode.addListener(() {
      setState(() {
        _hasGenderFocus = _focusGenderNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  File? _selectedImage;

  Future pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });
  }

  void pickSource() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(color: AppColors.backgroundColor60),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo, color: AppColors.primaryColor30,),
                  title: Text('Gallary', style: TextStyle(color: AppColors.primaryColor30)),
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  color: AppColors.transparentComponentColor,
                  height: 1,
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera, color: AppColors.primaryColor30,),
                  title: Text('Camera', style: TextStyle(color: AppColors.primaryColor30)),
                  onTap: () {
                    pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(color: AppColors.backgroundColor60),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // pickSource();

                                chooseProfileIconDialog(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Stack(children: [
                                    profileImageUrl == 'null'
                                        ? CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 50,
                                      child: ClipOval(
                                        child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          color: AppColors.transparentComponentColor,
                                          child: Icon(Icons.person, color: AppColors.lightTextColor, size: 60),
                                        ),
                                      ),
                                    )
                                        : CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 50,
                                        child: ClipOval(
                                            child: CustomImageShimmer(
                                                imageUrl: profileImageUrl,
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover))),
                                    Positioned(
                                      bottom: 2,
                                      right: 2,
                                      child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.secondaryColor10,
                                            shape: BoxShape
                                                .circle,
                                          ),
                                          child: Image.asset('assets/icons/plus.png', color: AppColors.primaryColor30, height: 10, width: 10)),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                            SizedBox(height: 40),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10, left: 5),
                              child: Text('Username', style: MainFonts.lableText(fontSize: 16, color: AppColors.lightTextColor)),
                            ),
                            Container(
                              child: TextFormField(
                                controller: usernameController,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                validator: ((value) {
                                  return _validateInput(value, 0);
                                }),
                                focusNode: _focusUsernameNode,
                                  style: MainFonts.textFieldText(),
                                  cursorHeight: TextCursorHeight.cursorHeight,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        top: 16, bottom: 16, left: 20, right: 20),
                                    fillColor: AppColors.transparentComponentColor.withOpacity(0.1),
                                    filled: true,
                                    hintText: 'Anonymous Username',
                                    hintStyle: MainFonts.hintFieldText(color: AppColors.transparentComponentColor, size: 16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppBoarderRadius.buttonRadius),
                                      borderSide: const BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppBoarderRadius.buttonRadius),
                                      borderSide: const BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                  ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10, left: 5),
                              child: Text('Bio',
                                  style: MainFonts.lableText(fontSize: 16, color: AppColors.lightTextColor)),
                            ),
                            Container(
                              child: TextFormField(
                                maxLines: 4,
                                controller: bioController,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                validator: ((value) {
                                  return _validateInput(value, 1);
                                }),
                                focusNode: _focusBioNode,
                                style: MainFonts.textFieldText(),
                                cursorHeight: TextCursorHeight.cursorHeight,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: 16, bottom: 16, left: 20, right: 20),
                                  fillColor: AppColors.transparentComponentColor.withOpacity(0.1),
                                  filled: true,
                                  hintText: 'Year, Branch, Club, etc.',
                                  hintStyle: MainFonts.hintFieldText(color: AppColors.transparentComponentColor, size: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppBoarderRadius.buttonRadius),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppBoarderRadius.buttonRadius),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 4, right: 4),
                              child: Text(
                                  'You can mention your year, branch, division but don’t revel identity.',
                                  style:
                                  AuthFonts.authSmallLabelText(fontSize: 11, color: AppColors.transparentComponentColor)),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10, left: 5),
                              child: Text('Gender',
                                  style: MainFonts.lableText(fontSize: 16, color: AppColors.lightTextColor)),
                            ),
                            Container(
                              child: TextFormField(
                                readOnly: true,
                                controller: genderController,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                validator: ((value) {
                                  return _validateInput(value, 2);
                                }),
                                focusNode: _focusGenderNode,
                                style: MainFonts.textFieldText(),
                                cursorHeight: TextCursorHeight.cursorHeight,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: 16, bottom: 16, left: 20, right: 20),
                                  fillColor: AppColors.transparentComponentColor.withOpacity(0.1),
                                  filled: true,
                                  hintText: 'Male/Female',
                                  hintStyle: MainFonts.hintFieldText(color: AppColors.transparentComponentColor, size: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppBoarderRadius.buttonRadius),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppBoarderRadius.buttonRadius),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 4, right: 4),
                              child: Text(
                                  'Once you choose a gender, you cannot change it. Contact developer through feedback option to change.',
                                  style:
                                  AuthFonts.authSmallLabelText(fontSize: 11, color: AppColors.transparentComponentColor)),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 20, top: 10, left: 20, right: 20),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor10,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(AppBoarderRadius.buttonRadius)),
                        elevation: AppElevations.buttonElev,
                      ),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (!isLoading) {
                          setIsLoading(true);

                          bool isValid =
                          _formKey.currentState!.validate();
                          if (isValid) {
                            UsersRepo usersRepo = UsersRepo();
                            List<String>? details =
                            await getLoginDetails();
                            String username = details?[1] ?? '';

                            int validUsername = 0;

                            if (usernameController.text.toLowerCase() ==
                                username.toLowerCase()) {
                              validUsername = 1;
                            } else {
                              validUsername = await usersRepo
                                  .validUsernameCheck(
                                  usernameController.text);
                            }

                            if (validUsername == 1) {
                              UsersRepo userRepoObj = UsersRepo();
                              int status =
                              await userRepoObj.updateProfile(
                                  profileImageUrl,
                                  usernameController.text.trim(),
                                  bioController.text.trim());
                              if (status == 1) {
                                FocusScope.of(context).unfocus();
                                mySnackBarShow(
                                    context, 'Profile Updated.');
                                Future.delayed(
                                    const Duration(milliseconds: 300),
                                        () {
                                      Navigator.of(context).pop();
                                    });
                              } else if (status == -1) {
                                logOut();
                              } else {
                                mySnackBarShow(context,
                                    'Something went wrong! Try again.');
                              }
                            } else if (validUsername == -1) {
                              mySnackBarShow(context,
                                  'This username is already in use! Try Another.');
                            } else if (validUsername == 0) {
                              mySnackBarShow(context,
                                  'Something went wrong! Try again.');
                            }
                          }

                          setIsLoading(false);
                        }
                      },
                      child: isLoading == false ? Text('Update', style: AuthFonts.authButtonText()) : SizedBox(
                          width: 30,
                          height: 30,
                          child: Center(
                              child: CircularProgressIndicator(
                                  strokeWidth:
                                  AppValues.progresBarWidth,
                                  color:
                                  AppColors.primaryColor30)))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  logOut() {
    clearSharedPrefs();
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacementNamed('login');
  }

  void chooseProfileIconDialog(BuildContext context) {

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        ),
        builder: (context) => ChooseProfileIcon()).whenComplete(_onBottomSheetClosed);
  }

  void _onBottomSheetClosed() {
    setState(() {

    });
  }
}
