import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_wallet/bloc/code_bloc.dart';
import 'package:the_wallet/bloc/recent_bloc.dart';
import 'package:the_wallet/model/CardModel.dart';
import 'package:the_wallet/widgets/single_card.dart';
import 'package:the_wallet/widgets/tag_container.dart';

class RecentTab extends StatefulWidget {
  @override
  _RecentTabState createState() => _RecentTabState();
}

class _RecentTabState extends State<RecentTab> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final RecentBloc recentBloc = Provider.of<RecentBloc>(context);
    var cardList = recentBloc.recentCards;
    return ListView.builder(
      itemCount: cardList.length,
      itemBuilder: (context, index) {
        CardModel theCard = cardList[index];
        return SingleCard(
          theCard: theCard,
        );
      },
    );
  }
}
