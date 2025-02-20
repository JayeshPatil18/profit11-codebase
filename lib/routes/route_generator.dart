import 'package:dalalstreetfantasy/features/authentication/presentation/pages/signup.dart';
import 'package:dalalstreetfantasy/features/contests/data/models/leauge_item.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/pages/congratulation_page.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/pages/create_portfolio.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/pages/leagues.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/pages/profile.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/pages/view_contest.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/pages/weightage_page.dart';
import 'package:dalalstreetfantasy/features/wallet/presentation/pages/add_bank_details.dart';
import 'package:dalalstreetfantasy/features/wallet/presentation/pages/upi_payment_gateway.dart';
import 'package:dalalstreetfantasy/features/wallet/presentation/pages/wallet_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalalstreetfantasy/features/contests/domain/entities/image_argument.dart';
import 'package:dalalstreetfantasy/features/contests/domain/entities/verify_arguments.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/pages/edit_profile.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/pages/landing.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/pages/notification.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/pages/upload_review.dart';
import 'package:dalalstreetfantasy/features/authentication/presentation/pages/verify_phone.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/pages/view_image.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/pages/view_profile.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/pages/view_replies.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/pages/view_review.dart';
import 'package:dalalstreetfantasy/main.dart';

import '../features/authentication/presentation/pages/signin.dart';
import '../features/authentication/presentation/pages/welcome.dart';
import '../features/contests/data/models/user_item.dart';
import '../features/contests/domain/entities/contest_details.dart';
import '../features/contests/domain/entities/id_argument.dart';
import '../features/contests/domain/entities/phone_no_argument.dart';
import '../features/contests/domain/entities/portfolio_parameters.dart';
import '../features/contests/domain/entities/string_argument.dart';
import '../features/contests/domain/entities/two_string_argument.dart';
import '../features/contests/presentation/pages/aboutus.dart';
import '../features/contests/presentation/pages/feedback.dart';
import '../features/contests/presentation/pages/privacy_policy.dart';
import '../features/contests/presentation/pages/settings.dart';
import '../features/contests/presentation/pages/terms_conditions.dart';
import '../features/contests/presentation/pages/view_post.dart';
import '../features/wallet/presentation/pages/add_cash.dart';
import '../features/wallet/presentation/pages/add_cash_cashfree.dart';
import '../features/wallet/presentation/pages/add_cash_razorpay.dart';
import '../features/wallet/presentation/pages/privacy_policies.dart';
import '../features/wallet/presentation/pages/refund_policy.dart';
import '../features/wallet/presentation/pages/select_payment_method.dart';
import '../features/wallet/presentation/pages/terms_conditions.dart';
import '../features/wallet/presentation/pages/webview_cashfree.dart';
import '../features/wallet/presentation/pages/withdraw_cash.dart';
import '../features/wallet/presentation/pages/withdraw_request_success.dart';

