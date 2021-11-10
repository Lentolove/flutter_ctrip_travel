import 'package:flutter/material.dart';
import 'package:flutter_trip2/model/home_model.dart';
import 'package:flutter_trip2/pages/web_view.dart';
import 'package:flutter_trip2/utils/navigation_util.dart';
import 'package:flutter_trip2/widget/cached_image.dart';

class SubNav extends StatelessWidget {
  final List<CommonModel> subNavList;

  const SubNav({Key? key, required this.subNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(6)),
      child: Padding(padding: const EdgeInsets.all(7), child: _items(context)),
    );
  }

  Widget _items(BuildContext context) {
    List<Widget> items = [];
    for (var value in subNavList) {
      items.add(_item(context, value));
    }
    //计算一行显示的数量
    int separate = (subNavList.length / 2 + 0.5).toInt();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(0, separate),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: items.sublist(separate, subNavList.length)),
        )
      ],
    );
  }

  Widget _item(BuildContext context, CommonModel model) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          NavigatorUtil.push(
            context,
            WebViewDiy(
              initialUrl: model.url,
              statusBarColor: model.statusBarColor,
              hideAppBar: model.hideAppBar,
              title: model.title,
            ),
          );
        },
        child: Column(
          children: [
            CachedImage(
              imageUrl: model.icon,
              width: 18,
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                model.title ?? '',
                style: const TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
