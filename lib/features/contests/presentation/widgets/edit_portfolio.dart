
import 'package:dalalstreetfantasy/features/contests/data/models/leauge_item.dart';
import 'package:dalalstreetfantasy/features/contests/presentation/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../constants/color.dart';
import '../../data/models/portfolio.dart';
import '../../data/models/portolio_item.dart';
import '../../data/repositories/stock_repo.dart';
import '../../domain/entities/portfolio_parameters.dart';
import '../provider/portfolio_provider.dart';
import '../provider/stock_select_provider.dart';

class EditPortfolioButton extends StatefulWidget {
  final String startTime;
  final Portfolio portfolio;
  final LeagueItem leagueItem;
  final String stockListType;

  const EditPortfolioButton({
    required this.startTime,
    required this.portfolio,
    required this.leagueItem,
    required this.stockListType,
    Key? key,
  }) : super(key: key);

  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<EditPortfolioButton> {
  late PortfolioProvider portfolioProvider;
  late StockProvider stockProvider;

  @override
  void initState() {
    super.initState();
    portfolioProvider = Provider.of<PortfolioProvider>(context, listen: false);
    stockProvider = Provider.of<StockProvider>(context, listen: false);
    preInitializeData();
  }

  void preInitializeData() {
    fetchStocks(
      context: context,
      stockListType: widget.stockListType,
      onChange: () {
        setState(() {});
      },
    );
  }

  void initializePortfolio() {
    try{
      portfolioProvider.clearPortfolio();
      stockProvider.clearStocks();

      for (PortfolioItem item in widget.portfolio.items) {
        portfolioProvider.addToPortfolio(item);
        stockProvider.toggleSelection(item.symbol);
      }
    } catch (e){
      throw Exception('Error during portfolio initialization: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    initializePortfolio();

    return GestureDetector(
      onTap: () {
        DateTime now = DateTime.now();
        String formattedTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

        if (formattedTime.compareTo(widget.startTime.toString()) < 0) {

          if (portfolioProvider.selectedItems.isNotEmpty &&
              stockProvider.selectedStockCount > 0) {
            Navigator.pushNamed(
              context,
              'create_portfolio',
              arguments: {
                'leagueItem': widget.leagueItem,
                'portfolioId': widget.portfolio.portfolioId,
              },
            );
          }
        } else {
          mySnackBarShow(context, 'Contest is already started!');
        }
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryColor30,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.edit,
          color: AppColors.backgroundColor60,
          size: 18,
        ),
      ),
    );
  }
}
