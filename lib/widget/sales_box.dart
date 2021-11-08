import 'package:flutter/material.dart';
import 'package:flutter_trip2/model/home_model.dart';
import 'package:flutter_trip2/widget/cached_image.dart';

class SalesBox extends StatelessWidget {
  final SalesBoxModel? salesBox;

  const SalesBox({Key? key, this.salesBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: _items(context),
    );
  }

  Widget _items(BuildContext context) {
    List<Widget> items = [];
    if(salesBox == null) return Container();
    items.add(_doubleItem(
        context, salesBox!.bigCard1, salesBox!.bigCard2, true, false));
    items.add(_doubleItem(
        context, salesBox!.smallCard1, salesBox!.smallCard2, false, false));
    items.add(_doubleItem(
        context, salesBox!.smallCard3, salesBox!.smallCard4, false, true));
    return Column(
      children: [
        Container(
          height: 44,
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(width: 1, color: Color(0xfff2f2f2)),
          )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CachedImage(
                imageUrl: salesBox!.icon,
                height: 15,
                fit: BoxFit.fill,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(10, 1, 8, 1),
                  margin: EdgeInsets.only(right: 7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                          colors: [
                            Color(0xffff4e63),
                            Color(0xffff6cc9),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)),
                  child: GestureDetector(
                    onTap: () {
                      //todo
                    },
                    child: Text(
                      '获取更多福利 >',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ))
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(0, 1),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(1, 2),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(2, 3),
        )
      ],
    );
  }

  Widget _doubleItem(BuildContext context, CommonModel leftCard,
      CommonModel rightCard, bool isBig, bool isLast) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _item(context, leftCard, isBig, true, isLast),
        _item(context, rightCard, isBig, false, isLast),
      ],
    );
  }

  //isBig 是否是大图，isLeft 是否是靠左边，如果不是则需要跟左边留有边界 isBottom 是否是最底部，不是的话是需要留间距的
  Widget _item(BuildContext context, CommonModel model, bool isBig, bool isLeft,
      bool isBottom) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Color(0xfff2f2f2));

    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                right: isLeft ? borderSide : BorderSide.none,
                bottom: isBottom ? BorderSide.none : borderSide)),
        child: CachedImage(
            imageUrl: model.icon,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width / 2 -
                8, //宽度为屏幕的一半，高度根据是否大图动态设定
            height: isBig ? 129 : 80),
      ),
    );
  }
}
