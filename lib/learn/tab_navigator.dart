import 'package:flutter/material.dart';
import 'package:flutter_trip2/learn/home_page.dart';
import 'package:flutter_trip2/learn/my_page.dart';
import 'package:flutter_trip2/learn/search_page.dart';
import 'package:flutter_trip2/learn/travel_page.dart';

//底部导航栏
class TabNavigator extends StatefulWidget {
  const TabNavigator({Key? key}) : super(key: key);

  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final PageController _controller = PageController(initialPage: 0); //定义页面控制器

  final Color _defaultColor = Colors.grey; // 默认颜色

  final Color _activeColor = Colors.blue; // 激活态颜色

  int _currentIndex = 0; // 当前索引

  @override
  void initState() {
    print("TabNavigator initState...");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          children: [HomePage(), SearchPage(), TravelPage(), MyPage()]),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: TextStyle(color: _activeColor),
        unselectedLabelStyle: TextStyle(color: _defaultColor),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          _controller.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          _bottomItem(Icons.home, '首页'),
          _bottomItem(Icons.search, '搜索'),
          _bottomItem(Icons.camera_alt, '旅拍'),
          _bottomItem(Icons.account_circle, '我的')
        ],
      ),
    );
  }

  //构建底部导航栏 item
  BottomNavigationBarItem _bottomItem(IconData icon, String label) {
    return BottomNavigationBarItem(
        icon: Icon(icon, color: _defaultColor),
        activeIcon: Icon(icon, color: _activeColor),
        label: label);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
