import 'package:flutter/material.dart';

import 'nest_scroll_notifacation.dart';

/// @Description: 嵌套滚动子布局边界通知
/// @Author: SWY
/// @Date: 2021/2/15 20:29

class NestPageHelperChild extends StatelessWidget {
  final Widget child;

  NestPageHelperChild({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var movediff;
    bool isStart = false;
    return NotificationListener(
      child: ScrollConfiguration(
        child: child,
        behavior: _AlphaScrollBehavior(),
      ),
      onNotification: (notification) {
        switch (notification.runtimeType) {
          case ScrollStartNotification:
            break;
          case ScrollUpdateNotification:
            if (!isStart) return false;
            ScrollUpdateNotification xdiff = notification;
            if (xdiff.dragDetails == null) return false;
            double offsetX = xdiff.dragDetails.delta.dx;
            movediff.update(offsetX);
            movediff.dispatch(context);
            break;
          case ScrollEndNotification:
            movediff = null;
            if (isStart) {
              NestedEndNitification().dispatch(context);
              isStart = false;
            }
            break;
          case OverscrollNotification:
            OverscrollNotification xdiff = notification;
            if (xdiff.dragDetails == null) return false;
            double offsetX = xdiff.dragDetails.delta.dx;
            if (movediff == null) {
              isStart = true;
              movediff = NestedMoveNotification(xdiff: offsetX);
              NestedStartNotification().dispatch(context);
            }
            movediff.update(offsetX);
            movediff.dispatch(context);
            break;
        }
        return true;
      },
    );
  }
}

class _AlphaScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return GlowingOverscrollIndicator(
      child: child,
      axisDirection: axisDirection,
      color: Colors.transparent,
      showLeading: false,
      showTrailing: false,
    );
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return ClampingScrollPhysics();
  }
}
