import 'package:flutter/material.dart';

import 'nest_scroll_notifacation.dart';

/// @Description: 嵌套滚动子布局边界通知
/// @Author: SWY
/// @Date: 2021/2/15 20:29

// ignore: must_be_immutable

class NestPageHelperChild extends StatefulWidget {
  Widget child;
  PageController pageController;
  NestPageHelperChild(
      {Key key, @required this.child, @required this.pageController})
      : super(key: key);
  @override
  _NestPageHelperChildState createState() => _NestPageHelperChildState();
}

class _NestPageHelperChildState extends State<NestPageHelperChild> {
  bool direction;
  double recordPixel;
  bool lock = false;

  @override
  Widget build(BuildContext context) {
    var movediff;
    bool isStart = false;
    return NotificationListener(
      child: ScrollConfiguration(
        child: widget.child,
        behavior: _AlphaScrollBehavior(),
      ),
      onNotification: (notification) {
        switch (notification.runtimeType) {
          case ScrollStartNotification:
            break;
          case ScrollUpdateNotification:
            if (!isStart || lock || (direction == null)) return false;
            ScrollUpdateNotification xdiff = notification;
            if (xdiff.dragDetails == null) return false;
            double offsetX = xdiff.dragDetails.delta.dx;
            bool outRange = (direction && recordPixel > 0) ||
                (!direction && recordPixel < 0);
            if ((direction && movediff.xdiff > 0) ||
                (!direction && movediff.xdiff < 0)) {
            } else {
              if (outRange) {
                print('herer');
                lock = true;
                widget.pageController.position
                    .setPixels(widget.pageController.position.pixels + offsetX);
                lock = false;
              }
            }

            if (outRange) {
              recordPixel += offsetX;
              movediff.update(offsetX);
              movediff.dispatch(context);
            }

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
            direction = xdiff.dragDetails.delta.dx > 0;
            if (xdiff.dragDetails == null) return false;
            double offsetX = xdiff.dragDetails.delta.dx;
            if (movediff == null) {
              isStart = true;
              recordPixel = 0;
              movediff = NestedMoveNotification(xdiff: offsetX);
              NestedStartNotification().dispatch(context);
            }
            recordPixel += offsetX;
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
