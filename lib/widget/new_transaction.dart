import 'package:flutter/material.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:intl/intl.dart';
import '../model/size_config.dart';

class NewTransaction extends StatefulWidget {
  final Function newTransaction;

  NewTransaction({Key key, this.newTransaction}) : super(key: key);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();
  DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Card(
        elevation: 5.0,
        child: Container(
          margin: SizeConfig.deviceOrientation == Orientation.landscape
             ? EdgeInsets.only(left: 25.0, right: 25.0)
              : EdgeInsets.only(),
          //height: 300,
          padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 8.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        Future.delayed(Duration(milliseconds: 50)).then((_) {
                          titleController.clear();
                          // FocusScope.of(context).unfocus();
                        });
                      }),
                ),
                onFieldSubmitted: (_) => _submitTransaction(),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [ThousandsFormatter(allowFraction: true)],
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      Future.delayed(Duration(milliseconds: 50)).then((_) {
                        amountController.clear();
                      });
                    },
                  ),
                ),
                onFieldSubmitted: (_) => _submitTransaction(),
              ),
              Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        _selectedDate == null
                            ? 'No date chosen'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    ),
                    FlatButton(
                      onPressed: () => _presentDatePicker(context),
                      child: Text(
                        'Select the date',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                  onPressed: _submitTransaction,
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Add transaction',
                    style: Theme.of(context).textTheme.button,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _submitTransaction() {
    if (amountController.text == null) {
      return;
    }
    var title = titleController.text;
    var amount = double.parse(amountController.text.replaceAll(",", ""));

    if (title.isEmpty || amount < 0 || _selectedDate == null) {
      return;
    }
    // titleController.clear();
    //amountController.clear();
    widget.newTransaction(title, amount, _selectedDate);

    Navigator.of(context).pop();
  }

  void _presentDatePicker(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((onValue) {
      if (onValue == null) {
        return;
      }
      setState(() {
        _selectedDate = onValue;
      });
    });
  }
}
