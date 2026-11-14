import 'package:flutter/widgets.dart';

/// Lets the app shell know when a full-screen route covers it, so the floating
/// navigation bar is removed before the new route is composited.
final RouteObserver<PageRoute<dynamic>> appRouteObserver =
    RouteObserver<PageRoute<dynamic>>();
