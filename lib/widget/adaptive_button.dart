import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AdaptiveButton extends StatelessWidget {
  final String text;
  final Function onclick;
   AdaptiveButton({Key key, this.text, this.onclick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? CupertinoButton(
                child: Text(
                    '$text',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: onclick,
                  color: Theme.of(context).primaryColor,
              ) : RaisedButton(
                  onPressed: onclick,
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    '$text',
                    style: Theme.of(context).textTheme.button,
                  ),
                  );
    
  }
}