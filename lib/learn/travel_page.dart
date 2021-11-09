import 'package:flutter/material.dart';
import 'package:flutter_trip2/dao/travel_tab_dao.dart';
import 'package:flutter_trip2/learn/travel_item_page.dart';
import 'package:flutter_trip2/model/travel_tab_model.dart';

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

///旅拍主界面
class TravelPage extends StatefulWidget {
  TravelPage({Key? key}) : super(key: key);

  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage>
    with TickerProviderStateMixin {
  // List<String> tabs = ["推荐", "附近", "热门", "旅行热点", "露营初体验", "酒店民宿",
  //   "美食探店", "亲子", "小众", "自驾", "网红", "逛展"];

  List<TravelTab> tabs = [];
  TravelTabModel? travelTabModel;

  late TabController _controller;

  @override
  void initState() {
    print("TravelPage initState...");
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 30),
            child: TabBar(
                controller: _controller,
                isScrollable: true,
                labelColor: Colors.black,
                labelPadding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(color: Color(0xff1fcfbb), width: 3),
                  insets: EdgeInsets.only(bottom: 10),
                ),
                tabs: tabs.map<Tab>((TravelTab tab) {
                  return Tab(text: tab.labelName);
                }).toList()),
          ),
          Flexible(//充满整个剩余的可用空间
              child: TabBarView(
            controller: _controller,
            children: tabs.map<TravelItemPage>((TravelTab tab) {
              return TravelItemPage(
                travelUrl: travelTabModel!.url,
                params: travelTabModel!.params,
                groupChannelCode: tab.groupChannelCode,
                type: tab.type,
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

  //初始化tab数据
  void _loadData() async {
    try {
      TravelTabModel model = await TravelTabDao.fetch();
      _controller = TabController(
          length: model.tabs.length, vsync: this);
      setState(() {
        tabs = model.tabs;
        travelTabModel = model;
      });
    } catch (e) {
      print(e);
    }
  }
}
