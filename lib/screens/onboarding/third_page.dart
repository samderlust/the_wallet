import 'package:flutter/material.dart';
import 'package:barcode_flutter/barcode_flutter.dart';

class OnboardThirdPage extends StatefulWidget {
  @override
  _OnboardThirdPageState createState() => _OnboardThirdPageState();
}

class _OnboardThirdPageState extends State<OnboardThirdPage>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> barcodes = [
    {"index": 6, "code": 'code-128'},
    {"index": 3, "code": 'code-93'},
    {"index": 2, "code": 'code-39'},
  ];

  AnimationController _controller;
  Animation<int> _movingIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    _movingIndex = IntTween(begin: 0, end: 2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    _controller.repeat();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        int _i = _movingIndex.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text(
              'Choose the right formart for your card!',
              style: TextStyle(
                color: Colors.teal,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Column(
              children: barcodes
                  .map((code) => Container(
                        margin: EdgeInsets.all(5),
                        width: width * .6,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(
                              barcodes[_i]["index"] == code["index"] ? 1 : .3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            code['code'],
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(height: 20),
            Container(
              height: 120,
              // color: Colors.white,
              child: Column(
                children: <Widget>[
                  BarCodeImage(
                    data: '123456',
                    codeType: BarCodeType.values[barcodes[_i]['index']],
                    lineWidth: 2.0,
                    barHeight: 85.0,
                    // hasText: true,
                    onError: (error) {
                      print('error = $error');
                    },
                  ),
                  Text(
                    "123456",
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "The right format will help your barcode can be read by the oganization's scanner",
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}