class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Splash());

      case 'welcome':
        return MaterialPageRoute(builder: (_) => WelcomePage());

      case 'landing':
        return MaterialPageRoute(builder: (_) => const LandingPage());

      case 'leagues':
        if (args is ContestDetails) {
          return MaterialPageRoute(
            builder: (_) => LeaguesPage(
              startTime: args.startTime,
              endTime: args.endTime,
              contestId: args.contestId,
            ),
          );
        }
        return _errorRoute();

      case 'create_portfolio':
        final arguments = settings.arguments as Map<String, dynamic>?;

        if (arguments == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('No arguments passed')),
            ),
          );
        }

        return MaterialPageRoute(
            builder: (_) => CreatePortfolioPage(
                leagueItem: arguments['leagueItem'],
                portfolioId: arguments['portfolioId']));

      case 'weightage_page':
        final arguments = settings.arguments as Map<String, dynamic>?;

        if (arguments == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('No arguments passed')),
            ),
          );
        }

        return MaterialPageRoute(
            builder: (_) => WeightagePage(
                leagueItem: arguments['leagueItem'],
                portfolioId: arguments['portfolioId']));

      case 'congratulation_page':
        return MaterialPageRoute(builder: (_) => CongratulationPage());

      case 'view_contest':
        final arguments = settings.arguments as Map<String, dynamic>?;

        if (arguments == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('No arguments passed')),
            ),
          );
        }

        return MaterialPageRoute(
            builder: (_) => ViewContestPage(
                  leagueItem: arguments['league'],
                  rank: arguments['rank'],
                  prize: arguments['prize'],
                ));

      case 'wallet':
        return MaterialPageRoute(builder: (_) => WalletPage());

      case 'webview_cashfree':
        final arguments = settings.arguments as Map<String, dynamic>?;

        if (arguments == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('No arguments passed')),
            ),
          );
        }

        // Extract the values from arguments
        final amount = arguments['amount'];
        final customerId = arguments['customerId'];
        final customerName = arguments['customerName'];
        final customerEmail = arguments['customerEmail'];
        final customerPhone = arguments['customerPhone'];

        return MaterialPageRoute(
            builder: (_) => WebCashFreeGateway(
                  amount: amount,
                  customerId: customerId,
                  customerName: customerName,
                  customerEmail: customerEmail,
                  customerPhone: customerPhone,
                ));

      case 'add_cash_cashfree':
        final arguments = settings.arguments as Map<String, dynamic>?;

        if (arguments == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('No arguments passed')),
            ),
          );
        }

        // Extract the values from arguments
        final walletBalance = arguments['walletBalance'];

        return MaterialPageRoute(
            builder: (_) => AddCashCashFree(
                  walletBalance: walletBalance,
                ));

      case 'add_cash_razorpay':
        final arguments = settings.arguments as Map<String, dynamic>?;

        if (arguments == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('No arguments passed')),
            ),
          );
        }

        // Extract the values from arguments
        final walletBalance = arguments['walletBalance'];

        return MaterialPageRoute(
            builder: (_) => AddCashRazorpay(
                  walletBalance: walletBalance,
                ));

      case 'add_cash':
        final arguments = settings.arguments as Map<String, dynamic>?;

        if (arguments == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('No arguments passed')),
            ),
          );
        }

        // Extract the values from arguments
        final walletBalance = arguments['walletBalance'];

        return MaterialPageRoute(
            builder: (_) => AddCashPage(
                  walletBalance: walletBalance,
                ));

      case 'withdraw':
        final arguments = settings.arguments as Map<String, dynamic>?;

        if (arguments == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('No arguments passed')),
            ),
          );
        }

        // Extract the values from arguments
        final walletBalance = arguments['walletBalance'];

        return MaterialPageRoute(
            builder: (_) => WithdrawCashPage(
                  walletBalance: walletBalance,
                ));

      case 'privacy':
        return MaterialPageRoute(builder: (_) => PrivacyPolicy());

      case 'terms':
        return MaterialPageRoute(builder: (_) => TermsAndConditions());

      case 'refund':
        return MaterialPageRoute(builder: (_) => RefundPolicy());

      case 'payment_gateway':
        final arguments = settings.arguments as Map<String, dynamic>?;

        if (arguments == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('No arguments passed')),
            ),
          );
        }

        return MaterialPageRoute(
            builder: (_) => UpiPaymentGateway(amount: arguments['amount']));

      
      case 'verifyphone':
        PhoneNoArguments phoneNoArguments =
            settings.arguments as PhoneNoArguments;

        String phoneNo = phoneNoArguments.phoneNo;
        String countryCode = phoneNoArguments.countryCode;

        return MaterialPageRoute(
            builder: (_) =>
                VerifyPhoneNo(phoneNo: phoneNo, countryCode: countryCode));

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: const Center(
          child: Text("ERROR"),
        ),
      );
    });
  }
}
