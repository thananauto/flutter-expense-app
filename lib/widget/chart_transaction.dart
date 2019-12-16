import 'package:flutter/material.dart';
import '../model/transaction.dart';
import '../model/chart.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';

class ChartTransaction extends StatelessWidget {
  final List<Transaction> listTransaction;

  ChartTransaction({Key key, this.listTransaction}) : super(key: key);

  List<Chart> get getTransaction {
    return List.generate(7, (index) {
      //get the last seven dates to display in charts
      var dateTimeNow = DateTime.now().subtract(
        Duration(days: index),
      );

      //get the total amount spent on each day
      var totalamount = 0.0;
      for (var i = 0; i < listTransaction.length; i++) {
        if (listTransaction[i].dateTime.day == dateTimeNow.day &&
            listTransaction[i].dateTime.month == dateTimeNow.month &&
            listTransaction[i].dateTime.year == dateTimeNow.year) {
          totalamount += listTransaction[i].amount;
        }
      }

      return Chart(DateFormat.E().format(dateTimeNow).substring(0,1), totalamount);
    }).reversed.toList();
  }

  double get _maxSpending {
    return getTransaction.fold(0.0, (sum, item) {
      return sum + item.amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Card(
        elevation: 5,
        margin: const EdgeInsets.all(10.0),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: getTransaction.map((chart) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  label: chart.dateTime,
                  totalSpendingAmount: chart.amount,
                  spendingPicture:chart.amount == 0? 0.0 : chart.amount / _maxSpending,
                ),
              );
            }).toList(),
          ),
        ),

    );
  }
}
