import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'nest_scroll_notifacation.dart';

/// @Description: 嵌套滚动父布局响应
/// @Author: SWY
/// @Date: 2021/2/15 20:29
class NestPageHelperParent extends StatefulWidget {
  final child;
  final PageController pageController;

  NestPageHelperParent(
      {Key key, @required this.child, @required this.pageController})
      : super(key: key);

  @override
  _NestPageHelperParentState createState() =>
      _NestPageHelperParentState(child: child, pageController: pageController);
}

class _NestPageHelperParentState extends State<NestPageHelperParent> {
  final child;
  final PageController pageController;

  _NestPageHelperParentState(
      {@required this.child, @required this.pageController});

  double _totalOffset;
  Drag _drag;
  int _frequency = 0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      child: child,
      onNotification: (notification) {
        if (pageController == null) return true;

        switch (notification.runtimeType) {
          case NestedStartNotification:
            _totalOffset = 0.0;
            _drag = creatDragStart();
            _frequency = 0;
            break;

          case NestedMoveNotification:
            if (_totalOffset == null) _totalOffset = 0;
            _totalOffset += notification.xdiff;
            _frequency++;
            if (_drag == null) return false;
            _drag.update(DragUpdateDetails(
                delta: Offset(notification.xdiff, 0),
                globalPosition:
                    Offset(pageController.offset + notification.xdiff, 0),
                primaryDelta: notification.xdiff));
            break;

          case NestedEndNitification:
            if (_drag != null) _drag.end(DragEndDetails(primaryVelocity: 0.0));
            _drag = null;
            double velocity = _totalOffset / _frequency;
            //去前页
            if (velocity > 2) {
              pageController.previousPage(
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
            }
            //去后页
            if (velocity < -2) {
              pageController.nextPage(
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
            }
            break;
        }
        return true;
      },
    );
  }

  @override
  void dispose() {
    _drag.cancel();
    pageController.dispose();
    super.dispose();
  }

  Drag creatDragStart() {
    if (_drag != null) _drag.cancel();
    return pageController.position.drag(
        DragStartDetails(localPosition: Offset(pageController.offset, 0)),
        () {});
  }
}
