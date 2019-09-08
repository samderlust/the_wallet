import 'package:flutter/material.dart';

class BarcodeFormatDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text("Choose the right barcode format"),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
                """There are several formats of the barcode. The format is chosen by the organization which issued the card. Choose the right one helps your card can be read by that specific organization.
Hint: you should play around with the formats that make the barcode above looks similar to your actual one.
Common formats are: Code39, code 128, code93."""),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Color(0xFF16a085),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Ok',
              style: TextStyle(color: Colors.white),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
