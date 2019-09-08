import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:the_wallet/screens/edit_card.dart';
import 'package:the_wallet/screens/new_card.dart';
import 'package:the_wallet/widgets/popup_comfirm.dart';
import '../bloc/code_bloc.dart';
import '../model/CardModel.dart';
import '../bloc/recent_bloc.dart';

class CardDetail extends StatefulWidget {
  final String cardId;

  CardDetail({this.cardId});

  @override
  _CardDetailState createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  bool _isRotated;

  @override
  void initState() {
    super.initState();
    _isRotated = false;
  }

  @override
  Widget build(BuildContext context) {
    print('uuid ${widget.cardId}');
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final CodeBloc codeBloc = Provider.of<CodeBloc>(context);
    final RecentBloc recentBloc = Provider.of<RecentBloc>(context);

    // final CardModel theCard = codeBloc.findCardById(widget.cardId);

    return FutureBuilder(
      future: codeBloc.findCardById(widget.cardId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        CardModel theCard = snapshot.data;
        recentBloc.addToRecent(theCard.uuid);

        return Scaffold(
          floatingActionButton: SpeedDial(
            marginRight: 18,
            marginBottom: 20,
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            // onOpen: setVisible,
            // onClose: setInvisible,
            tooltip: 'Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            backgroundColor: Color(0xFF16a085),
            foregroundColor: Colors.black,
            elevation: 8.0,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                child: Icon(Icons.delete),
                backgroundColor: Colors.red,
                label: 'Delete',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return PopupComfirm(
                        title: "Delete this card?",
                        subTitle: "This card will be removed from your phone",
                        onCancel: () => Navigator.of(context).pop(),
                        onDelete: () {
                          recentBloc.removefromRecent(theCard.uuid);
                          codeBloc.removeCard(theCard.uuid);
                          Navigator.of(context).pop();
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.edit),
                backgroundColor: Color(0xff016F65),
                label: 'Edit Card',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCard(
                        theCard: theCard,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
          body: Stack(
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
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Hero(
                            tag: "${theCard.uuid}_title",
                            child: Text(
                              theCard.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontFamily: 'rokkitt',
                                letterSpacing: 2,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          theCard.description,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'rokkitt',
                            fontWeight: FontWeight.w300,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.center,
                      child: RotationTransition(
                        turns:
                            AlwaysStoppedAnimation((_isRotated ? 90 : 0) / 360),
                        child: Hero(
                          tag: theCard.uuid,
                          child: BarCodeImage(
                            data: theCard.code,
                            codeType: BarCodeType.values[theCard.codeFormat],
                            lineWidth: 2.0,
                            barHeight: 90.0,
                            // hasText: true,
                            onError: (error) {
                              print('error = $error');
                            },
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: width,
                      height: 60,
                      color: Colors.red,
                      child: FlatButton(
                        color: Colors.white,
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          setState(() {
                            _isRotated = !_isRotated;
                          });
                          print(_isRotated);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Spacer(),
                            Icon(
                              Icons.rotate_90_degrees_ccw,
                              color: Color(0xff016F65),
                              size: 40,
                            ),
                            SizedBox(width: 20),
                            Text(
                              'Rotate',
                              style: TextStyle(
                                color: Color(0xff016F65),
                                fontSize: 20,
                                fontFamily: 'rokkitt',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                              ),
                            ),
                            Spacer(),
                            Spacer(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
