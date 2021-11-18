import 'dart:io' as prefix0;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_wallet/bloc/recent_bloc.dart';
import 'package:the_wallet/widgets/barcode_format_dialog.dart';
import 'package:the_wallet/widgets/code_format_dropdown.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import '../bloc/code_bloc.dart';
import '../model/CardModel.dart';

class NewCard extends StatefulWidget {
  final String code;
  const NewCard({this.code});

  @override
  _NewCardState createState() => _NewCardState();
}

class _NewCardState extends State<NewCard> {
  TextEditingController _titleController;
  TextEditingController _desController;
  final String uuid = Uuid().v1();
  int _codeFormat = 6;

  prefix0.File _image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    var newImage;
    if (image != null) {
      newImage = await _cropImage(image);
    }

    setState(() {
      _image = newImage;
    });
  }

  Future<prefix0.File> _cropImage(prefix0.File imageFile) async {
    prefix0.File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      ratioX: 16.0,
      ratioY: 9.0,
      maxWidth: 512,
      maxHeight: 512,
      toolbarColor: Colors.teal,
      statusBarColor: Colors.teal,
      // toolbarWidgetColor: Colors.teal
    );
    return croppedFile;
  }

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
    final RecentBloc recentBloc = Provider.of<RecentBloc>(context);

    return Scaffold(
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
                      'SET UP NEW CARD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    CupertinoTextField(
                      controller: _titleController,
                      autocorrect: false,
                      placeholder: 'Title',
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
                      placeholder: 'Description',
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
                        data: codeBloc.code,
                        codeType: BarCodeType.values[_codeFormat],
                        lineWidth: 2.0,
                        barHeight: 90.0,
                        hasText: true,
                        onError: (error) {
                          print('error = $error');
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: _image == null
                          ? null
                          : Image.file(
                              _image,
                              width: width,
                              height: width * 0.56,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(
                      height: 10,
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
                  ],
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: (width) / 2,
                  height: 50,
                  child: FlatButton(
                    color: Color(0xff016F65),
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.cancel,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                Container(
                  width: (width) / 2,
                  height: 50,
                  child: FlatButton(
                    color: Colors.white,
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      final CardModel theCode = CardModel(
                        uuid: uuid,
                        code: widget.code,
                        title: _titleController.text,
                        description: _desController.text,
                        codeFormat: _codeFormat,
                      );
                      codeBloc.addCodeToList(theCode);
                      recentBloc.addToRecent(theCode.uuid);
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.check,
                      color: Color(0xff016F65),
                      size: 40,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
