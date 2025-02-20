import 'package:flutter/material.dart';
import 'package:dalalstreetfantasy/constants/boarder.dart';
import 'package:dalalstreetfantasy/utils/fonts.dart';

import '../../../../constants/color.dart';
import '../../../../utils/dropdown_items.dart';

class Dropdown extends StatefulWidget {
  @override
  _DropdownState createState() => _DropdownState();
}


class _DropdownState extends State<Dropdown> {
  String selectedValue = 'Option 1'; // Default selected value

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2, bottom: 2, left: 20, right: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryColor30,  // Set the background color here
        borderRadius: BorderRadius.circular(AppBoarderRadius.textFieldRadius),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          child: DropdownButton<String>(
            dropdownColor: AppColors.primaryColor30,
            style: MainFonts.textFieldText(),
                value: selectedValue,
                onChanged: (newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                items: Items.categorys.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
        ),
      ),
    );
  }
}
