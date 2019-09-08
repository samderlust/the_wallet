import 'package:flutter/material.dart';

class OnboardFirstPage extends StatefulWidget {
  @override
  _OnboardFirstPageState createState() => _OnboardFirstPageState();
}

class _OnboardFirstPageState extends State<OnboardFirstPage>
    with TickerProviderStateMixin {
  AnimationController _movingController;
  Animation<Alignment> _movingAnimation;
  Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _movingController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _movingAnimation =
        Tween(begin: Alignment.centerLeft, end: Alignment.centerRight)
            .animate(CurvedAnimation(
      parent: _movingController,
      curve: Interval(.300, 1),
    ));
    _heightAnimation = Tween(begin: 200.0, end: 20.0).animate(CurvedAnimation(
      parent: _movingController,
      curve: Interval(.300, 1),
    ));
  }

  @override
  void dispose() {
    _movingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _movingController.forward();
    return AnimatedBuilder(
        animation: _movingController,
        builder: (context, _) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'The',
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 60,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 5,
                      ),
                    ),
                    Text(
                      'Wallet',
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 80,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 7,
                        height: .5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: _movingAnimation.value,
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/img/key.png'),
                ),
              ),
              SizedBox(
                height: _heightAnimation.value,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Free up your keychain from the membership cards',
                  style: TextStyle(
                    color: Colors.teal[300],
                    fontSize: 20,
                    // fontWeight: FontWeight.w700,
                    // letterSpacing: 1,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          );
        });
    ;
  }
}
