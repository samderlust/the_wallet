import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:the_wallet/widgets/single_card.dart';
import '../bloc/code_bloc.dart';
import 'package:provider/provider.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import './card_detail.dart';

class SeacrchScreen extends StatefulWidget {
  @override
  _SeacrchScreenState createState() => _SeacrchScreenState();
}

class _SeacrchScreenState extends State<SeacrchScreen> {
  TextEditingController _searchController;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final CodeBloc codeBloc = Provider.of<CodeBloc>(context);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: (Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff97EACA), Color(0xffD4EA97)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.4]),
            ),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          codeBloc.clearSearchList();
                        },
                      ),
                      Spacer(),
                      Text(
                        'Find a card',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'rokkitt',
                          letterSpacing: 2,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Hero(
                    tag: 'searchTextField',
                    child: Material(
                      color: Colors.transparent,
                      child: CupertinoTextField(
                        controller: _searchController,
                        onSubmitted: (_) =>
                            codeBloc.findCard(_searchController.text),
                        autocorrect: false,
                        autofocus: false,
                        suffix: IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Color(0xFF116F66),
                            ),
                            onPressed: () =>
                                codeBloc.findCard(_searchController.text)),
                        style: TextStyle(
                          color: Color(0xFF116F66),
                          fontSize: 20,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.5,
                            color: Color(0xFF116F66),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: width,
                    height: height * .7,
                    child: ListView.builder(
                      itemCount: codeBloc.searchList.length,
                      itemBuilder: (context, index) {
                        var theCard = codeBloc.searchList[index];
                        return SingleCard(
                          theCard: theCard,
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
