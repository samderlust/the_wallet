import 'package:flutter/material.dart';
import 'package:the_wallet/bloc/account_bloc.dart';
import 'package:the_wallet/screens/onboarding_screen.dart';
import 'package:the_wallet/screens/route_names.dart';
import 'package:the_wallet/screens/search_screen.dart';
import './screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'bloc/code_bloc.dart';

import 'bloc/recent_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CodeBloc>.value(
          value: CodeBloc(),
        ),
        ChangeNotifierProvider<RecentBloc>.value(
          value: RecentBloc(),
        ),
        ChangeNotifierProvider<AccountBloc>.value(
          value: AccountBloc(),
        )
      ],
      child: MaterialApp(
        title: 'The Wallet',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          fontFamily: 'rokkitt',
          textTheme: TextTheme(
            body1: TextStyle(fontSize: 16),
          ),
        ),
        // home: OnboardingScreen(),
        onGenerateRoute: routes,
        // HomeScreen(),
      ),
    );
  }
}

Route routes(RouteSettings settings) {
  switch (settings.name) {
    case RouteNames.HOME:
      return MaterialPageRoute(
        builder: (context) {
          final CodeBloc codeBloc = Provider.of<CodeBloc>(context);
          final RecentBloc recentBloc = Provider.of<RecentBloc>(context);
          final AccountBloc accountBloc = Provider.of<AccountBloc>(context);
          recentBloc.getRecentListFromStorage();
          codeBloc.getAllCard();
          accountBloc.getTotalCardNo();
          accountBloc.getUserName();

          return FutureBuilder<Object>(
              future: accountBloc.checkIfFistTime(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (!snapshot.data)
                    return HomeScreen();
                  else
                    return OnboardingScreen();
                }
                return Container();
              });
        },
      );
    case RouteNames.SEARCH:
      return MaterialPageRoute(builder: (context) => SeacrchScreen());
    case RouteNames.GUIDE_SCREEN:
      return MaterialPageRoute(builder: (c) => OnboardingScreen());
  }
}
