// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_trip2/pages/web_view.dart';

/// 我的首页 直接显示h5界面
class MyPage extends StatefulWidget {
  MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    print("MyPage initState...");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewDiy(
        initialUrl: 'https://m.ctrip.com/webapp/myctrip/',
        hideAppBar: true,
        backForbid: true,
        statusBarColor: '4c5bca',
      ),
    );
  }
}
