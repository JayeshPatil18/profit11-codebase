import 'package:dalalstreetfantasy/utils/method1.dart';
import 'package:flutter/material.dart';

import '../../../../constants/color.dart';
import '../../../../main.dart';
import '../../../contests/data/models/user_item.dart';
import '../../../contests/data/repositories/user_repo.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {

  double walletBalance = 0;

  _setWalletBalance() async {
    UserItem user = await getUserItem(MyApp.loggedInUserId);
    setState(() {
      walletBalance = user.walletBalance;
    });
  }
  
  @override
  void initState() {
    super.initState();

    _setWalletBalance();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor30,
        title: Text('Wallet'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          await Future.delayed(Duration(milliseconds: 500));
          await _setWalletBalance();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            margin: EdgeInsets.only(bottom: 60, top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 40,
                        width: 40,
                        child: Image.asset('assets/icons/coin.png')),
                    SizedBox(width: 4),
                    Text(
                      '${formatDoubleWithCommas(walletBalance)}',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 20)
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  'BALANCE',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'add_cash', arguments: {
                            'walletBalance': walletBalance
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.primaryColor30, // Button background color
                          minimumSize: Size(double.infinity, 50), // Button size
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Add Amount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'withdraw', arguments: {
                            'walletBalance': walletBalance
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.primaryColor30, // Button background color
                          minimumSize: Size(double.infinity, 50), // Button size
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Withdraw Amount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}