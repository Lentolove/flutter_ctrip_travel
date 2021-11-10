import 'package:flutter/material.dart';

class NavigationUtil {
  static push(BuildContext context, Widget widget) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => widget));
    return result;
  }
}

