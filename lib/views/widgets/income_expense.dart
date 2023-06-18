import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/colors.dart';
import '../../utils/theme.dart';

class IncomeExpense extends StatelessWidget {
  final bool isIncome;
  final String symbol;
  final double amount;
  IncomeExpense(
      {Key? key,
      required this.isIncome,
      required this.symbol,
      required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16.r,
          backgroundColor: isIncome ? Colors.green.withOpacity(.3) : Colors.red.withOpacity(.3),
          child: Icon(isIncome ? Icons.call_received : Icons.call_made, color: isIncome ? greenClr : redClr,
          ),
        ),
        SizedBox(width: 10.w,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isIncome ? 'Income' : 'Expense',
              style: Themes().subHeadingTextStyle.copyWith(color: isIncome ? greenClr : redClr,),
            ),
            SizedBox(height: 3,),
            Text('$symbol ${amount.toStringAsFixed(2)}'),
            SizedBox(height: 3,),
          ],
        ),
      ],
    );
  }
}
