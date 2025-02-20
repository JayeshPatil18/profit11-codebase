import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalalstreetfantasy/constants/color.dart';
import 'package:dalalstreetfantasy/features/contests/data/repositories/portfolio_repo.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/provider/stock_select_provider.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/snackbar.dart';
import 'package:dalalstreetfantasy/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/values.dart';
import '../../data/models/upload_portfolio.dart';
import '../provider/portfolio_provider.dart';

class ConfirmationBottomSheet extends StatefulWidget {
  final String leagueId;
  final String portfolioId;
  final int totalWeightage;
  final double totalCoinsGiven;
  final double entryFee;

  const ConfirmationBottomSheet({super.key, required this.portfolioId, required this.leagueId, required this.totalWeightage, required this.totalCoinsGiven, required this.entryFee});


  @override
  State<ConfirmationBottomSheet> createState() => _ConfirmationBottomSheetState();
}

class _ConfirmationBottomSheetState extends State<ConfirmationBottomSheet> {
  bool _isChecked = false;

  checkboxUpdate(bool value){
    setState(() {
      _isChecked = value!;
    });
  }

  bool isLoading = false;

  setIsLoading(bool isLoadingVal) {
    setState(() {
      isLoading = isLoadingVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Confirmation',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Entry',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '${widget.entryFee.toStringAsFixed(1)} ₹',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Usable discount bonus',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '0 ₹',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          const Divider(thickness: 1, height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'To Pay',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${widget.entryFee.toStringAsFixed(1)} ₹',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: _isChecked,
                onChanged: (bool? value) {
                  checkboxUpdate(value!);
                },
              ),
              SizedBox(width: 5),
              GestureDetector(
                onTap: (){
                  checkboxUpdate(!_isChecked);
                },
                child: Text(
                  'I agree with standard T&Cs',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () async {
                  if (_isChecked) {
                    if(!isLoading){
                      int result = -1;
                      if(widget.entryFee == 0){
                        result = 1;
                      } else {
                        result = await checkAndDeductWalletBalance(MyApp.loggedInUserId, widget.entryFee);
                      }

                      setIsLoading(true);

                      if (result == 1) {

                        final stockProvider = Provider.of<StockProvider>(context, listen: false);
                        final portfolioProvider = Provider.of<PortfolioProvider>(context, listen: false);

                        if(portfolioProvider.selectedItems.isNotEmpty){
                          final uploadPortfolio = UploadPortfolio(
                            portfolioId: widget.portfolioId,
                            leagueId: widget.leagueId,
                            totalWeightage: widget.totalWeightage,
                            portfolioValue: widget.totalCoinsGiven,
                            initialPortfolioValue: widget.totalCoinsGiven,
                            userId: MyApp.loggedInUserId,
                            stocks: portfolioProvider.selectedItems,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                            returns: 0.0,
                          );

                          final FirebaseFirestore _firestore = FirebaseFirestore.instance;
                          final PortfolioService _portfolioService = PortfolioService(_firestore);

                          try{
                            await _portfolioService.uploadPortfolio(uploadPortfolio);

                            stockProvider.clearStocks();
                            portfolioProvider.clearPortfolio();

                            Navigator.pushNamed(context, 'congratulation_page');
                          } catch(e){
                            mySnackBarShow(context, 'Something went wrong!');
                          }
                        }

                      } else if (result == 0) {
                        mySnackBarShow(context, 'Insufficient balance. Please add funds to your wallet.');
                      } else if (result == -1) {
                        mySnackBarShow(context, 'An error occurred while processing the transaction.');
                      }

                      setIsLoading(false);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                backgroundColor: _isChecked ? Colors.green : Colors.green.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                ),
              ),
              child: isLoading == false ? Text('Join Contest') : SizedBox(
                  width: 30,
                  height: 30,
                  child: Center(
                      child: CircularProgressIndicator(
                          strokeWidth:
                          AppValues.progresBarWidth,
                          color:
                          AppColors.backgroundColor60))),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<int> checkAndDeductWalletBalance(String userId, double deductionAmount) async {
    try {
      // Reference to the user's document in Firestore
      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

      // Fetch the current wallet balance
      DocumentSnapshot snapshot = await userDoc.get();

      if (snapshot.exists) {
        double currentBalance = snapshot.get('walletBalance');

        // Check if the wallet has sufficient funds
        if (currentBalance >= deductionAmount) {
          // Deduct the amount
          await userDoc.update({
            'walletBalance': currentBalance - deductionAmount,
          });

          return 1; // Sufficient funds and deduction successful
        } else {
          return 0; // Insufficient funds
        }
      } else {
        return -1; // User document does not exist
      }
    } catch (e) {
      print('Error while processing wallet deduction: $e');
      return -1; // Error occurred
    }
  }

}