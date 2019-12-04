import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanandroid_flutter/models/app_theme.dart';
import 'package:wanandroid_flutter/pages/about_page.dart';
import 'package:wanandroid_flutter/pages/login_page.dart';
import 'package:wanandroid_flutter/res/colors.dart';
import 'package:wanandroid_flutter/widgets/gradient_appbar.dart';
import 'package:wanandroid_flutter/widgets/item_creator.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  double screenWidth = 0;
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: GradientAppBar(
        title: Text("设置"),
        colors: [
          Colours.appThemeColor,
          Color(0xfffa5650),
        ],
      ),
      body: Column(
        children: <Widget>[
          ItemCreator.createItem(
            context,
            Icons.brightness_6,
            "夜间模式",
            () {},
            margin: EdgeInsets.only(
              top: 20,
            ),
            right: Switch(
                activeColor: Colours.appThemeColor,
                inactiveTrackColor: Theme.of(context).scaffoldBackgroundColor,
                value: Provider.of<AppTheme>(context).isDark,
                onChanged: (value) {
                  setState(() {
                    Provider.of<AppTheme>(context).setIsDark =
                        !Provider.of<AppTheme>(context).isDark;
                  });
                }),
            hasDivider: false,
          ),
          ItemCreator.createItem(
            context,
            Icons.delete_forever,
            "清除缓存",
            () {},
            margin: EdgeInsets.only(
              top: 20,
            ),
            showMore: false,
            hasDivider: true,
          ),
          ItemCreator.createItem(
            context,
            Icons.language,
            "语言设置",
            () {},
            hasDivider: true,
            right: Text(
              "中文",
              style: TextStyle(fontSize: 16),
            ),
          ),
          ItemCreator.createItem(
            context,
            Icons.account_box,
            "关于",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return AboutPage();
                  },
                ),
              );
            },
          ),
          Container(
            margin: EdgeInsets.only(
              top: 40,
              bottom: 40,
            ),
            child: MaterialButton(
              elevation: 0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return LoginPage();
                    },
                  ),
                );
              },
              textColor: Colors.red,
              child: Text(
                "退出登录",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.redAccent,
                ),
              ),
              minWidth: screenWidth,
              height: 52,
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }
}