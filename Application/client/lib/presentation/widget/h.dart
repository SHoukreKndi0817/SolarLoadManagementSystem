import 'dart:math';

import 'package:flutter/cupertino.dart';

class HomeScreenViewModel  {
  //-------------VARIABLES-------------//
  int selectedIndex = 0;
  int randomNumber = 1;
  final PageController pageController = PageController();
  bool isLightOn = true;
  bool isACON = false;
  bool isSpeakerON = false;
  bool isFanON = false;
  bool isLightFav = false;
  bool isACFav = false;
  bool isSpeakerFav = false;
  bool isFanFav = false;
  void generateRandomNumber() {
    randomNumber = Random().nextInt(8);
  }
  void lightFav(){
    isLightFav = !isLightFav;
  }
  void acFav(){
    isACFav = !isACFav;
  }
  void speakerFav() {
    isSpeakerFav = !isSpeakerFav;
  }
  void fanFav() {
    isFanFav = !isFanFav;
  }

  void acSwitch() {
    isACON = !isACON;
  }

  void speakerSwitch() {
    isSpeakerON = !isSpeakerON;
  }

  void fanSwitch() {
    isFanON = !isFanON;
  }
  void lightSwitch() {
    isLightOn = !isLightOn;
  }

  ///On tapping bottom nav bar items
  void onItemTapped(int index) {
    selectedIndex = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  }
}