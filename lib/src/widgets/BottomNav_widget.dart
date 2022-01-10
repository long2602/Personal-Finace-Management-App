import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loda_app/src/constants/app_style.dart';

class BottomNav extends StatelessWidget {
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
                        onPressed: () {},
                        icon: FaIcon(
                          FontAwesomeIcons.home,
                          color: AppStyle.blueColor,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: FaIcon(FontAwesomeIcons.wallet)),
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
                        onPressed: () {},
                        icon: FaIcon(FontAwesomeIcons.solidChartBar)),
                    IconButton(
                        onPressed: () {}, icon: FaIcon(FontAwesomeIcons.cog)),
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
