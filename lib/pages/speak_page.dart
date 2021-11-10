import 'package:flutter/material.dart';

///语音输入界面
///flutter 动画知识：https://book.flutterchina.club/chapter9/intro.html
class SpeakPage extends StatefulWidget {
  const SpeakPage({Key? key}) : super(key: key);

  @override
  _SpeakPageState createState() => _SpeakPageState();
}

class _SpeakPageState extends State<SpeakPage>
    with SingleTickerProviderStateMixin {
  String speakTips = '长按说话';

  String speakResult = '';

  ///它主要的功能是保存动画的插值和状态
  late Animation<double> animation;

  ///用于控制动画，它包含动画的启动forward()、停止stop() 、反向播放 reverse()等方法。AnimationController会在动画的每一帧，就会生成一个新的值
  late AnimationController _controller;

  ///通过CurvedAnimation来指定动画的曲线: easeIn:开始慢，后面快  linear:匀速的  decelerate:匀减速
  ///
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn)
      ..addStatusListener((status) {
        ///它可以给Animation添加“动画状态改变”监听器；动画开始、结束、正向或反向（见AnimationStatus定义）时会调用状态改变的监听器。
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _topItem,
              _bottomItem,
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 开始录音
  void _speakStart() {
    _controller.forward();
    setState(() {
      speakTips = '识别中...';
    });
  }

  ///结束录音
  void _speakStop() {
    setState(() {
      speakTips = '长按说话';
    });
    _controller.reset();
    _controller.stop();
  }

  /// 顶部 item
  Widget get _topItem {
    return Column(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
          child: Text(
            '你可以这样说',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        const Text('故宫门票\n北京一日游\n迪士尼乐园',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            )),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            speakResult,
            style: const TextStyle(color: Colors.blue),
          ),
        )
      ],
    );
  }

  /// 底部 item
  Widget get _bottomItem {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapDown: (e) {
              _speakStart();
            },
            onTapUp: (e) {
              _speakStop();
            },
            onTapCancel: () {
              _speakStop();
            },
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      speakTips,
                      style: const TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      const SizedBox(
                        //占坑，避免动画执行过程中导致父布局大小变得
                        height: MIC_SIZE,
                        width: MIC_SIZE,
                      ),
                      Center(
                        child: AnimatedMic(
                          animation: animation,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.close,
                size: 30,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }
}

const double MIC_SIZE = 80;

/// 圆球动画
class AnimatedMic extends AnimatedWidget {
  static final _operateTween = Tween<double>(begin: 1, end: 0.5);
  static final _sizeTween = Tween<double>(begin: MIC_SIZE, end: MIC_SIZE - 20);

  const AnimatedMic({
    Key? key,
    required Animation<double> animation,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    return Opacity(
      opacity: _operateTween.evaluate(animation),
      child: Container(
        height: _sizeTween.evaluate(animation),
        width: _sizeTween.evaluate(animation),
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(MIC_SIZE / 2)),
        child: const Icon(
          Icons.mic,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
