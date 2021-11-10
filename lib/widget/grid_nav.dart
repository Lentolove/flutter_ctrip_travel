import 'package:flutter/material.dart';
import 'package:flutter_trip2/model/home_model.dart';
import 'package:flutter_trip2/pages/web_view.dart';
import 'package:flutter_trip2/utils/navigation_util.dart';
import 'package:flutter_trip2/widget/cached_image.dart';

//网格布局，包括三行
class GridNav extends StatelessWidget {
  final GridNavModel? gridNavModel;

  const GridNav({Key? key, required this.gridNavModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: _gridNavItems(context),
      ),
    );
  }

  List<Widget> _gridNavItems(BuildContext context) {
    List<Widget> items = [];
    if (gridNavModel?.hotel != null) {
      items.add(_gridNavItem(context, gridNavModel!.hotel, true));
    }
    if (gridNavModel?.flight != null) {
      items.add(_gridNavItem(context, gridNavModel!.flight, false));
    }
    if (gridNavModel?.travel != null) {
      items.add(_gridNavItem(context, gridNavModel!.travel, false));
    }
    return items;
  }

  ///每一层由左边的一个 _mainItem + _doubleItem + _doubleItem 构成一个条目
  Widget _gridNavItem(
      BuildContext context, GridNavItem gridNavItem, bool first) {
    List items = [];
    List<Widget> expandItems = [];
    //用于设置渐变色的其实颜色 和 终止颜色
    Color startColor = Color(int.parse('0xff${gridNavItem.startColor}'));
    Color endColor = Color(int.parse('0xff${gridNavItem.endColor}'));
    items.add(_mainItem(context, gridNavItem.mainItem));
    items.add(_doubleItem(context, gridNavItem.item1, gridNavItem.item2));
    items.add(_doubleItem(context, gridNavItem.item3, gridNavItem.item4));
    for (var element in items) {
      expandItems.add(Expanded(
        child: element,
        flex: 1,
      ));
    }
    return Container(
      height: 88,
      margin: first ? null : EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        //设置渐变色
        gradient: LinearGradient(
          colors: [startColor, endColor],
        ),
      ),
      child: Row(
        children: expandItems,
      ),
    );
  }

  ///左侧的大图标，背景图 + 文字,采用 Stack 布局，文字在图片的上方
  Widget _mainItem(BuildContext context, CommonModel model) {
    return _wrapGesture(
        context,
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            ///是对 CachedNetworkImage 一个封装的图片控件
            CachedImage(
              imageUrl: model.icon,
              fit: BoxFit.contain,
              height: 88,
              width: 121,
              alignment: Alignment.bottomCenter,
            ),
            Container(
              margin: EdgeInsets.only(top: 11),
              child: Text(
                model.title ?? '',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            )
          ],
        ),
        model);
  }

  ///上下布局的两个条目，如果是上方的话就需要与底部有一个间距，即 模块 2 中。用  Expanded 去包裹每个条目，会填充剩余空间使其充满
  Widget _doubleItem(
      BuildContext context, CommonModel topModel, CommonModel bottomModel) {
    return Column(
      children: [
        Expanded(child: _item(context, topModel, true)),
        Expanded(child: _item(context, bottomModel, false))
      ],
    );
  }

  ///如果是位于上方，则需要设置一个底部间距
  Widget _item(BuildContext context, CommonModel model, bool isFirst) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);

    ///FractionallySizedBox 是一个相对父组件尺寸的组件，比如占用的宽高比例等
    return FractionallySizedBox(
        //撑满剩余宽度
        widthFactor: 1,
        child: Container(
          decoration: BoxDecoration(
              border: Border(

                  ///如果是上面的第一个，底部需要留一点间距
                  left: borderSide,
                  bottom: isFirst ? borderSide : BorderSide.none)),
          child: _wrapGesture(
              context,
              Center(
                child: Text(
                  model.title ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              model),
        ));
  }

  ///封装一个手势Widget
  Widget _wrapGesture(BuildContext context, Widget widget, CommonModel model) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
            context,
            WebViewDiy(
              initialUrl: model.url,
              statusBarColor: model.statusBarColor,
              hideAppBar: model.hideAppBar,
              title: model.title,
            ));
      },
      child: widget,
    );
  }
}
