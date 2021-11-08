import 'package:flutter/material.dart';
import 'package:flutter_trip2/dao/home_dao.dart';
import 'package:flutter_trip2/model/home_model.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:flutter_trip2/widget/cached_image.dart';
import 'package:flutter_trip2/widget/grid_nav.dart';
import 'package:flutter_trip2/widget/local_nav.dart';
import 'package:flutter_trip2/widget/sales_box.dart';
import 'package:flutter_trip2/widget/sub_nav.dart';

//home 首页
// class HomePage extends StatefulWidget {
//   HomePage({Key? key}) : super(key: key);
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   void initState() {
//     print("HomePage initState...");
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("首页")),
//       body: Center(child: Text("首页")),
//     );
//   }
// }

const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  double appBarAlpha = 0; // appBar 的透明度

  List<CommonModel> bannerList = []; // 轮播图列表

  List<CommonModel> localNavList = []; // local导航

  GridNavModel? gridNav; // 网格卡片

  List<CommonModel> subNavList = []; // 活动导航

  SalesBoxModel? salesBox; // salesBox数据

  bool _loading = true; // 页面加载状态

  String city = '西安市';

  // 加载首页数据
  Future _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        bannerList = model.bannerList;
        localNavList = model.localNavList;
        gridNav = model.gridNav;
        subNavList = model.subNavList;
        salesBox = model.salesBox;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    print("HomePage initState...");
    _handleRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: _listView,
      ),
    );
  }

  // 自定义appBar
  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80,
            decoration: BoxDecoration(
                color:
                    Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255)),
          ),
        ),
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 0.5),
            ],
          ),
        )
      ],
    );
  }

  //Swiper 用法：https://pub.dev/packages/flutter_swiper
  Widget get _banner {
    return Container(
      height: 160,
      child: Swiper(
        autoplay: true,
        loop: true,
        pagination: SwiperPagination(),
        itemCount: bannerList.length,
        itemBuilder: (BuildContext context, int index) {
          return CachedImage(
              imageUrl: bannerList[index].icon, fit: BoxFit.fill);
        },
        onTap: (index) {
          //
        },
      ),
    );
  }

  Widget get _listView {
    return ListView(
      children: [
        _banner,
        /* LOCAL 导航*/
        Padding(
            padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
            child: LocalNav(localNavList: localNavList)),
        /*网格卡片*/
        Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: GridNav(gridNavModel: gridNav)),
        /*活动导航*/
        Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: SubNav(subNavList: subNavList)),
        /*底部卡片*/
        Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: SalesBox(salesBox: salesBox))
      ],
    );
  }
}
