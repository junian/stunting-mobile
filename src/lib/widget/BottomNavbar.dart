import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:growthtracker/controller/AuthController.dart';import 'package:growthtracker/controller/ChildrenController.dart';


import 'package:growthtracker/pages/ArticlePage.dart';
import 'package:growthtracker/pages/HomePage.dart';
import 'package:growthtracker/pages/HomePage2.dart';
import 'package:growthtracker/pages/ConsultationPage.dart';
import 'package:growthtracker/pages/LoginPage.dart';
import 'package:growthtracker/pages/RegisterPage.dart';
import 'package:growthtracker/pages/SettingUserPage.dart';
import 'package:growthtracker/pages/WelcomePage.dart';
import 'package:get/get.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final childernController = Get.put(ChildrenController());
  final authController = Get.put(AuthController());

  final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0; //default index of a first screen

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;

  final iconList = <IconData>[
    Icons.home_filled,
    Icons.article,
    Icons.settings,
  ];

  @override
  void initState() {
    super.initState();
    authController.bottomNavIndex;

    Future.delayed(
      Duration(seconds: 1),
      () => _fabAnimationController.forward(),
    );
    Future.delayed(
      Duration(seconds: 1),
      () => _borderRadiusAnimationController.forward(),
    );
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification &&
        notification.metrics.axis == Axis.vertical) {
      switch (notification.direction) {
        case ScrollDirection.forward:
          _hideBottomBarAnimationController.reverse();
          _fabAnimationController.forward(from: 0);
          break;
        case ScrollDirection.reverse:
          _hideBottomBarAnimationController.forward();
          _fabAnimationController.reverse(from: 1);
          break;
        case ScrollDirection.idle:
          break;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double bottomNavBarHeight = kBottomNavigationBarHeight;
          final double availableHeight =
              MediaQuery.of(context).size.height - bottomNavBarHeight;

          return Stack(
            children: [
              Offstage(
                offstage:
                    _bottomNavIndex != 0, // Control the visibility of page 0
                child: Container(
                  height: availableHeight,
                  child: HomePage(),
                ),
              ),
              Offstage(
                offstage:
                    _bottomNavIndex != 1, // Control the visibility of page 1
                child: ArticlePage(),
              ),
              Offstage(
                offstage:
                    _bottomNavIndex != 2, // Control the visibility of page 3
                child: SettingUserPage(),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        inactiveColor: Colors.grey,
        activeColor: Colors.blue,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.none,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        backgroundColor: Colors.white,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),
    );
  }
}
