import 'package:asset_tracking/New%20Design/Dashboard.dart';
import 'package:asset_tracking/New%20Design/Swap%20Tag/Avaible_Types.dart';
import 'package:asset_tracking/New%20Design/Voage_History/VoyagePage.dart';
import 'package:asset_tracking/New%20Design/NotificationPage.dart';
import 'package:asset_tracking/New%20Design/QR_Code_Scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NewBottomNavigation extends StatefulWidget {
  const NewBottomNavigation({Key? key});

  @override
  State<NewBottomNavigation> createState() => _NewBottomNavigationState();
}

class _NewBottomNavigationState extends State<NewBottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    NewDashboard(),
    VoyagePage(),
    NotificationPage(),
    // NewProfilePage(),
    QRCodeScanner(),
    NewAssetTagSwap()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            _pages[_selectedIndex],
            Positioned(
              left: 5,
              right: 5,
              bottom: 5,
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    width: 320,
                    height: 70,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x2B000000),
                          blurRadius: 19,
                          offset: Offset(0, 0),
                          spreadRadius: 3,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _onItemTapped(0);
                          },
                          child: SvgPicture.asset(
                            'images/svg/home.svg',
                            height: 25,
                            color: _selectedIndex == 0
                                ? Color.fromRGBO(
                                    168, 3, 3, 1) // Highlighted color
                                : Colors.black, // Inactive color
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _onItemTapped(1);
                          },
                          child: SvgPicture.asset(
                            'images/svg/history.svg',
                            height: 25,
                            color: _selectedIndex == 1
                                ? Color.fromRGBO(
                                    168, 3, 3, 1) // Highlighted color
                                : Colors.black, // Inactive color
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _onItemTapped(2);
                          },
                          child: SvgPicture.asset(
                            'images/svg/notification.svg',
                            height: 25,
                            color: _selectedIndex == 2
                                ? Color.fromRGBO(168, 3, 3, 1)
                                : Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _onItemTapped(3);
                          },
                          child: SvgPicture.asset(
                            'images/svg/scaner.svg',
                            height: 25,

                            color: _selectedIndex == 3
                                ? Color.fromRGBO(
                                    168, 3, 3, 1) // Highlighted color
                                : Colors.black, // Inactive color
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _onItemTapped(4);
                          },
                          child:
                              //Icon(Icons.swap_horiz_sharp)
                              SvgPicture.asset(
                            'images/svg/broken.svg',
                            height: 30,

                            color: _selectedIndex == 4
                                ? Color.fromRGBO(
                                    168, 3, 3, 1) // Highlighted color
                                : Colors.black, // Inactive color
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
