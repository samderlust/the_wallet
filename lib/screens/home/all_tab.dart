import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_wallet/bloc/code_bloc.dart';
import 'package:the_wallet/widgets/account_info_modal.dart';
import 'package:the_wallet/widgets/card_with_name.dart';
import 'package:vibration/vibration.dart';
import 'package:the_wallet/screens/card_detail.dart';

class AllTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final CodeBloc codeBloc = Provider.of<CodeBloc>(context);

    var theList = codeBloc.codeList;
    return GridView.builder(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      itemCount: theList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return CardWithName(
          theCard: theList[index],
        );
      },
    );
  }
}
