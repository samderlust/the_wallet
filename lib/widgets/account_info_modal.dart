import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_wallet/bloc/account_bloc.dart';

class AccountInfoModal extends StatefulWidget {
  @override
  _AccountInfoModalState createState() => _AccountInfoModalState();
}

class _AccountInfoModalState extends State<AccountInfoModal> {
  bool isEditing = false;
  TextEditingController _nameInputController;

  @override
  void initState() {
    super.initState();
    _nameInputController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = Provider.of<AccountBloc>(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text("Your Account Info"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                !isEditing
                    ? Text(
                        accountBloc.userName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Container(
                        width: 170,
                        height: 50,
                        child: CupertinoTextField(
                          autofocus: true,
                          controller: _nameInputController,
                          placeholder: accountBloc.userName == ''
                              ? 'Input your name'
                              : accountBloc.userName,
                          style: TextStyle(
                            color: Color(0xFF116F66),
                            fontSize: 20,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.5,
                              color: Color(0xFF116F66),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    if (isEditing && _nameInputController.text != '') {
                      accountBloc.setTheName(_nameInputController.text);
                    }
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Icon(
                      !isEditing ? Icons.edit : Icons.check,
                      size: 20,
                      color: Colors.teal,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text("You have ${accountBloc.totalCardsNo} cards")
          ],
        ),
      ),
    );
  }
}
