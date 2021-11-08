import 'package:flutter/material.dart';

//旅拍
// class TravelPage extends StatefulWidget {
//   TravelPage({Key? key}) : super(key: key);
//
//   @override
//   _TravelPageState createState() => _TravelPageState();
// }
//
// class _TravelPageState extends State<TravelPage> with AutomaticKeepAliveClientMixin{
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   void initState() {
//     print("TravelPage initState...");
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("旅拍")),
//       body: Center(
//         child: Text("旅拍"),
//       ),
//     );
//   }
// }

//旅拍
class TravelPage extends StatefulWidget {
  TravelPage({Key? key}) : super(key: key);

  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage>
    with SingleTickerProviderStateMixin {
  List<String> tabs = ["推荐", "附近", "热门", "旅行热点", "露营初体验", "酒店民宿",
    "美食探店", "亲子", "小众", "自驾", "网红", "逛展"];

  late TabController _controller;

  @override
  void initState() {
    print("TravelPage initState...");
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 30),
            child: TabBar(
                controller: _controller,
                isScrollable: true,
                labelColor: Colors.black,
                labelPadding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Color(0xff1fcfbb), width: 3),
                  insets: EdgeInsets.only(bottom: 10),
                ),
                tabs: tabs.map<Tab>((String e) {
                  return Tab(text: e);
                }).toList()),
          ),
          Flexible(
              child: TabBarView(
            controller: _controller,
            children: tabs.map<Container>((String e) {
              return Container(
                child: Center(
                  child: Text(e, textScaleFactor: 5),
                ),
              );
            }).toList(),
          ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
