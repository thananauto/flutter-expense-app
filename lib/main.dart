import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './widget/new_transaction.dart';
import './model/transaction.dart';
import 'widget/transaction_list.dart';
import './widget/chart_transaction.dart';
import './model/size_config.dart';
import 'package:flutter/services.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample Expense Report',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.amber,
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              subhead: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              subtitle: TextStyle(fontSize: 15, color: Colors.black),
              button: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
        ),
      ),
      home: MyExpenseApp(),
    );
  }
}

class MyExpenseApp extends StatefulWidget {
  @override
  _MyExpenseAppState createState() => _MyExpenseAppState();
}

class _MyExpenseAppState extends State<MyExpenseApp> {
  final List<Transaction> _userTransaction = [
    /*Transaction(
      id: 'id1',
      title: 'New Shoes',
      amount: 20.0,
      dateTime: DateTime.now(),
    ),
    Transaction(
      id: 'id2',
      title: 'Milk',
      amount: 20.00,
      dateTime: DateTime.now(),
    ),*/
  ];

  void _addTransaction(String title, double amount, DateTime dateTime) {
    var tx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        dateTime: dateTime);

    setState(() {
      _userTransaction.add(tx);
    });
  }

  void _startAddNewTransaction() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: NewTransaction(
              newTransaction: _addTransaction,
            ),
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((element) {
        return element.id == id;
      });
    });
  }

  List<Transaction> get _getLastSevenTransaction {
    return _userTransaction.where((tx) {
      return tx.dateTime.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  bool _showGraph = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final PreferredSizeWidget appBar = Platform.isIOS ? CupertinoNavigationBar(
      middle: Text('My Expense Report'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(child: Icon(CupertinoIcons.add,),onTap: () => _startAddNewTransaction(),)
        ],
      ),
    ) : AppBar(
      title: Text(
        'My Expense Report',
        style: Theme.of(context).appBarTheme.textTheme.title,
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () => _startAddNewTransaction(),
          icon: Icon(Icons.add),
        ),
      ],
    );
    var txLists = Container(
      height: SizeConfig.deviceOrientation == Orientation.portrait
          ? (SizeConfig.screenHeight -
                  appBar.preferredSize.height -
                  SizeConfig.deviceTopPadding) *
              0.7
          : (SizeConfig.screenHeight -
                  appBar.preferredSize.height -
                  SizeConfig.deviceTopPadding) *
              1,
      child: TransactionList(
          userTransaction: _userTransaction,
          deleteTransaction: _deleteTransaction),
    );
    var graphArea = Container(
        height: SizeConfig.deviceOrientation == Orientation.portrait
            ? (SizeConfig.screenHeight -
                    appBar.preferredSize.height -
                    SizeConfig.deviceTopPadding) *
                0.3
            : (SizeConfig.screenHeight -
                    appBar.preferredSize.height -
                    SizeConfig.deviceTopPadding) *
                0.8,
        child: ChartTransaction(listTransaction: _getLastSevenTransaction));
    var showIconButton = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Show graph',
          style: Theme.of(context).textTheme.subtitle,
        ),
        Switch.adaptive(
          activeColor: Theme.of(context).accentColor,
            value: _showGraph,
            onChanged: (value) {
              setState(() {
                _showGraph = value;
              });
            }),
      ],
    );
    final landscape = SizeConfig.deviceOrientation == Orientation.landscape;
    var _pageBody = SafeArea(
        child: SingleChildScrollView(
              child: Container(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    //add the code for switch
                    if(landscape) showIconButton,
                    if(!landscape) graphArea,
                    if(!landscape) txLists,
                    if(landscape) _showGraph ? graphArea : txLists,
                  ],
                ),
              ),
            ),
    );
        return Platform.isIOS ? CupertinoPageScaffold(child: _pageBody, navigationBar: appBar,) : Scaffold(
          appBar: appBar,
          body: _pageBody,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(),
        ),
      );
  }
}
