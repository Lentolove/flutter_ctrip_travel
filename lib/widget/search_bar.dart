import 'package:flutter/material.dart';

enum SearchBarType { home, homeLight, normal }

///自定义搜索 Bar，根据页面不同展示效果
class SearchBar extends StatefulWidget {
  final String city; //当前城市
  final bool enable; //是否可点击
  final bool? hideLeft; //是否隐藏左边的控件
  final bool autoFocus; //是否自动获取焦点
  final SearchBarType searchBarType; // 显示的样式
  final String? hint; //默认提示的文本
  final String defaultText; //默认搜索的文字
  final void Function() leftButtonClick; //左侧控件点击事件回调
  final void Function() rightButtonClick; //右侧控件点击事件回调
  final void Function() speakClick; //语音输入小图标点击回调
  final void Function() inputBoxClick; //输入框点击回调
  final ValueChanged<String> onChanged; //输入文本变化回调

  const SearchBar(
      {Key? key,
      required this.city,
      this.enable = true,
      this.hideLeft,
      this.autoFocus = false,
      this.searchBarType = SearchBarType.normal,
      this.hint,
      required this.defaultText,
      required this.leftButtonClick,
      required this.rightButtonClick,
      required this.speakClick,
      required this.inputBoxClick,
      required this.onChanged})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  //是否显示右侧的清除按钮
  bool showClear = false;

  //输入文本框内容监听
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.defaultText;
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal
        ? _normalSearchStyle
        : _homeSearchStyle;
  }

  ///获取字体颜色
  Color get _homeFontColor {
    return widget.searchBarType == SearchBarType.homeLight
        ? Colors.black54
        : Colors.white;
  }

  ///文本改变的回调,修改右侧清楚按钮的显示和隐藏
  void _onChanged(String text) {
    if (text.isNotEmpty) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }
    widget.onChanged(text);
  }

  /// 获取默认样式的搜索框
  Widget get _normalSearchStyle {
    return Row(
      children: [
        _wrapTap(
            Container(
              padding: const EdgeInsets.fromLTRB(6, 5, 10, 5),
              child: widget.hideLeft ?? false
                  ? null
                  : const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                      size: 26,
                    ),
            ),
            widget.leftButtonClick),
        Expanded(
          flex: 1,
          child: _inputBox,
        ),
        _wrapTap(
            Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: const Text(
                '搜索',
                style: TextStyle(color: Colors.blue, fontSize: 17),
              ),
            ),
            widget.rightButtonClick)
      ],
    );
  }

  /// 首页展示的样式
  Widget get _homeSearchStyle {
    return Row(
      children: [
        _wrapTap(
          Container(
            padding: const EdgeInsets.fromLTRB(6, 5, 5, 5),
            child: Row(
              children: <Widget>[
                Text(
                  widget.city,
                  style: TextStyle(
                    color: _homeFontColor,
                    fontSize: 14,
                  ),
                ),
                Icon(
                  Icons.expand_more,
                  color: _homeFontColor,
                  size: 22,
                ),
              ],
            ),
          ),
          widget.leftButtonClick,
        ),
        Expanded(
          flex: 1,
          child: _inputBox,
        ),
        _wrapTap(
          Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Icon(
              Icons.comment,
              color: _homeFontColor,
              size: 26,
            ),
          ),
          widget.rightButtonClick,
        ),
      ],
    );
  }

  ///输入框 Widget
  Widget get _inputBox {
    bool isNormal = widget.searchBarType == SearchBarType.normal;
    Color inputBoxColor;
    if (widget.searchBarType == SearchBarType.home) {
      inputBoxColor = Colors.white;
    } else {
      inputBoxColor = Color(int.parse('0xffEDEDED'));
    }
    return Container(
      height: 30,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: inputBoxColor,
        borderRadius: BorderRadius.circular(//如果是在home首页，则需要将背景的圆角设置大一些
            isNormal ? 5 : 15),
      ),
      child: Row(
        children: [
          Icon(Icons.search,
              size: 20,
              color: isNormal ? const Color(0xffa9a9a9) : Colors.blue),
          Expanded(
            flex: 1,
            child: isNormal
                ? TextField(
                    controller: _controller,
                    onChanged: _onChanged,
                    autofocus: widget.autoFocus,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        left: 5,
                        bottom: 14,
                        right: 5,
                      ),
                      border: InputBorder.none,
                      hintText: widget.hint ?? '',
                      hintStyle: const TextStyle(fontSize: 15),
                    ),
                  )
                : _wrapTap(
                    Text(
                      widget.defaultText,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    widget.inputBoxClick),
          ),
          showClear
              ? _wrapTap(
                  const Icon(
                    Icons.clear,
                    size: 22,
                    color: Colors.grey,
                  ), () {
                  setState(() {
                    _controller.clear();
                  });
                  _onChanged('');
                })
              : _wrapTap(
                  Icon(
                    Icons.mic,
                    size: 22,
                    color: isNormal ? Colors.blue : Colors.grey,
                  ),
                  widget.speakClick,
                )
        ],
      ),
    );
  }

  ///对需要点击的Widget进一步封装
  Widget _wrapTap(Widget child, void Function() callback) {
    return GestureDetector(
        onTap: () {
          callback();
        },
        child: child);
  }
}
