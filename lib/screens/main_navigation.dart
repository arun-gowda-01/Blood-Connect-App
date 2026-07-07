import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// SCREENS
import 'home_screen.dart';
import 'find_donor_screen.dart';
import 'emergency_request_screen.dart';
import 'profile_screen.dart';
import 'donate_screen.dart';
import 'my_requests_screen.dart';
import 'my_donations_screen.dart';
import 'login_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() =>
      _MainNavigationState();
}

class _MainNavigationState
    extends State<MainNavigation> {

  int selectedIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const FindDonorScreen(),
    const EmergencyRequestScreen(),
    const ProfileScreen(),
  ];

  void navigateTo(int index) {

    Navigator.pop(context);

    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(

      // ✅ NO APPBAR HERE

      // ✅ DRAWER
      drawer: Drawer(
        child: Column(
          children: [

            UserAccountsDrawerHeader(
              decoration:
                  const BoxDecoration(
                color: Colors.red,
              ),

              accountName: Text(
                user?.displayName ??
                    "Guest",
              ),

              accountEmail: Text(
                user?.email ??
                    "Not Logged In",
              ),

              currentAccountPicture:
                  const CircleAvatar(
                backgroundColor:
                    Colors.white,

                child: Icon(
                  Icons.person,
                  color: Colors.red,
                ),
              ),
            ),

            // HOME
            ListTile(
              leading:
                  const Icon(Icons.home),

              title: const Text("Home"),

              onTap: () =>
                  navigateTo(0),
            ),

            // FIND DONOR
            ListTile(
              leading:
                  const Icon(Icons.search),

              title:
                  const Text("Find Donor"),

              onTap: () =>
                  navigateTo(1),
            ),

            // EMERGENCY
            ListTile(
              leading:
                  const Icon(Icons.warning),

              title:
                  const Text("Emergency"),

              onTap: () {

                if (user == null) {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const LoginScreen(),
                    ),
                  );

                } else {

                  navigateTo(2);
                }
              },
            ),

            // DONATE
            ListTile(
              leading: const Icon(
                  Icons.volunteer_activism),

              title:
                  const Text("Donate"),

              onTap: () {

                if (user == null) {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const LoginScreen(),
                    ),
                  );

                } else {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const DonateScreen(),
                    ),
                  );
                }
              },
            ),

            // MY REQUESTS
            ListTile(
              leading:
                  const Icon(Icons.history),

              title:
                  const Text("My Requests"),

              onTap: () {

                if (user == null) {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const LoginScreen(),
                    ),
                  );

                } else {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const MyRequestsScreen(),
                    ),
                  );
                }
              },
            ),

            // ✅ MY DONATIONS
            ListTile(
              leading: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),

              title:
                  const Text("My Donations"),

              onTap: () {

                if (user == null) {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const LoginScreen(),
                    ),
                  );

                } else {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const MyDonationsScreen(),
                    ),
                  );
                }
              },
            ),

            // PROFILE
            ListTile(
              leading:
                  const Icon(Icons.person),

              title:
                  const Text("Profile"),

              onTap: () {

                if (user == null) {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const LoginScreen(),
                    ),
                  );

                } else {

                  navigateTo(3);
                }
              },
            ),

            const Spacer(),

            // LOGOUT
            if (user != null)

              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),

                title:
                    const Text("Logout"),

                onTap: () async {

                  await FirebaseAuth
                      .instance
                      .signOut();

                  Navigator.pushAndRemoveUntil(
                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          const LoginScreen(),
                    ),

                    (route) => false,
                  );
                },
              ),
          ],
        ),
      ),

      // ✅ BODY
      body: AnimatedSwitcher(
        duration:
            const Duration(milliseconds: 300),

        child: pages[selectedIndex],
      ),

      // ✅ BOTTOM NAVIGATION
      bottomNavigationBar:
          BottomNavigationBar(

        currentIndex: selectedIndex,

        selectedItemColor:
            Colors.red,

        unselectedItemColor:
            Colors.grey,

        type:
            BottomNavigationBarType.fixed,

        onTap: (index) {

          setState(() {
            selectedIndex = index;
          });
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Find",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: "Emergency",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}