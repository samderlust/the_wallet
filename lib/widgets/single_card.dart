import 'package:flutter/material.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import '../model/CardModel.dart';
import '../screens/card_detail.dart';

class SingleCard extends StatelessWidget {
  CardModel theCard;

  SingleCard({this.theCard});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => CardDetail(
                      cardId: theCard.uuid,
                    )));
      },
      child: Container(
        height: 120,
        width: width,
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Color(0xff97EACA),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Hero(
              tag: theCard.uuid,
              child: BarCodeImage(
                data: theCard.code,
                codeType: BarCodeType.values[theCard.codeFormat],
                lineWidth: 2.0,
                barHeight: 85.0,
                // hasText: true,
                onError: (error) {
                  print('error = $error');
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child: Hero(
                  tag: "${theCard.uuid}_title",
                  child: Text(
                    theCard.title,
                    style: TextStyle(
                      color: Color(0xff009688),
                      fontSize: 18,
                      fontFamily: 'rokkitt',
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
