import 'package:flutter/material.dart';

class OnboardSecondPage extends StatefulWidget {
  @override
  _OnboardSecondPageState createState() => _OnboardSecondPageState();
}

class _OnboardSecondPageState extends State<OnboardSecondPage>
    with TickerProviderStateMixin {
  AnimationController _blinkController;
  Animation<double> _opacityAnimation;
  AnimationController _movingController;
  Animation<double> _movingAnimation;
  Animation<double> _heightAnimation;
  Animation<double> _fontSizeAnimation;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _opacityAnimation = Tween(begin: .4, end: 1.0).animate(
        CurvedAnimation(parent: _blinkController, curve: Curves.bounceIn));

    _movingController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _fontSizeAnimation = Tween(begin: 20.0, end: 22.0).animate(
        CurvedAnimation(parent: _movingController, curve: Interval(.800, 1)));
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _movingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    if (_movingAnimation == null) {
      _movingAnimation = Tween(begin: height * .4, end: height * .7).animate(
          CurvedAnimation(
              parent: _movingController, curve: Interval(.300, 0.600)));
    }
    if (_heightAnimation == null) {
      _heightAnimation = Tween(begin: 60.0, end: height * .25).animate(
          CurvedAnimation(parent: _movingController, curve: Interval(.600, 1)));
    }

    setState(() {
      _movingController.forward();
    });
    return Stack(
      children: <Widget>[
        AnimatedBuilder(
          animation: _movingController,
          builder: (context, child) {
            return Positioned(
              top: _movingAnimation.value,
              child: Container(
                width: width,
                height: _heightAnimation.value,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(.7),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Add button to add new card',
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: _fontSizeAnimation.value,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 30,
          left: width / 2 - 30,
          child: Center(
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
