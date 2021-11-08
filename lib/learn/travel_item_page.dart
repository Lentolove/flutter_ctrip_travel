import 'package:flutter/material.dart';
import 'package:flutter_trip2/dao/travel_dao.dart';
import 'package:flutter_trip2/model/travel_model.dart';
import 'package:flutter_trip2/widget/cached_image.dart';
import 'package:flutter_trip2/widget/loading_container.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

const TRAVEL_URL =
    'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';
const PAGE_SIZE = 10;

/// 旅拍视图展示界面 body 部分,瀑布流式布局
class TravelItemPage extends StatefulWidget {
  final String travelUrl;
  final Map params;
  final String groupChannelCode;
  final int type;

  const TravelItemPage(
      {Key? key,
      required this.travelUrl,
      required this.params,
      required this.groupChannelCode,
      required this.type})
      : super(key: key);

  @override
  _TravelItemPageState createState() => _TravelItemPageState();
}

class _TravelItemPageState extends State<TravelItemPage>
    with AutomaticKeepAliveClientMixin {
  //数据列表
  List<TravelItem> travelItems = [];

  //分页索引
  int pageIndex = 1;

  //是否正在加载
  bool _loading = true;

  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingContainer(
        isLoading: _loading,
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: MediaQuery.removePadding(
            context: context,
            child: StaggeredGridView.countBuilder(
                controller: _scrollController,
                itemCount: travelItems.length,
                crossAxisCount: 2,
                itemBuilder: (BuildContext context, int index) =>
                    _TravelItem(index: index, item: travelItems[index]),
                staggeredTileBuilder: (int index) =>
                    const StaggeredTile.fit(1)),
            removeTop: true,
          ),
        ),
      ),
    );
  }

  /// 下拉刷新
  Future _handleRefresh() async {
    _loadData();
  }

  /// 加载数据,是下拉刷新还是加载更多
  void _loadData({loadMore = false}) async {
    if (loadMore) {
      pageIndex++;
    } else {
      pageIndex = 1;
    }
    try {
      TravelModel model = await TravelDao.fetch(widget.travelUrl, widget.params,
          widget.groupChannelCode, widget.type, pageIndex, PAGE_SIZE);
      setState(() {
        print(model.totalCount);
        List<TravelItem> items = model.resultList;
        if (travelItems.isNotEmpty) {
          travelItems.addAll(items);
        } else {
          travelItems = items;
        }
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
  }
}

///构建每个小卡片的样式
class _TravelItem extends StatelessWidget {
  final TravelItem item;
  final int index;

  const _TravelItem({Key? key, required this.item, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        child: PhysicalModel(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, //左对齐
            children: [
              _itemImage,
              Container(
                padding: const EdgeInsets.all(4),
                child: Text(
                  item.article.articleTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              _infoText
            ],
          ),
        ),
      ),
    );
  }

  String _poiName() {
    return item.article.pois.isEmpty ? '未知' : item.article.pois[0].poiName;
  }

  ///卡片布局中的图片样式，采用 Stack 控件，图片加文字等
  Widget get _itemImage {
    return Stack(children: [
      CachedImage(imageUrl: item.article.images[0].dynamicUrl),
      //在图片上方放置一个绝对位置的布局
      Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
            decoration: BoxDecoration(
                color: Colors.black54, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const Padding(
                    padding: EdgeInsets.only(right: 3),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 12,
                    )),
                //限制子控件大小的 Widget
                LimitedBox(
                  maxWidth: 130,
                  child: Text(
                    _poiName(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, //尾部截断
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
          )),
    ]);
  }

  //图片下面的用户信息展示
  Widget get _infoText {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PhysicalModel(
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(12),
            child: CachedImage(
              imageUrl: item.article.author.coverImage.dynamicUrl,
              width: 24,
              height: 24,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            width: 90,
            child: Text(
              item.article.author.nickName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.thumb_up,
                size: 14,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Text(
                  item.article.likeCount.toString(),
                  style: const TextStyle(fontSize: 10),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
