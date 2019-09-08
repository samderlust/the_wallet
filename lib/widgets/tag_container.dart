import 'package:flutter/material.dart';
import 'package:the_wallet/model/CardModel.dart';
import 'package:the_wallet/screens/card_detail.dart';

class TagContainer extends StatelessWidget {
  final CardModel card;

  const TagContainer({this.card});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CardDetail(
                    cardId: card.uuid,
                  ))),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: 30,
        decoration: BoxDecoration(
            color: Color(0xFF116F66),
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          card.title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
