import 'dart:async';
import 'dart:io';

import 'package:dalalstreetfantasy/utils/login_methods.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:dalalstreetfantasy/constants/color.dart';
import 'package:dalalstreetfantasy/features/authentication/data/repositories/users_repo.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/bloc/fetch_review/fetch_review_bloc.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/bloc/upload_review/upload_review_bloc.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/pages/home.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/pages/landing.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/pages/leaderboard.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/provider/bottom_nav_bar.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/snackbar.dart';
import 'package:dalalstreetfantasy/routes/route_generator.dart';
import 'package:dalalstreetfantasy/utils/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import 'features/authentication/data/repositories/upgrade_app_repo.dart';
import 'features/contests/data/models/user_item.dart';
import 'features/contests/data/repositories/banners_repo.dart';
import 'features/contests/data/repositories/realtime_db_repo.dart';
import 'features/contests/presentation/pages/mycontest.dart';
import 'features/contests/presentation/pages/account.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'features/contests/presentation/provider/portfolio_provider.dart';
import 'features/contests/presentation/provider/stock_select_provider.dart';
import 'features/contests/presentation/widgets/app_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Transparent Status Bar
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // transparent status bar
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark));

  // // Also for Bottom Android Button
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.top,
    SystemUiOverlay.bottom,
  ]);

  // Test
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
  //     .copyWith(systemNavigationBarColor: AppColors.backgroundColor60));

  // remove in production
  // await Upgrader.clearSavedSettings();

  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('6LclcJsqAAAAAOdIp6hs8dDttJVmTrBPEkw9J6ZP'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

await dotenv.load(fileName: ".env");

  // Messaging
  // final fcmTokent = await FirebaseMessaging.instance.getToken();
  // print(fcmTokent);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static String profileImageUrl = 'null';
  static String emailPattern = '';

  static List<String> profileIconList = [];
  static List<String> usernamesList = [];

  static int userId = -1;
  static String loggedInUserId = '';
  static String LOGIN_KEY = 'isLoggedIn';
  static String LOGIN_USERID_KEY = 'userToken';
  static String DOWNLOAD_VALUE_KEY = 'isFirstTime';
  static bool ENABLE_LEADERBOARD = false;

  static UserItem? userItem;

  static checkAnotherDeviceLogin(BuildContext context) async {
    String deviceId = await getUniqueDeviceId();

    UserServicesRepo usersRepo = UserServicesRepo();
    int result = await usersRepo.isLoginFromAnotherDevice(deviceId);

    if (result == 1) {
      mySnackBarShow(context, 'Just login from another device!');
      clearSharedPrefs();

      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacementNamed('signin');
      });
    } else if(result == -404){
      mySnackBarShow(context, 'User doesn\'t! exist!');
      clearSharedPrefs();
    } else if(result == -1){
      mySnackBarShow(context, 'Something went wrong!');
    }
  }

  getAllUsernames() async {
    MyApp.usernamesList = await getUsernameList();
  }

  getEmailPattern() async {
    RealTimeDbService realTimeDbService = RealTimeDbService();
    String? pattern = await realTimeDbService.getEmailAddressPattern();
    MyApp.emailPattern = pattern!;
  }

  static initUserId() async {
    String? userId = await LoginMethods.getUserId();
    if (userId != null) {
      MyApp.loggedInUserId = userId;
      getUserItemData(MyApp.loggedInUserId);
    } else {
      MyApp.loggedInUserId = '-1';
    }

    await BannerData.fetchBannerData();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getAllUsernames();
    getEmailPattern();
    getAllImageURLs();

    // PreLoading Images
    precacheImage(AssetImage("assets/icons/menus.png"), context);
    precacheImage(AssetImage("assets/icons/bell.png"), context);

    precacheImage(AssetImage("assets/icons/like.png"), context);
    precacheImage(AssetImage("assets/icons/reply.png"), context);
    precacheImage(AssetImage("assets/icons/like-fill.png"), context);
    precacheImage(AssetImage("assets/icons/reply-fill.png"), context);

    precacheImage(AssetImage("assets/icons/plus.png"), context);
    precacheImage(AssetImage("assets/icons/home.png"), context);
    precacheImage(AssetImage("assets/icons/search.png"), context);
    precacheImage(AssetImage("assets/icons/activity.png"), context);
    precacheImage(AssetImage("assets/icons/user.png"), context);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: ((context) => BottomNavigationProvider())),
          ChangeNotifierProvider(
              create: ((context) => StockProvider())),
          ChangeNotifierProvider(
              create: ((context) => PortfolioProvider())),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: ((context) => UploadReviewBloc())),
            BlocProvider(create: ((context) => FetchReviewBloc())),
          ],
          child: MaterialApp(
            theme: ThemeData(primarySwatch: mainAppColor),
            debugShowCheckedModeBanner: false,
            title: 'Profit11',
            builder: (context, widget) => UpgradeAlert(
              upgrader: Upgrader(
                canDismissDialog: false,
                showIgnore: false,
                showLater: false,
                showReleaseNotes: true,
                dialogStyle: Platform.isIOS
                    ? UpgradeDialogStyle.cupertino
                    : UpgradeDialogStyle.material,
                durationUntilAlertAgain: Duration(hours: 4),
              ),
              child: widget!,
            ),
            color: AppColors.primaryColor30,
            initialRoute: '/',
            onGenerateRoute: RouteGenerator().generateRoute,
          ),
        ));
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final RealTimeDbService _realTimeDbService = RealTimeDbService();

  _updateDownloadVal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool(MyApp.DOWNLOAD_VALUE_KEY) ?? true;

    if (isFirstTime) {
      await _realTimeDbService.updateDownloads();
      prefs.setBool(MyApp.DOWNLOAD_VALUE_KEY, false);
    }
  }

  Future<void> _setLeaderboardEnable() async {
    String? enable = await _realTimeDbService.getLeaderboardValue();
    if (!mounted) return; // Check if the widget is still in the tree

    setState(() {
      MyApp.ENABLE_LEADERBOARD = (enable != null && int.parse(enable) == 1);
    });
  }

  _checkLogin() async {
    bool isLoggedIn = await LoginMethods.isLoggedIn();

    if (!isLoggedIn) {
      Navigator.pushReplacementNamed(context, 'welcome');
    } else {
      Navigator.pushReplacementNamed(context, 'landing');
  }
}


  @override
  void initState() {
    _checkLogin();
    _setLeaderboardEnable();
    checkAppVersion(context);
    _updateDownloadVal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.splashScreen,
        body: Center(
            child: CircularProgressIndicator(
              color: AppColors.secondaryColor10,
              value: 1,
            )));
  }
}
