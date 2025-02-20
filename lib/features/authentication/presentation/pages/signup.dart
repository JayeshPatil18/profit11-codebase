import 'package:country_code_picker/country_code_picker.dart';
import 'package:dalalstreetfantasy/features/authentication/data/repositories/users_repo.dart';
import 'package:flutter/material.dart';

import '../../../../constants/boarder.dart';
import '../../../../constants/color.dart';
import '../../../../constants/cursor.dart';
import '../../../../constants/elevation.dart';
import '../../../../constants/values.dart';
import '../../../../utils/fonts.dart';
import '../../../../utils/methods.dart';
import '../../../contests/data/models/user.dart';
import '../../../contests/data/models/user_item.dart';
import '../../../contests/presentation/widgets/snackbar.dart';

class SignUpPage extends StatefulWidget {
  final String phoneNo;
  final String countryCode;

  const SignUpPage({super.key, required this.phoneNo, required this.countryCode});

  @override
  State<StatefulWidget> createState() {
    return SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> {
  final FocusNode _focusPhoneNoNode = FocusNode();
  bool _hasPhoneNoFocus = false;

  late TextEditingController phoneNoController;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String countryCode;

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

      case 1:
        if (input == null || input.isEmpty) {
          return 'Create username';
        } else if (input.length < 2) {
          return 'Username is too short';
        } else if (input.length > 30) {
          return 'Username is too long';
        } else if (!doesNotContainSpaces(input)) {
          return 'Username should not contain any spaces';
        }
        break;

      case 2:
        if (input == null || input.isEmpty) {
          return 'Enter phone number';
        } else if (!isNumeric(input) || input.length != 10) {
          return 'Invalid phone number';
        }
        break;

      case 3:
        if (input == null || input.isEmpty) {
          return 'Enter birthdate';
        }
        break;

      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();

    phoneNoController = TextEditingController(text: widget.phoneNo);
    countryCode = widget.countryCode;

    _focusPhoneNoNode.addListener(() {
      setState(() {
        _hasPhoneNoFocus = _focusPhoneNoNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    phoneNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 6),
        child: Container(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor30,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppBoarderRadius.buttonRadius)),
                elevation: AppElevations.buttonElev,
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();

                if (!isLoading) {
                  setIsLoading(true);

                  bool isValid = _formKey.currentState!.validate();
                  if (isValid) {
                    UserItem user = UserItem(
                      userId: '',
                      fullName: fullNameController.text.trim(),
                      username: usernameController.text.trim(),
                      email: '',
                      phoneNo: widget.countryCode + widget.phoneNo,
                      profileUrl: '',
                      walletBalance: 0,
                      netWorth: 0,
                      rank: -1,
                      skillScore: 0,
                      gender: '',
                      joinedContests: [],
                      achievements: [],
                      status: 'active',
                      createdAt: DateTime.now().toString(),
                      updatedAt: DateTime.now().toString(),
                    );

                    UserServicesRepo usersRepo = UserServicesRepo();
                    bool success = await usersRepo.registerUser(user);

                    
                  }

                  setIsLoading(false);
                }
              },
              child: isLoading == false
                  ? Text('Continue', style: AuthFonts.authButtonText())
                  : SizedBox(
                      width: 30,
                      height: 30,
                      child: Center(
                          child: CircularProgressIndicator(
                              strokeWidth: AppValues.progresBarWidth,
                              color: AppColors.backgroundColor60)))),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 100),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 40), // For spacing from the top
                  Container(
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Create Account',
                      style: AuthFonts.authTitleText(),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: fullNameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: ((value) {
                      return _validateInput(value, 0);
                    }),
                    style: AuthFonts.authTextField(),
                    keyboardType: TextInputType.text,
                    cursorHeight: TextCursorHeight.cursorHeight,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          top: 16, bottom: 16, left: 20, right: 20),
                      fillColor: AppColors.primaryColor30.withOpacity(0.07),
                      filled: true,
                      hintText: 'Enter your name',
                      hintStyle: AuthFonts.authHintTextField(),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppBoarderRadius.textFieldRadius),
                          borderSide: BorderSide.none),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppBoarderRadius.textFieldRadius),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppBoarderRadius.textFieldRadius),
                          borderSide: BorderSide(
                              width: AppBoarderWidth.textFieldWidth,
                              color: AppColors.secondaryColor10)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppBoarderRadius.textFieldRadius),
                          borderSide: BorderSide(
                              width: AppBoarderWidth.textFieldWidth,
                              color: AppBoarderColor.errorColor)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: usernameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: ((value) {
                      return _validateInput(value, 1);
                    }),
                    style: AuthFonts.authTextField(),
                    keyboardType: TextInputType.text,
                    cursorHeight: TextCursorHeight.cursorHeight,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          top: 16, bottom: 16, left: 20, right: 20),
                      fillColor: AppColors.primaryColor30.withOpacity(0.07),
                      filled: true,
                      hintText: 'Enter username',
                      hintStyle: AuthFonts.authHintTextField(),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppBoarderRadius.textFieldRadius),
                          borderSide: BorderSide.none),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppBoarderRadius.textFieldRadius),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppBoarderRadius.textFieldRadius),
                          borderSide: BorderSide(
                              width: AppBoarderWidth.textFieldWidth,
                              color: AppColors.secondaryColor10)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppBoarderRadius.textFieldRadius),
                          borderSide: BorderSide(
                              width: AppBoarderWidth.textFieldWidth,
                              color: AppBoarderColor.errorColor)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    maxLength: 10,
                    controller: phoneNoController,
                    enabled: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: ((value) {
                      return _validateInput(value, 2);
                    }),
                    style: AuthFonts.authTextField(),
                    keyboardType: TextInputType.number,
                    focusNode: _focusPhoneNoNode,
                    cursorHeight: TextCursorHeight.cursorHeight,
                    decoration: InputDecoration(
                      prefixIcon: CountryCodePicker(
                        textStyle: AuthFonts.authCountryCodeTextField(),
                        onChanged: ((value) {
                          countryCode = value.dialCode.toString();
                        }),
                        initialSelection: countryCode,
                        favorite: ['+91', 'IND'],
                        showFlagDialog: true,
                        showFlagMain: false,
                        alignLeft: false,
                      ),
                      contentPadding: EdgeInsets.only(
                          top: 16, bottom: 16, left: 20, right: 20),
                      fillColor: AppColors.primaryColor30.withOpacity(0.07),
                      filled: true,
                      hintText: 'Enter phone number',
                      hintStyle: AuthFonts.authHintTextField(),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppBoarderRadius.textFieldRadius),
                          borderSide: BorderSide.none),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppBoarderRadius.textFieldRadius),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppBoarderRadius.textFieldRadius),
                          borderSide: BorderSide(
                              width: AppBoarderWidth.textFieldWidth,
                              color: AppColors.secondaryColor10)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppBoarderRadius.textFieldRadius),
                          borderSide: BorderSide(
                              width: AppBoarderWidth.textFieldWidth,
                              color: AppBoarderColor.errorColor)),
                    ),
                  ),
                  SizedBox(height: 10),
              TextFormField(
              controller: dateOfBirthController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: ((value) {
                return _validateInput(value, 3);
              }),
              style: AuthFonts.authTextField(),
              keyboardType: TextInputType.none, // Disable keyboard, as it's not needed
              cursorHeight: TextCursorHeight.cursorHeight,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColor30.withOpacity(0.5)),
                contentPadding: EdgeInsets.only(
                    top: 16, bottom: 16, left: 20, right: 20),
                fillColor: AppColors.primaryColor30.withOpacity(0.07),
                filled: true,
                hintText: 'Date of Birth',
                hintStyle: AuthFonts.authHintTextField(color: AppColors.primaryColor30.withOpacity(0.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBoarderRadius.textFieldRadius),
                    borderSide: BorderSide.none),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBoarderRadius.textFieldRadius),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBoarderRadius.textFieldRadius),
                    borderSide: BorderSide(
                        width: AppBoarderWidth.textFieldWidth,
                        color: AppColors.secondaryColor10)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBoarderRadius.textFieldRadius),
                    borderSide: BorderSide(
                        width: AppBoarderWidth.textFieldWidth,
                        color: AppBoarderColor.errorColor)),
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode()); // Dismiss the keyboard
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900), // You can set a lower bound for the date
                  lastDate: DateTime.now(), // The date can't be in the future
                );
                if (selectedDate != null) {
                  dateOfBirthController.text =
                  "${selectedDate.toLocal()}".split(' ')[0]; // Format the date
                }
              },
            )
            ],
              ),
            ),
          ),
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
}
