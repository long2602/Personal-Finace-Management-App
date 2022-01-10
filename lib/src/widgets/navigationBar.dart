// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loda_app/src/blocs/tab_bloc.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/events/tab_event.dart';
import 'package:loda_app/src/states/tab_state.dart';

class Navigationbar extends StatelessWidget {
  TabState selectedTab;
  Navigationbar({
    Key? key,
    required TabState tab,
  })  : selectedTab = tab,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppStyle.backgroundColor,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 73,
                width: MediaQuery.of(context).size.width / 2 - 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          BlocProvider.of<TabBloc>(context)
                              .add(TabEventChangeHomeTab());
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.home,
                          color: selectedTab is TabHomeState
                              ? AppStyle.blueColor
                              : AppStyle.textColor,
                        )),
                    IconButton(
                        onPressed: () {
                          BlocProvider.of<TabBloc>(context)
                              .add(TabEventChangeWalletTab());
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.wallet,
                          color: selectedTab is TabWalletState
                              ? AppStyle.blueColor
                              : AppStyle.textColor,
                        )),
                  ],
                ),
              ),
              Container(
                height: 73,
                width: MediaQuery.of(context).size.width / 2 - 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          BlocProvider.of<TabBloc>(context)
                              .add(TabEventChangeStatisticTab());
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.solidChartBar,
                          color: selectedTab is TabStatisticState
                              ? AppStyle.blueColor
                              : AppStyle.textColor,
                        )),
                    IconButton(
                        onPressed: () {
                          BlocProvider.of<TabBloc>(context)
                              .add(TabEventChangeSettingTab());
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.cog,
                          color: selectedTab is TabSettingState
                              ? AppStyle.blueColor
                              : AppStyle.textColor,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
