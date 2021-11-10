import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/services.dart';

///城市列表选择器，可以参考插件库代码: https://github.com/flutterchina/azlistview
class CityPage extends StatefulWidget {
  final String city;

  const CityPage({Key? key, required this.city}) : super(key: key);

  @override
  _CityPageState createState() => _CityPageState();
}

///定义热门城市
const CITY_NAME_LIST = ['北京市', '广州市', '成都市', '深圳市', '杭州市', '武汉市'];

class _CityPageState extends State<CityPage> {
  List<CityModel> cityList = [];

  final List<CityModel> _hotCityList = [];

  @override
  void initState() {
    super.initState();
    for (var element in CITY_NAME_LIST) {
      _hotCityList.add(CityModel(name: element, tagIndex: '★'));
    }
    Future.delayed(const Duration(microseconds: 15), () {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            header(),
            Expanded(
                child: Material(
              color: const Color(0x80000000),
              child: Card(
                clipBehavior: Clip.hardEdge, //裁剪，去掉抗锯齿
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                shape: const RoundedRectangleBorder(
                    //裁剪圆角的位置
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0))),
                child: Column(
                  children: [
                    Container(
                      //显示当前选择的城市
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 15),
                      height: 50.0,
                      child: Text('当前城市：${widget.city}'),
                    ),
                    Expanded(
                        //城市列表
                        child: AzListView(
                      data: cityList,
                      itemCount: cityList.length,
                      itemBuilder: (BuildContext context, int index) {
                        CityModel model = cityList[index];
                        return Utils.getListItem(context, model);
                      },
                      padding: EdgeInsets.zero,
                      susItemBuilder: (BuildContext context, int index) {
                        CityModel model = cityList[index];
                        String tag = model.getSuspensionTag();
                        return Utils.getSusItem(context, tag);
                      },
                      indexBarData: const ['★', ...kIndexBarData], //右侧的导航条
                    )),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  ///1.顶部搜搜框
  Widget header() {
    return Container(
      color: Colors.white,
      height: 44,
      child: Row(
        children: [
          const Expanded(
              child: TextField(
            autofocus: false,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                border: InputBorder.none,
                labelStyle: TextStyle(fontSize: 14, color: Color(0xFF333333)),
                hintText: '城市中文或拼音',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFCCCCCC),
                )),
          )),
          Container(
            width: 0.33,
            height: 14.0,
            color: const Color(0xFFEFEFEF),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context, widget.city);
            },
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "取消",
                style: TextStyle(color: Color(0xFF999999), fontSize: 14),
              ),
            ),
          )
        ],
      ),
    );
  }

  ///记载 assets 目录下的json文件
  void _loadData() {
    rootBundle.loadString('assets/data/china.json').then((value) {
      cityList.clear();
      Map countyMap = json.decode(value);
      List list = countyMap['china'];
      for (var v in list) {
        cityList.add(CityModel.fromJson(v));
      }
      _handleList(cityList);
    });
  }

  /// 处理城市列表
  void _handleList(List<CityModel> list) {
    if (list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      //将城市名转换为拼音
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      //获取第一个字母
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(list);
    // add hotCityList.
    cityList.insertAll(0, _hotCityList);
    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(cityList);
    setState(() {});
  }
}

///城市模型，支持索引
class CityModel extends ISuspensionBean {
  String name;
  String? tagIndex;
  String? namePinyin;

  CityModel({
    required this.name,
    this.tagIndex,
    this.namePinyin,
  });

  CityModel.fromJson(Map<String, dynamic> json) : name = json['name'];

  Map<String, dynamic> toJson() => {
        'name': name,
      };

  @override
  String getSuspensionTag() => tagIndex!;

  @override
  String toString() => json.encode(this);
}

class Utils {
  ///列表的 Header 头
  static Widget getSusItem(BuildContext context, String tag,
      {double susHeight = 40}) {
    if (tag == '★') {
      tag = '★ 热门城市';
    }
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 16.0),
      color: const Color(0xFFF3F4F5),
      alignment: Alignment.centerLeft,
      child: Text(
        tag,
        softWrap: false,
        style: const TextStyle(
          fontSize: 14.0,
          color: Color(0xFF666666),
        ),
      ),
    );
  }

  ///城市列表的 Item
  static Widget getListItem(BuildContext context, CityModel model,
      {double susHeight = 40}) {
    return ListTile(
      title: Text(model.name),
      onTap: () {
        Navigator.pop(context, model.name);
      },
    );
  }
}
