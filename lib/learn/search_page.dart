import 'package:flutter/material.dart';
import 'package:flutter_trip2/dao/search_dao.dart';
import 'package:flutter_trip2/model/search_model.dart';
import 'package:flutter_trip2/pages/web_view.dart';
import 'package:flutter_trip2/utils/navigation_util.dart';
import 'package:flutter_trip2/widget/search_bar.dart';

const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];

const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

///搜索 首页
class SearchPage extends StatefulWidget {
  final bool? hideLeft;
  final String? searchUrl;
  final String? keyword;
  final String? hint;

  const SearchPage(
      {Key? key, this.hideLeft, this.searchUrl, this.keyword, this.hint})
      : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  SearchModel? searchModel;

  String? keyWord;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    print("SearchPage initState...");
    super.initState();
    if (widget.keyword != null) {
      _onTextChange(widget.keyword as String);
    }
  }

  ///输入文本框内容改变
  void _onTextChange(String text) async {
    keyWord = text;
    if (text.isEmpty) {
      setState(() {
        searchModel = null;
      });
      return;
    }
    try {
      SearchModel model = await SearchDao.fetch(keyWord!);
      // 只有当当前输入的内容和服务端返回的内容一致时才渲染
      if (model.keyword == keyWord) {
        setState(() {
          searchModel = model;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  /// 自定义导航栏
  Widget get _appBar {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x66000000), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        height: 80,
        decoration: const BoxDecoration(color: Colors.white),
        child: SearchBar(
          city: '',
          hideLeft: widget.hideLeft,
          defaultText: widget.keyword ?? '',
          hint: widget.hint ?? SEARCH_BAR_DEFAULT_TEXT,
          leftButtonClick: () {
            //todo
            Navigator.pop(context);
          },
          onChanged: _onTextChange,
          speakClick: _jumpToSpeak,
          inputBoxClick: () {},
          rightButtonClick: () {},
        ),
      ),
    );
  }

  /// 跳转语音识别页面
  void _jumpToSpeak() {
    //todo
  }

  ///搜索结果每一个 item的样式
  Widget? _item(int position) {
    if (searchModel == null) return null;
    SearchItem item = searchModel!.data[position];
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
          context,
          WebViewDiy(
            initialUrl: item.url.replaceAll('http', 'https'),
            title: '详情',
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey))),
        //设置下划线
        child: Row(
          children: [
            Container(
              //搜索类型的左侧小图标
              margin: const EdgeInsets.all(1),
              child: Image(
                height: 26,
                width: 26,
                image: AssetImage(_typeImage(item.type)),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: 300,
                  child: _title(item),
                ),
                Container(
                  width: 300,
                  margin: const EdgeInsets.only(top: 5),
                  child: _subTitle(item),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// -----搜索标题-----
  Widget? _title(SearchItem? item) {
    if (item == null) return null;
    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpans(item.word, searchModel!.keyword));
    spans.add(
      TextSpan(
          text: ' ' + (item.districtname ?? '') + ' ' + (item.zonename ?? ''),
          style: const TextStyle(fontSize: 12, color: Colors.grey)),
    );
    return RichText(text: TextSpan(children: spans));
  }

  /// -----搜索副标题----
  Widget? _subTitle(SearchItem? item) {
    if (item == null) return null;
    return RichText(
      text: TextSpan(children: <TextSpan>[
        TextSpan(
            text: item.price ?? '',
            style: const TextStyle(fontSize: 16, color: Colors.orange)),
        TextSpan(
            text: ' ' + (item.type ?? ''),
            style: const TextStyle(fontSize: 12, color: Colors.grey))
      ]),
    );
  }

  /// ----------------关键字高亮处理----------------
  List<TextSpan> _keywordTextSpans(String? word, String keyword) {
    List<TextSpan> spans = [];
    if (word == null || word.isEmpty) return spans;
    //搜索关键字高亮忽略大小写
    String wordL = word.toLowerCase(), keywordL = keyword.toLowerCase();
    List<String> arr = wordL.split(keywordL);
    TextStyle normalStyle =
        const TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keywordStyle =
        const TextStyle(fontSize: 16, color: Colors.orange);
    //'wordwoc'.split('w') -> [, ord, oc]
    int preIndex = 0;
    for (int i = 0; i < arr.length; i++) {
      if (i != 0) {
        //搜索关键字高亮忽略大小写
        preIndex = wordL.indexOf(keywordL, preIndex);
        spans.add(
          TextSpan(
              text: word.substring(preIndex, preIndex + keyword.length),
              style: keywordStyle),
        );
      }
      String val = arr[i];
      if (val.isNotEmpty) {
        spans.add(TextSpan(text: val, style: normalStyle));
      }
    }
    return spans;
  }

  ///根据搜索类型展示不同的小图标
  String _typeImage(String? type) {
    if (type == null) return 'assets/images/type_travelgroup.png';
    String path = 'travelgroup';
    for (final val in TYPES) {
      if (type.contains(val)) {
        path = val;
        break;
      }
    }
    return 'assets/images/type_$path.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _appBar,
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: searchModel?.data.length ?? 0,
                itemBuilder: (BuildContext context, int position) {
                  return _item(position) as Widget;
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
