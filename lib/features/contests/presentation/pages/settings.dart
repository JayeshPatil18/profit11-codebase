import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/live_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../constants/boarder.dart';
import '../../../../constants/color.dart';
import '../../../../constants/cursor.dart';
import '../../../../constants/elevation.dart';
import '../../../../constants/links.dart';
import '../../../../constants/values.dart';
import '../../../../main.dart';
import '../../../../utils/fonts.dart';
import '../../../../utils/methods.dart';
import '../../../authentication/data/repositories/users_repo.dart';
import '../../data/models/user_item.dart';
import '../../data/repositories/review_repo.dart';
import '../../data/repositories/user_repo.dart';
import '../../domain/entities/upload_review.dart';
import '../../domain/entities/user.dart';
import '../widgets/dialog_box.dart';
import '../widgets/image_shimmer.dart';
import '../widgets/league_card.dart';
import '../widgets/line.dart';
import '../widgets/review_model.dart';
import '../widgets/shadow.dart';
import '../widgets/upcoming_card.dart';
import '../widgets/completed_card.dart';
import '../widgets/user_model.dart';

class SettingsPage extends StatefulWidget {
  final UserItem userItem;
  const SettingsPage({super.key, required this.userItem});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _gender = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _gender = widget.userItem.gender.toLowerCase();
    _nameController.text = widget.userItem.fullName;
    _emailController.text = widget.userItem.email;
    _phoneController.text = widget.userItem.phoneNo;
  }

  String? _validateInput(String? input, int index) {
    if (input != null) {
      input = input.trim();
    }

    switch (index) {
      case 0:
        if (input == null || input.isEmpty) {
          return 'Enter your name';
        } else if (input.length < 2) {
          return 'Name is too short';
        } else if (input.length > 40) {
          return 'Name is too long';
        }
        break;

      default:
        return null;
    }
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
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Gallary'),
                onTap: () {
                  pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                color: AppColors.iconLightColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor60,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 6),
        child: Container(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: (_nameController.text.trim().isNotEmpty) ? AppColors.primaryColor30 : Colors.grey.shade500,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(AppBoarderRadius.buttonRadius)),
                elevation: AppElevations.buttonElev,
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();

                if(_nameController.text.trim().isNotEmpty){
                  setIsLoading(true);

                  bool isValid = _formKey.currentState?.validate() ?? false;
                  if (isValid) {

                      int status =
                      await updateUser(widget.userItem, _selectedImage, _nameController.text.trim(), _gender!);
                      if (status == 1) {
                        FocusScope.of(context).unfocus();
                        mySnackBarShow(
                            context, 'Changes saved.');
                        Future.delayed(
                            const Duration(milliseconds: 300),
                                () {
                              Navigator.of(context).pop();
                            });
                      } else {
                        mySnackBarShow(
                            context, 'Something Went Wrong!');
                      }

                      setIsLoading(false);
                  }

                  setIsLoading(false);
                }
              },
              child: isLoading == false ? Text('Update Profile', style: AuthFonts.authButtonText(color: (_nameController.text.trim().isNotEmpty) ? AppColors.backgroundColor60 : AppColors.lightTextColor)) : SizedBox(
                  width: 30,
                  height: 30,
                  child: Center(
                      child: CircularProgressIndicator(
                          strokeWidth:
                          AppValues.progresBarWidth,
                          color:
                          AppColors.backgroundColor60)))),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header section with title and icons
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                      child: Icon(Icons.arrow_back_ios_new_rounded, size: 22)),
                  SizedBox(width: 16),
                  Text('Settings',
                      style: MainFonts.pageTitleText(
                          color: AppColors.primaryColor30, fontSize: 22)),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Container(
                    color: AppColors.backgroundColor60,
                    margin: EdgeInsets.only(bottom: 100),
                    padding:
                    EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                pickSource();
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.secondaryColor10,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: _selectedImage != null
                                        ? CircleAvatar(
                                      backgroundImage:
                                      FileImage(_selectedImage!),
                                      radius: 35,
                                    ) : (widget.userItem.profileUrl == "" || widget.userItem.profileUrl == "null") ? CircleAvatar(
                                      backgroundColor: Colors.grey.withOpacity(0.3),
                                      radius: 35,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white.withOpacity(0.8),
                                        size: 35,
                                      ),
                                    ) : CircleAvatar(
                                      backgroundImage: NetworkImage(widget.userItem.profileUrl),
                                      radius: 35,
                                      backgroundColor: Colors.transparent,
                                      child: ClipOval(
                                          child: CustomImageShimmer(
                                              imageUrl: widget.userItem.profileUrl,
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 2,
                                    right: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.secondaryColor10,
                                      ),
                                      padding: EdgeInsets.all(5),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: AppColors.backgroundColor60,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ),
                          SizedBox(height: 30),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: ((value) {
                              return _validateInput(value, 0);
                            }),
                            onChanged: (value){
                              setState(() {

                              });
                            },
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            // autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: _emailController,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.edit, size: 21, color: Colors.grey),
                                onPressed: () {

                                },
                              ),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            // autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: _phoneController,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.edit, size: 21, color: Colors.grey),
                                onPressed: () {

                                },
                              ),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Gender',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile(
                                  title: Text('Male'),
                                  value: 'male',
                                  groupValue: _gender,
                                  onChanged: (value) {
                                    setState(() {
                                      _gender = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile(
                                  title: Text('Female'),
                                  value: 'female',
                                  groupValue: _gender,
                                  onChanged: (value) {
                                    setState(() {
                                      _gender = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isLoading = false;

  setIsLoading(bool isLoadingVal) {
    setState(() {
      isLoading = isLoadingVal;
    });
  }

  Widget buildStatCard(String number, String label) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  void _updateProfile() {
    // Collect updated data
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String phone = _phoneController.text.trim();

    // Perform validation (optional)
    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    // Handle profile update (e.g., send data to server or database)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully!')),
    );
  }

}
