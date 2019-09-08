import 'package:flutter/material.dart';
import 'package:the_wallet/bloc/account_bloc.dart';
import 'package:the_wallet/screens/onboarding_screen.dart';
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
        home: OnboardingScreen(),
        // HomeScreen(),
      ),
    );
  }
}
