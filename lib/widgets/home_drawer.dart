import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_wallet/bloc/account_bloc.dart';
import 'package:the_wallet/bloc/code_bloc.dart';
import 'package:the_wallet/bloc/recent_bloc.dart';
import 'package:the_wallet/screens/onboarding_screen.dart';
import 'package:the_wallet/screens/route_names.dart';
import 'package:the_wallet/widgets/account_info_modal.dart';
import 'package:the_wallet/widgets/popup_comfirm.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CodeBloc codeBloc = Provider.of<CodeBloc>(context);
    final RecentBloc recentBloc = Provider.of<RecentBloc>(context);
    final AccountBloc accountBloc = Provider.of<AccountBloc>(context);
    return Drawer(
      child: Column(
        // padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Your wallet',
                  style: TextStyle(color: Colors.white, letterSpacing: 2),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      accountBloc.userName,
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    Spacer(),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black12,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          accountBloc.userName == ''
                              ? ''
                              : accountBloc.userName[0],
                          style: TextStyle(color: Colors.white, fontSize: 60),
                        ),
                      ),
                    )
                  ],
                ),
                Spacer(),
                Text(
                  'version: 1.0.0',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                ListTile(
                    title: Text(
                      'Guide',
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 20,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, RouteNames.GUIDE_SCREEN);
                    }),
                Divider(
                  color: Colors.black12,
                  height: 1,
                ),
                ListTile(
                  title: Text(
                    'Acount info',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) => AccountInfoModal()),
                ),
                Divider(
                  color: Colors.black12,
                  height: 1,
                ),
                ListTile(
                  title: Text(
                    'Clear Recent',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () => showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return PopupComfirm(
                          title: "Remove recent list?",
                          subTitle: "Remove list of recently used card",
                          onCancel: () => Navigator.of(context).pop(),
                          onDelete: () {
                            recentBloc.clearRecentList();
                            Navigator.of(context).pop();
                          },
                        );
                      }),
                ),
                Divider(
                  color: Colors.black12,
                  height: 1,
                ),
                ListTile(
                  title: Text(
                    'Clear Wallet',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return PopupComfirm(
                            title: "Remove Data?",
                            subTitle:
                                "All data will be remove and can't be recovered!",
                            onCancel: () => Navigator.of(context).pop(),
                            onDelete: () {
                              codeBloc.clearWallet();
                              recentBloc.clearRecentList();
                              Navigator.of(context).pop();
                            },
                          );
                        });
                  },
                ),
                Divider(
                  color: Colors.black12,
                  height: 1,
                ),
                ListTile(
                  title: Text(
                    'About',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: "The wallet",
                    applicationVersion: '1.0.0',
                    children: <Widget>[
                      Text("Author: Samderlust"),
                      Text("Contact: Samderlust@gmail.com"),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black12,
                  height: 1,
                ),
                Spacer(),
                ListTile(
                  title: Text(
                    'Close Drawer',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
