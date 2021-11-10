import 'package:flutter/material.dart';
import 'package:flutter_trip2/dao/home_dao.dart';
import 'package:flutter_trip2/model/home_model.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:flutter_trip2/pages/city_page.dart';
import 'package:flutter_trip2/utils/navigation_util.dart';
import 'package:flutter_trip2/widget/cached_image.dart';
import 'package:flutter_trip2/widget/grid_nav.dart';
import 'package:flutter_trip2/widget/loading_container.dart';
import 'package:flutter_trip2/widget/local_nav.dart';
import 'package:flutter_trip2/widget/sales_box.dart';
import 'package:flutter_trip2/widget/search_bar.dart';
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
  const HomePage({Key? key}) : super(key: key);

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
        backgroundColor: const Color(0xfff2f2f2),
        body: LoadingContainer(
          isLoading: _loading,
          child: Stack(
            children: [
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: NotificationListener(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollUpdateNotification &&
                          scrollNotification.depth == 0) {
                        //滚动并且是列表滚动的时候
                        _onScroll(scrollNotification.metrics.pixels);
                      }
                      return false;
                    },
                    child: _listView,
                  ),
                ),
              ),
              _appBar
            ],
          ),
        ));
  }

  /// 自定义appBar
  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80,
            decoration: BoxDecoration(
                color:
                    Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255)),
            child: SearchBar(
              city: city,
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: _jumpToCity,
              rightButtonClick: () {},
              onChanged: (String value) {},
            ),
          ),
        ),
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 0.5),
            ],
          ),
        )
      ],
    );
  }

  /// 判断滚动改变透明度
  void _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  /// 跳转搜索页面
  void _jumpToSearch() {
    //todo
  }

  /// 跳转语音识别页面
  void _jumpToSpeak() {
    //todo
  }

  /// 跳转到城市列表
  void _jumpToCity() async {
    String result = await NavigationUtil.push(context, CityPage(city: city));
    setState(() {
      city = result;
    });
  }

  //Swiper 用法：https://pub.dev/packages/flutter_swiper
  Widget get _banner {
    return SizedBox(
      height: 160,
      child: Swiper(
        autoplay: true,
        loop: true,
        pagination: const SwiperPagination(),
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
            padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
            child: LocalNav(localNavList: localNavList)),
        /*网格卡片*/
        Padding(
            padding: const EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: GridNav(gridNavModel: gridNav)),
        /*活动导航*/
        Padding(
            padding: const EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: SubNav(subNavList: subNavList)),
        /*底部卡片*/
        Padding(
            padding: const EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: SalesBox(salesBox: salesBox))
      ],
    );
  }
}
