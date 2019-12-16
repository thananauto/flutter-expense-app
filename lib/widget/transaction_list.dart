import 'package:flutter/material.dart';
import '../model/transaction.dart';
import 'package:intl/intl.dart';
import '../model/size_config.dart';
class TransactionList extends StatelessWidget {
  final List<Transaction> userTransaction;
  final Function deleteTransaction;

  TransactionList(
      {Key key,
      @required this.userTransaction,
      @required this.deleteTransaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.all(8.0),
      child: userTransaction.isEmpty
            ? LayoutBuilder(builder: (context,constraints){
              return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'No expense transaction found',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  SizedBox(height: 5),

                    Container(
                      height: constraints.maxHeight * 0.6,
                      width: 300,
                      child: Image.asset(
                        'assets/images/noexpensesspared.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                 
                ],
              );
            },)
            : ListView.builder(
                itemExtent: 100.0,
                itemCount: userTransaction.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: ListTile(
                      leading: Container(
                        height:48,
                        child: FittedBox(
                          child: CircleAvatar(
                              radius: 100.0,
                              child: Text(
                                  '\$${userTransaction[userTransaction.length - 1 - index].amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: Theme.of(context).textTheme.subhead.fontWeight,
                                    fontSize: 50.0, color: Theme.of(context).textTheme.subhead.color), ),
                            ),
                        ),
                      ),
                      title: Text(
                        userTransaction[userTransaction.length - 1 - index].title,
                        style: Theme.of(context).textTheme.title,
                      ),
                      subtitle: Text(
                        DateFormat('yMMMMd').format(
                            userTransaction[userTransaction.length - 1 - index]
                                .dateTime),
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      trailing: SizeConfig.screenWidth > 460 ?
                      FlatButton.icon(
                        icon: Icon(Icons.delete),
                        label: Text('Delete'),
                        color: Theme.of(context).errorColor,
                        onPressed: () => deleteTransaction(userTransaction[userTransaction.length - 1 - index]
                            .id),
                      ):
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Theme.of(context).errorColor,
                        onPressed: () => deleteTransaction(userTransaction[userTransaction.length - 1 - index]
                            .id),
                      ),
                    ),
                  );
                },
              ),
    );

  }
}
