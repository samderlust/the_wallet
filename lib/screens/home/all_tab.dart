import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_wallet/bloc/code_bloc.dart';
import 'package:the_wallet/model/CardModel.dart';
import 'package:the_wallet/screens/card_detail.dart';

class AllTab extends StatelessWidget {
  final CodeBloc codeBloc;

  AllTab({this.codeBloc});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: codeBloc.getAllCard(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        List<CardModel> theList = snapshot.data;
        return GridView.builder(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          itemCount: theList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => CardDetail(
                              cardId: theList[index].uuid,
                            )));
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    theList[index].title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'rokkitt',
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
