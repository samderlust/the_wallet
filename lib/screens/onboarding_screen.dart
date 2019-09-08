import 'package:flutter/material.dart';
import 'package:the_wallet/screens/home_screen.dart';
import 'package:the_wallet/screens/onboarding/first_page.dart';
import 'package:the_wallet/screens/onboarding/second_page.dart';
import 'package:the_wallet/screens/onboarding/third_page.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> bgSliding;
  Animation<double> opacityAnimation;
  Animation<double> radiusAnimation;

  PageController _pageController;
  int _currentPage = 0;
  List pageList = [
    OnboardFirstPage(),
    OnboardSecondPage(),
    OnboardThirdPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    opacityAnimation = Tween(begin: .0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.ease,
    ));
    radiusAnimation = Tween(begin: 300.0, end: 0.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
    bgSliding = Tween(begin: 70.0, end: 1000.0).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.25, 1),
    ));

    controller.addListener(() async {
      if (bgSliding.status == AnimationStatus.completed) {
        await Future.delayed(Duration(milliseconds: 100), controller.reverse);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    onTap() async {
      controller.forward();
      if (_currentPage < pageList.length - 1) {
        Future.delayed(Duration(milliseconds: 300), () {
          setState(() {
            _currentPage = _currentPage + 1;
          });
          _pageController.jumpToPage(_currentPage);
        });
      }
      if (_currentPage == pageList.length - 1) {
        Future.delayed(Duration(milliseconds: 300), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        });
      }
    }

    onTapPrevious() async {
      if (_currentPage == 0) return;
      controller.forward();
      if (_currentPage > 0) {
        Future.delayed(Duration(milliseconds: 300), () {
          setState(() {
            _currentPage = _currentPage - 1;
          });
          _pageController.jumpToPage(_currentPage);
        });
      }
    }

    return Scaffold(
      body: Stack(
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
            child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  // _pageController.animateToPage(
                  //   index,
                  //   duration: Duration(milliseconds: 500),
                  //   curve: Curves.linearToEaseOut,
                  // );
                },
                itemCount: pageList.length,
                controller: _pageController,
                itemBuilder: (context, index) {
                  print('build');
                  return pageList[index];
                }),
          ),
          Positioned(
            bottom: 40,
            left: 10,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () {
                  print('skip');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.teal[400],
                    fontSize: 18,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Positioned(
                bottom: bgSliding.value < 100 ? 40 : 0,
                right: bgSliding.value < 100 ? 10 : 0,
                child: Opacity(
                  opacity: opacityAnimation.value,
                  child: Container(
                    width: bgSliding.value,
                    height: bgSliding.value,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius:
                          BorderRadius.circular(radiusAnimation.value),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 50,
            right: 20,
            child: Row(
              children: <Widget>[
                _currentPage == 0
                    ? Container()
                    : GestureDetector(
                        onTap: onTapPrevious,
                        child: Container(
                          // color: Colors.teal,
                          child: Icon(
                            Icons.chevron_left,
                            color: Colors.teal,
                            size: 40,
                          ),
                        ),
                      ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    // color: Colors.teal,
                    child: Icon(
                      Icons.chevron_right,
                      color: Colors.teal,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
