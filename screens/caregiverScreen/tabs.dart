import 'package:firebase_messaging/firebase_messaging.dart'; // untuk push notification
import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:seniorconnect/screens/caregiverScreen/medication.dart';
import 'package:seniorconnect/screens/caregiverScreen/dashboard.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/screens/caregiverScreen/appointment.dart';
import 'package:seniorconnect/screens/caregiverScreen/DrawerScreen/drawer.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';

class TabScreenCaregiver extends StatefulWidget {
  @override
  State<TabScreenCaregiver> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreenCaregiver> {
  // initial page
  int _selectedPageIndex = 0;
  // Define the proportion you want for the BottomNavigationBar height
  double bottomNavBarHeightProportion = 0.1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupPushNotification();
  }

  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    final notificationSetting = await fcm.requestPermission();
    final token = await fcm.getToken();
    fcm.subscribeToTopic('caregiver');
    print('caregiver Token: ${token}');
  }

  // method utk tukar page
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
      print('$_selectedPageIndex page');
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    // Get the screen height
    double screenHeight = MediaQuery.of(context).size.height;

    // Calculate the height of the BottomNavigationBar
    double bottomNavBarHeight = screenHeight * bottomNavBarHeightProportion;

    void openDrawer() {
      _scaffoldKey.currentState!.openDrawer();
    }

    // initialize startup screen
    Widget activePage = medicationScreenV2(
      openDrawer: openDrawer,
    );
    var activePageTitle = 'Medication';

    // kalau index 1
    if (_selectedPageIndex == 1) {
      activePage = screen2();
      activePageTitle = 'Dashboard';
    }

    // kalau index 2
    if (_selectedPageIndex == 2) {
      activePage = appointment(openDrawer: openDrawer);
      activePageTitle = 'Appointment';
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: drawer(),
      body: activePage,

      bottomNavigationBar: FlashyTabBar(
        shadows: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
        selectedIndex: _selectedPageIndex,
        animationCurve: Curves.bounceIn,
        showElevation: true,
        onItemSelected: _selectPage,
        animationDuration: const Duration(seconds: 1),
        //iconSize: ,
        items: [
          FlashyTabBarItem(
              icon: const Icon(
                //color: Color.fromARGB(130, 0, 0, 0),
                Icons.add_moderator,
                size: 28,
              ),
              title: Text('Medication')),
          FlashyTabBarItem(
              icon: const Icon(
                //color: Color.fromARGB(130, 0, 0, 0),
                Icons.home,
                size: 28,
              ),
              title: Text('Dashboard')),
          FlashyTabBarItem(
              icon: const Icon(
                //color: Color.fromARGB(130, 0, 0, 0),
                Icons.calendar_month_sharp,
                size: 28,
              ),
              title: Text('Appointment')),
        ],
      ),

      // bottomNavigationBar: CurvedNavigationBar(
      //   //height: bottomNavBarHeight,
      //   //index: _selectedPageIndex,
      //   index: 1,
      //   color: tiffany_blue,
      //   buttonBackgroundColor: darkCyan,
      //   backgroundColor: putih,
      //   animationCurve: Curves.easeInOut,
      //   animationDuration: Duration(milliseconds: 600),
      //   onTap: _selectPage,
      //   items: [
      //     CurvedNavigationBarItem(
      //       child: Icon(
      //         color: putih,
      //         Icons.add_moderator,
      //         size: 35,
      //       ),
      //       label: 'Medication',
      //     ),
      //     CurvedNavigationBarItem(
      //       child: Icon(
      //         color: putih,
      //         Icons.home,
      //         size: 35,
      //       ),
      //       label: 'Dashboard',
      //     ),
      //     CurvedNavigationBarItem(
      //       child: Icon(
      //         color: putih,
      //         Icons.calendar_month_sharp,
      //         size: 35,
      //       ),
      //       label: 'Appointment',
      //     ),
      //   ],
      // ),
    );
  }
}
