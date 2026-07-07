import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// SCREENS
import 'package:blood_donation_app/screens/blood_info_screen.dart';
import 'package:blood_donation_app/screens/find_donor_screen.dart';
import 'package:blood_donation_app/screens/emergency_request_screen.dart';
import 'package:blood_donation_app/screens/donate_screen.dart';
import 'package:blood_donation_app/screens/my_requests_screen.dart';
import 'package:blood_donation_app/screens/login_screen.dart';
import 'package:blood_donation_app/screens/my_donations_screen.dart';
import 'package:blood_donation_app/screens/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(

      backgroundColor: const Color(0xFFF3F6FB),

      // ✅ DRAWER ADDED
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 35,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    user?.displayName ?? "Blood Connect",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    user?.email ?? "",
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.search),
              title: const Text("Find Donor"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FindDonorScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.warning),
              title: const Text("Emergency Request"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const EmergencyRequestScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading:
                  const Icon(Icons.volunteer_activism),
              title: const Text("Donate Blood"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DonateScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("My Requests"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const MyRequestsScreen(),
                  ),
                );
              },
            ),

            // ✅ NEW FEATURE
            ListTile(
              leading:
                  const Icon(Icons.favorite, color: Colors.red),
              title: const Text("My Donations"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const MyDonationsScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading:
                  const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () async {

                await FirebaseAuth.instance.signOut();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // 🔴 HERO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE53935), Color(0xFFEF5350)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ✅ MENU BUTTON
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Donate Blood ❤️",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Be a hero. Save lives.",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 📊 STATS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [

                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .where("isDonor", isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {

                        if (!snapshot.hasData) {
                          return _statCard(
                              "Donors", "...", Colors.red);
                        }

                        return _statCard(
                          "Donors",
                          "${snapshot.data!.docs.length}",
                          Colors.red,
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("emergency_requests")
                          .snapshots(),
                      builder: (context, snapshot) {

                        if (!snapshot.hasData) {
                          return _statCard(
                              "Requests",
                              "...",
                              Colors.orange);
                        }

                        return _statCard(
                          "Requests",
                          "${snapshot.data!.docs.length}",
                          Colors.orange,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            

const SizedBox(height: 20),

// ================= DASHBOARD =================

Padding(
  padding:
      const EdgeInsets.symmetric(
          horizontal: 16),

  child: Column(

    crossAxisAlignment:
        CrossAxisAlignment.start,

    children: [

      const Text(
        "Dashboard",
        style: TextStyle(
          fontSize: 20,
          fontWeight:
              FontWeight.bold,
        ),
      ),

      const SizedBox(
          height: 15),

      StreamBuilder<QuerySnapshot>(

        stream:
            FirebaseFirestore
                .instance
                .collection(
                    "users")
                .snapshots(),

        builder:
            (context,
                snapshot) {

          if (!snapshot
              .hasData) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          int a = 0;
          int b = 0;
          int o = 0;
          int ab = 0;

          for (var doc
              in snapshot
                  .data!
                  .docs) {

            final data =
                doc.data()
                    as Map<
                        String,
                        dynamic>;

            final blood =
                data[
                        "bloodGroup"] ??
                    "";

            if (blood
                .startsWith(
                    "AB")) {

              ab++;

            } else if (blood
                .startsWith(
                    "A")) {

              a++;

            } else if (blood
                .startsWith(
                    "B")) {

              b++;

            } else if (blood
                .startsWith(
                    "O")) {

              o++;
            }
          }

          return Column(

            children: [

              Row(

                children: [

                  Expanded(

                    child:
                        _statCard(
                      "A",

                      "$a",

                      Colors.red,
                    ),
                  ),

                  const SizedBox(
                      width:
                          10),

                  Expanded(

                    child:
                        _statCard(
                      "B",

                      "$b",

                      Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                  height:
                      10),

              Row(

                children: [

                  Expanded(

                    child:
                        _statCard(
                      "O",

                      "$o",

                      Colors.green,
                    ),
                  ),

                  const SizedBox(
                      width:
                          10),

                  Expanded(

                    child:
                        _statCard(
                      "AB",

                      "$ab",

                      Colors.purple,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),

      const SizedBox(
          height: 20),

      StreamBuilder<QuerySnapshot>(

        stream:
            FirebaseFirestore
                .instance
                .collection(
                    "responses")
                .snapshots(),

        builder:
            (context,
                snapshot) {

          final impacted =
              snapshot
                      .data
                      ?.docs
                      .length ??
                  0;

          return Container(

            width:
                double.infinity,

            padding:
                const EdgeInsets
                    .all(
                        18),

            decoration:
                BoxDecoration(

              gradient:
                  const LinearGradient(

                colors: [

                  Colors.red,

                  Colors.redAccent,
                ],
              ),

              borderRadius:
                  BorderRadius.circular(
                      18),
            ),

            child:
                Column(

              children: [

                const Icon(

                  Icons.favorite,

                  color:
                      Colors.white,

                  size:
                      38,
                ),

                const SizedBox(
                    height:
                        10),

                const Text(

                  "Lives Impacted",

                  style:
                      TextStyle(

                    color:
                        Colors.white,

                    fontSize:
                        18,
                  ),
                ),

                const SizedBox(
                    height:
                        6),

                Text(

                  "$impacted",

                  style:
                      const TextStyle(

                    color:
                        Colors.white,

                    fontSize:
                        34,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ],
  ),
),

const SizedBox(height: 20),

// ================= ACTIONS =================

            // 🚀 ACTIONS
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [

                  _actionCard(
                    icon: Icons.search,
                    title: "Find Donor",
                    color: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const FindDonorScreen(),
                        ),
                      );
                    },
                  ),

                  _actionCard(
                    icon: Icons.warning,
                    title: "Emergency",
                    color: Colors.orange,
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
                                const EmergencyRequestScreen(),
                          ),
                        );
                      }
                    },
                  ),

                  _actionCard(
                    icon: Icons.volunteer_activism,
                    title: "Donate",
                    color: Colors.pink,
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

                  _actionCard(
                    icon: Icons.history,
                    title: "My Requests",
                    color: Colors.blue,
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
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 📚 LEARN SECTION
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Learn About Blood Donation",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            _infoCard(
              "Who can donate blood?",
              "Healthy individuals aged 18-65 can donate blood safely.",
            ),

            _infoCard(
              "Benefits of donating",
              "Improves heart health and helps save lives.",
            ),

            _infoCard(
              "How often can you donate?",
              "Every 3 months for men and 4 months for women.",
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            BloodInfoScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Check All Details",
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _statCard(
      String title,
      String value,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 5),

          Text(title),
        ],
      ),
    );
  }

  Widget _actionCard({
  required IconData icon,
  required String title,
  required Color color,
  required VoidCallback onTap,
}) {

  return TweenAnimationBuilder<double>(

    duration:
        const Duration(
      milliseconds: 700,
    ),

    tween:
        Tween(
      begin: 0.0,
      end: 1.0,
    ),

    builder:
        (
      context,
      value,
      child,
    ) {

      return Transform.scale(

        scale:
            0.85 +
                (value *
                    0.15),

        child:

            Opacity(

          opacity:
              value,

          child:

              GestureDetector(

            onTap:
                onTap,

            child:

                Container(

              decoration:
                  BoxDecoration(

                gradient:
                    LinearGradient(

                  begin:
                      Alignment
                          .topLeft,

                  end:
                      Alignment
                          .bottomRight,

                  colors: [

                    color,

                    color.withOpacity(
                        0.75),
                  ],
                ),

                borderRadius:
                    BorderRadius.circular(
                        28),

                boxShadow: [

                  BoxShadow(

                    color:
                        color.withOpacity(
                            0.35),

                    blurRadius:
                        22,

                    offset:
                        const Offset(
                            0,
                            12),
                  ),
                ],
              ),

              child:

                  Column(

                mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                children: [

                  Container(

                    padding:
                        const EdgeInsets
                            .all(
                                16),

                    decoration:
                        BoxDecoration(

                      shape:
                          BoxShape
                              .circle,

                      color:
                          Colors.white
                              .withOpacity(
                                  0.2),
                    ),

                    child:

                        Icon(

                      icon,

                      size:
                          34,

                      color:
                          Colors.white,
                    ),
                  ),

                  const SizedBox(
                      height:
                          14),

                  Text(

                    title,

                    style:
                        const TextStyle(

                      fontSize:
                          16,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

  Widget _infoCard(
String title,
String desc,
) {

return TweenAnimationBuilder<double>(

duration:
const Duration(
milliseconds: 700,
),

tween:
Tween<double>(
begin: 0.0,
end: 1.0,
),

builder:
(
context,
value,
child,
){

return Transform.translate(

offset:
Offset(
0,
30-(30*value),
),

child:

Opacity(

opacity:
value,

child:

Container(

margin:
const EdgeInsets.symmetric(

horizontal: 16,
vertical: 8,
),

padding:
const EdgeInsets.all(
18,
),

decoration:
BoxDecoration(

color:
Colors.white,

borderRadius:
BorderRadius.circular(
22,
),

boxShadow:[

BoxShadow(

color:
Colors.red.withOpacity(
0.08,
),

blurRadius:
18,

offset:
const Offset(
0,
8,
),
),
],
),

child:

Row(

crossAxisAlignment:
CrossAxisAlignment.start,

children:[

Container(

padding:
const EdgeInsets.all(
14,
),

decoration:
BoxDecoration(

shape:
BoxShape.circle,

color:
Colors.red
.withOpacity(
0.12,
),
),

child:

const Icon(

Icons.favorite,

color:
Colors.red,

size:
28,
),
),

const SizedBox(
width: 16,
),

Expanded(

child:

Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children:[

Text(

title,

style:
const TextStyle(

fontSize: 17,

fontWeight:
FontWeight.bold,
),
),

const SizedBox(
height: 8,
),

Text(

desc,

style:
TextStyle(

fontSize: 14,

height: 1.5,

color:
Colors.grey[700],
),
),
],
),
),
],
),
),
),
);
},
);
}
}