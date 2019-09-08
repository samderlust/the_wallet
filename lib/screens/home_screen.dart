import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:provider/provider.dart';
import 'package:the_wallet/bloc/account_bloc.dart';
import 'package:the_wallet/screens/home/all_tab.dart';
import 'package:the_wallet/screens/home/recent_tab.dart';
import 'package:the_wallet/widgets/home_drawer.dart';
import '../model/CardModel.dart';

import '../bloc/code_bloc.dart';
import '../bloc/recent_bloc.dart';
import '../widgets/tag_container.dart';
import './new_card.dart';
import './search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String invalidCode = '';
  PageController _pageController;
  FocusNode _focus = FocusNode();
  final GlobalKey<ScaffoldState> _homeScaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _selectedIndex,
    );

    _focus.addListener(() {
      if (_focus.hasFocus) {
        _focus.unfocus();
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => SeacrchScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final CodeBloc codeBloc = Provider.of<CodeBloc>(context);
    final RecentBloc recentBloc = Provider.of<RecentBloc>(context);
    final AccountBloc accountBloc = Provider.of<AccountBloc>(context);

    recentBloc.getRecentListFromStorage();
    accountBloc.getTotalCardNo();
    accountBloc.getUserName();

    List<Widget> tabList = [
      AnimatedOpacity(
        opacity: _selectedIndex == 0 ? 1 : 0,
        duration: Duration(
          milliseconds: 300,
        ),
        child: RecentTab(
          recentBloc: recentBloc,
        ),
      ),
      AnimatedOpacity(
        opacity: _selectedIndex == 1 ? 1 : 0,
        duration: Duration(
          milliseconds: 300,
        ),
        child: AllTab(codeBloc: codeBloc),
      )
    ];

    _animateToPage(index) {
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.linearToEaseOut,
      );
    }

    return Scaffold(
      key: _homeScaffold,
      drawer: HomeDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_circle_outline,
        ),
        onPressed: () async {
          try {
            String code = await BarcodeScanner.scan();
            codeBloc.update(code);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewCard(
                          code: code,
                        )));
          } catch (e) {
            print(e);
            Navigator.pop(context);
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // _pageController.jumpToPage(index);
          _animateToPage(index);
        },
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.restore,
              ),
              title: Text('Recent')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_balance_wallet,
              ),
              title: Text('All')),
        ],
      ),
      resizeToAvoidBottomInset: false,
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
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: width,
              height: height * 3,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.menu),
                        onPressed: () =>
                            _homeScaffold.currentState.openDrawer(),
                        color: Colors.white,
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black12,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Center(
                          child: Text(
                            accountBloc.userName == ''
                                ? ""
                                : accountBloc.userName[0],
                            style: TextStyle(color: Colors.white, fontSize: 40),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 45,
                    child: Hero(
                      tag: 'searchTextField',
                      child: Material(
                        color: Colors.transparent,
                        child: CupertinoTextField(
                          focusNode: _focus,
                          autocorrect: false,
                          autofocus: false,
                          suffix: IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Color(0xFF116F66),
                            ),
                            onPressed: () {},
                          ),
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
                    height: 10,
                  ),
                  FutureBuilder(
                    future: recentBloc.getRecentListFromStorage(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List<CardModel> theList = snapshot.data;
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: theList
                                .map((card) => TagContainer(
                                      card: card,
                                    ))
                                .toList());
                      } else
                        return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        color: Colors.black12,
                        offset: Offset(0, -10)),
                  ]),
              width: width,
              height: height * .65,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: PageView.builder(
                itemCount: tabList.length,
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                  _animateToPage(index);
                },
                itemBuilder: (context, index) {
                  // print('home buld $index');
                  return tabList[index];
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
