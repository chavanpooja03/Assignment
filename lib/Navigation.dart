import 'package:assignment/Screen/Add_video_screen.dart';
import 'package:assignment/Screen/Explore_Screen.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

int currentIndex = 0;

class _NavigationScreenState extends State<NavigationScreen> {
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  onPageChanged(int page) {
    setState(() {
      currentIndex = page;
    });
  }

  navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            currentIndex: currentIndex,
            onTap: navigationTapped,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline), label: ''),
            ]),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          ExploreScreen(),
          addVideo(),
        ],
      ),
    );
  }
}
