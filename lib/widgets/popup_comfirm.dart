import 'package:flutter/material.dart';

class PopupComfirm extends StatelessWidget {
  VoidCallback onDelete;
  VoidCallback onCancel;
  String title;
  String subTitle;

  PopupComfirm({this.onCancel, this.onDelete, this.subTitle, this.title});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(subTitle),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
          onPressed: onDelete,
        ),
        SizedBox(
          width: 5,
        ),
        FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Color(0xFF16a085),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          onPressed: onCancel,
        )
      ],
    );
  }
}
