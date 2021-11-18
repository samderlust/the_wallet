import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_wallet/bloc/code_bloc.dart';
import 'package:the_wallet/bloc/recent_bloc.dart';
import 'package:the_wallet/model/CardModel.dart';
import 'package:the_wallet/screens/card_detail.dart';
import 'package:the_wallet/screens/edit_card.dart';
import 'package:the_wallet/widgets/popup_comfirm.dart';
import 'package:vibration/vibration.dart';

class CardWithName extends StatefulWidget {
  final CardModel theCard;

  const CardWithName({Key key, this.theCard}) : super(key: key);
  @override
  _CardWithNameState createState() => _CardWithNameState();
}

class _CardWithNameState extends State<CardWithName>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _colorAnimation;
  AnimationController _slideController;
  Animation<double> _slideAnimation;
  bool _onLongPress = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _colorAnimation =
        ColorTween(begin: Colors.teal, end: Colors.teal[200]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );

    _slideAnimation = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.ease,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _slideController.dispose();
    super.dispose();
  }

  _onCancel() {
    setState(() {
      _controller.reset();
      _controller.stop();
      _slideController.reverse();
      _onLongPress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final CodeBloc codeBloc = Provider.of<CodeBloc>(context);
    final RecentBloc recentBloc = Provider.of<RecentBloc>(context);
    return Stack(
      children: <Widget>[
        GestureDetector(
          onLongPress: () {
            if (_onLongPress) return;
            Vibration.vibrate(duration: 50);
            setState(() {
              _controller.repeat();
              _slideController.forward();
              _onLongPress = true;
            });
          },
          onTap: () {
            if (!_onLongPress)
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => CardDetail(
                            cardId: widget.theCard.uuid,
                          )));
            else
              _onCancel();
          },
          child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _colorAnimation.value,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      _onLongPress ? "" : widget.theCard.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: 'rokkitt',
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                );
              }),
        ),
        AnimatedBuilder(
            animation: _slideController,
            builder: (context, child) {
              return Positioned(
                top: 0,
                right: _slideAnimation.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Cancel',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        IconButton(
                          onPressed: _onCancel,
                          icon: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.cancel,
                              size: 20,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _onCancel();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditCard(
                                  theCard: widget.theCard,
                                ),
                              ),
                            );
                          },
                          icon: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.mode_edit,
                              size: 20,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return PopupComfirm(
                                  title: "Delete this card?",
                                  subTitle:
                                      "This card will be removed from your phone",
                                  onCancel: () => Navigator.of(context).pop(),
                                  onDelete: () {
                                    _onCancel();
                                    recentBloc
                                        .removefromRecent(widget.theCard.uuid);
                                    codeBloc.removeCard(widget.theCard.uuid);
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            );
                          },
                          icon: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.delete_forever,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            })
      ],
    );
  }
}
