import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker_app/models/transaction.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:progress_indicator/progress_indicator.dart';

class ReportTile extends StatelessWidget {
  final String category;
  final double spentAmount;
  final double budgetLimit;

  ReportTile({
    Key? key,
    required this.category,
    required this.spentAmount,
    required this.budgetLimit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6,),
        Text('Monthly Budget: $budgetLimit',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
        SizedBox(height: 6,),
        Text('Spent: $spentAmount',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),

        SizedBox(height: 20,),

        BarProgress(
          percentage: (spentAmount* 100/budgetLimit),
          backColor: Colors.grey,
          gradient: LinearGradient(colors: [Colors.redAccent, Colors.red]),
          showPercentage: true,
          textStyle:TextStyle(color: Colors.orange,fontSize: 30),
          stroke: 5,
          round: true,
        ),

      ],
    ),);
  }
}
