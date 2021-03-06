import 'package:flutter/material.dart';
import 'package:flutter_trip2/model/home_model.dart';
import 'package:flutter_trip2/pages/web_view.dart';
import 'package:flutter_trip2/utils/navigation_util.dart';
import 'package:flutter_trip2/widget/cached_image.dart';

class SalesBox extends StatelessWidget {
  final SalesBoxModel? salesBox;

  const SalesBox({Key? key, this.salesBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: _items(context),
    );
  }

  Widget _items(BuildContext context) {
    List<Widget> items = [];
    if (salesBox == null) return Container();
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
          margin: const EdgeInsets.only(left: 10),
          decoration: const BoxDecoration(
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
                  padding: const EdgeInsets.fromLTRB(10, 1, 8, 1),
                  margin: const EdgeInsets.only(right: 7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                          colors: [
                            Color(0xffff4e63),
                            Color(0xffff6cc9),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)),
                  child: GestureDetector(
                    onTap: () {
                      NavigatorUtil.push(
                        context,
                        WebViewDiy(
                          initialUrl: salesBox!.moreUrl,
                          title: '????????????',
                        ),
                      );
                    },
                    child: const Text(
                      '?????????????????? >',
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

  //isBig ??????????????????isLeft ??????????????????????????????????????????????????????????????? isBottom ??????????????????????????????????????????????????????
  Widget _item(BuildContext context, CommonModel model, bool isBig, bool isLeft,
      bool isBottom) {
    BorderSide borderSide = const BorderSide(width: 0.8, color: Color(0xfff2f2f2));
    return GestureDetector(
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
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                right: isLeft ? borderSide : BorderSide.none,
                bottom: isBottom ? BorderSide.none : borderSide)),
        child: CachedImage(
            imageUrl: model.icon,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width / 2 -
                8, //???????????????????????????????????????????????????????????????
            height: isBig ? 129 : 80),
      ),
    );
  }
}
