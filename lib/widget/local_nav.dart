import 'package:flutter/material.dart';
import 'package:flutter_trip2/model/home_model.dart';
import 'package:flutter_trip2/widget/cached_image.dart';

class LocalNav extends StatelessWidget {
  final List<CommonModel> localNavList;

  const LocalNav({Key? key, required this.localNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(6)),
      child: Padding(padding: EdgeInsets.all(7), child: _items(context)),
    );
  }

  //横着一排 item
  Widget _items(BuildContext context) {
    List<Widget> items = [];
    localNavList.forEach((element) {
      items.add(_item(context, element));
    });
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: items);
  }

  //创建单个 item,上面是图片，下面是文字
  Widget _item(BuildContext context, CommonModel model) {
    return GestureDetector(
        child: Column(children: [
          CachedImage(imageUrl: model.icon, width: 32, height: 32),
          Text(model.title ?? '', style: TextStyle(fontSize: 12))
        ]),
        onTap: () {
          //todo
        });
  }
}
