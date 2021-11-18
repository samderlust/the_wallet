import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_wallet/widgets/barcode_format_dialog.dart';
import 'package:the_wallet/widgets/code_format_dropdown.dart';
import 'package:uuid/uuid.dart';

import '../bloc/code_bloc.dart';
import '../model/CardModel.dart';

class EditCard extends StatefulWidget {
  final CardModel theCard;

  const EditCard({this.theCard});

  @override
  _EditCardState createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  TextEditingController _titleController;
  TextEditingController _desController;
  final String uuid = Uuid().v1();
  int _codeFormat = -1;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: "");
    _desController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final CodeBloc codeBloc = Provider.of<CodeBloc>(context);
    // setState(() {
    //   _codeFormat = widget.theCard.codeFormat;
    // });
    return Scaffold(
      floatingActionButton: Container(
        width: 70.0,
        height: 70.0,
        child: Hero(
          tag: 'heroButton',
          child: RawMaterialButton(
              fillColor: Color(0xff016F65),
              shape: CircleBorder(),
              elevation: 0.0,
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () {
                final uuid = widget.theCard.uuid;
                final title = _titleController.text == ""
                    ? widget.theCard.title
                    : _titleController.text;
                final description = _desController.text == ""
                    ? widget.theCard.description
                    : _desController.text;
                final code = widget.theCard.code;
                codeBloc.editCardFromList(
                  CardModel(
                      code: code,
                      uuid: uuid,
                      description: description,
                      title: title,
                      codeFormat: _codeFormat),
                );
                Navigator.pop(context);
              }),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff97EACA), Color(0xffD4EA97)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.4]),
        ),
        constraints: BoxConstraints.expand(),
        child: Column(
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'EDIT CARD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    CupertinoTextField(
                      controller: _titleController,
                      autocorrect: false,
                      placeholder: widget.theCard.title,
                      style: TextStyle(
                        color: Color(0xFF116F66),
                        fontSize: 20,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.5,
                          color: Color(0xFF116F66),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    SizedBox(
                      height: 29,
                    ),
                    CupertinoTextField(
                      controller: _desController,
                      autocorrect: false,
                      placeholder: widget.theCard.description,
                      style: TextStyle(
                        color: Color(0xFF116F66),
                        fontSize: 20,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.5,
                          color: Color(0xFF116F66),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Hero(
                      tag: uuid,
                      child: BarCodeImage(
                        data: widget.theCard.code,
                        codeType: BarCodeType.values[_codeFormat == -1
                            ? widget.theCard.codeFormat
                            : _codeFormat],
                        lineWidth: 1.5,
                        barHeight: 90.0,
                        hasText: true,
                        onError: (error) {
                          print('error = $error');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: <Widget>[
                  Text('Choose barcode format'),
                  Spacer(),
                  CodeFormatDropdown(
                    onPick: (code) {
                      setState(() {
                        _codeFormat = code;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.info),
                    iconSize: 34,
                    color: Colors.teal,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BarcodeFormatDialog();
                        },
                      );
                    },
                  )
                ],
              ),
            ),
            Spacer(),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: (width),
                  height: 60,
                  child: FlatButton(
                    color: Colors.white,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 40,
                        ),
                        SizedBox(width: 20),
                        Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontFamily: 'rokkitt',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
