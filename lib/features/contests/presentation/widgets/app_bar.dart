import 'package:dalalstreetfantasy/features/contests/data/models/user_item.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/snackbar.dart';
import 'package:flutter/material.dart';

import '../../../../constants/color.dart';
import '../../../../main.dart';
import '../../../../utils/fonts.dart';
import '../../../authentication/data/repositories/users_repo.dart';
import '../pages/landing.dart';
import 'image_shimmer.dart';
import 'loginRequiredBottomSheet.dart';

getUserItemData(String userId) async {
  UserServicesRepo userServicesRepo = UserServicesRepo();

  MyApp.userItem = await userServicesRepo.fetchUserFromFirestore(userId);

}

Widget appBarBuildSection(BuildContext context, String title) {
  LoginRequiredState loginRequiredObj = LoginRequiredState();
  getUserItemData(MyApp.loggedInUserId);

  return Container(
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                LandingPage.scaffoldKey.currentState?.openDrawer();
              },
              child: Container(
                padding: EdgeInsets.all(2), // Padding for outer border
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.secondaryColor10,
                    // Border color as per the image
                    width: 1,
                  ),
                ),
                child: (MyApp.userItem == null ||
                    MyApp.userItem!.profileUrl.isEmpty ||
                    MyApp.userItem!.profileUrl == "null")
                    ? CircleAvatar(
                  radius: 14, // Adjust the radius for size
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.white,
                  ),
                )
                    : CircleAvatar(
                  radius: 14, // Adjust the radius for size
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage(MyApp.userItem!.profileUrl),
                  child: ClipOval(
                    child: CustomImageShimmer(
                      imageUrl: MyApp.userItem!.profileUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 4),
            title.isEmpty
                ? Container(
              margin: EdgeInsets.only(left: 10),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    AppColors.primaryColor30, BlendMode.srcIn),
                child: Image.asset(
                  'assets/logo/name.png',
                  height: 28,
                  fit: BoxFit.cover,
                ),
              ),
            )
                : Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(
                title,
                style: MainFonts.pageTitleText(color: AppColors.primaryColor30, fontSize: 22),
              ),
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
                onTap: () {
                  if (MyApp.loggedInUserId == "-1") {
                    loginRequiredObj.showLoginRequiredDialog(context);
                  } else {
                    Navigator.pushNamed(context, 'wallet');
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.2), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                  EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                  child: Row(
                    children: [
                      Icon(Icons.account_balance_wallet_outlined,
                          size: 18, color: AppColors.primaryColor30),
                      SizedBox(width: 4),
                      Container(
                          height: 21,
                          width: 21,
                          child: Image.asset('assets/icons/coin.png'))
                    ],
                  ),
                )),
            const SizedBox(width: 16),
            GestureDetector(
                onTap: () {
                  if (MyApp.loggedInUserId == "-1") {
                    loginRequiredObj.showLoginRequiredDialog(context);
                  } else {
                    Navigator.pushNamed(context, 'notification');
                  }
                },
                child: Icon(Icons.notifications_none_rounded,
                    size: 28, color: AppColors.primaryColor30)),
          ],
        ),
      ],
    ),
  );
}
