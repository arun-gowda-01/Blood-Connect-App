import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';
import 'edit_profile_screen.dart';
import 'donation_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

    setState(() {
      userData = doc.data();
    });
  }

  Future<void> logout() async {

    await FirebaseAuth.instance
        .signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const LoginScreen(),
      ),
    );
  }

  String formatDate(dynamic ts) {

    if (ts == null)
      return "Not Added";

    final d =
        (ts as Timestamp).toDate();

    return
        "${d.day}/${d.month}/${d.year}";
  }

  @override
  Widget build(
      BuildContext context) {

    if (userData == null) {

      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(

      appBar: AppBar(
        title:
            const Text(
                "My Profile"),

        backgroundColor:
            Colors.red,
      ),

      body:
          SingleChildScrollView(

        padding:
            const EdgeInsets.all(
                20),

        child: Column(

          children: [

            const CircleAvatar(

              radius: 55,

              backgroundColor:
                  Colors.red,

              child: Icon(
                Icons.person,

                size: 55,

                color:
                    Colors.white,
              ),
            ),

            const SizedBox(
                height: 20),

            Text(

              userData!["name"] ??
                  "No Name",

              style:
                  const TextStyle(
                fontSize:
                    22,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
                height: 25),

            Card(
              child: ListTile(
                leading:
                    const Icon(
                  Icons.email,
                ),

                title: Text(
                  userData![
                          "email"] ??
                      "",
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading:
                    const Icon(
                  Icons.phone,
                ),

                title: Text(
                  userData![
                          "phone"] ??
                      "",
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading:
                    const Icon(
                  Icons.location_city,
                ),

                title: Text(
                  userData![
                          "city"] ??
                      "",
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading:
                    const Icon(
                  Icons.bloodtype,
                ),

                title: Text(
                  userData![
                          "bloodGroup"] ??
                      "",
                ),
              ),
            ),

            // NEW
            Card(
              child: ListTile(

                leading:
                    const Icon(
                  Icons.history,
                  color:
                      Colors.red,
                ),

                title:
                    const Text(
                  "Last Donation",
                ),

                subtitle:
                    Text(
                  formatDate(
                    userData![
                        "lastDonationDate"],
                  ),
                ),
              ),
            ),

            Card(
              child: ListTile(

                leading:
                    const Icon(
                  Icons.calendar_month,
                  color:
                      Colors.green,
                ),

                title:
                    const Text(
                  "Next Eligible Date",
                ),

                subtitle:
                    Text(
                  formatDate(
                    userData![
                        "nextEligibleDate"],
                  ),
                ),
              ),
            ),

            const SizedBox(
                height: 25),

            ElevatedButton(

              style:
                  ElevatedButton
                      .styleFrom(

                minimumSize:
                    const Size(
                        double
                            .infinity,
                        50),

                backgroundColor:
                    Colors.deepPurple,
              ),

              onPressed:
                  () async {

                await Navigator
                    .push(

                  context,

                  MaterialPageRoute(

                    builder:
                        (_) =>
                            const DonationHistoryScreen(),
                  ),
                );

                fetchUserData();
              },

              child:
                  const Text(
                "Donation History",
              ),
            ),

            const SizedBox(
                height: 12),

            ElevatedButton(

              style:
                  ElevatedButton
                      .styleFrom(

                minimumSize:
                    const Size(
                        double
                            .infinity,
                        50),

                backgroundColor:
                    Colors.blue,
              ),

              onPressed:
                  () async {

                await Navigator
                    .push(

                  context,

                  MaterialPageRoute(

                    builder:
                        (_) =>
                            const EditProfileScreen(),
                  ),
                );

                fetchUserData();
              },

              child:
                  const Text(
                "Edit Profile",
              ),
            ),

            const SizedBox(
                height: 12),

            ElevatedButton(

              style:
                  ElevatedButton
                      .styleFrom(

                minimumSize:
                    const Size(
                        double
                            .infinity,
                        50),

                backgroundColor:
                    Colors.red,
              ),

              onPressed:
                  logout,

              child:
                  const Text(
                "Logout",
              ),
            ),
          ],
        ),
      ),
    );
  }
}