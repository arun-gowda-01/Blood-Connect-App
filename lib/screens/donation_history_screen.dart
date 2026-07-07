import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationHistoryScreen extends StatefulWidget {
  const DonationHistoryScreen({super.key});

  @override
  State<DonationHistoryScreen> createState() =>
      _DonationHistoryScreenState();
}

class _DonationHistoryScreenState
    extends State<DonationHistoryScreen> {

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {

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

  String formatDate(Timestamp? ts) {

    if (ts == null) return "Not Added";

    final d = ts.toDate();

    return
        "${d.day}/${d.month}/${d.year}";
  }

  bool isEligible(Timestamp? next) {

    if (next == null) return true;

    return DateTime.now()
        .isAfter(next.toDate());
  }

  @override
  Widget build(BuildContext context) {

    if (userData == null) {

      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    final last =
        userData!["lastDonationDate"];

    final next =
        userData!["nextEligibleDate"];

    final eligible =
        isEligible(next);

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.red,
        title:
            const Text(
                "Donation History"),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(
                      20),

              decoration:
                  BoxDecoration(

                color:
                    Colors.red.shade50,

                borderRadius:
                    BorderRadius.circular(
                        20),
              ),

              child: Column(

                children: [

                  const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 60,
                  ),

                  const SizedBox(
                      height: 15),

                  Text(
                    eligible
                        ? "Eligible To Donate"
                        : "Not Eligible Yet",

                    style:
                        TextStyle(

                      color:
                          eligible
                              ? Colors
                                  .green
                              : Colors
                                  .red,

                      fontSize: 22,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
                height: 20),

            Card(
              child: ListTile(
                leading:
                    const Icon(
                  Icons.history,
                ),

                title:
                    const Text(
                        "Last Donation"),

                subtitle:
                    Text(
                  formatDate(last),
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading:
                    const Icon(
                  Icons.calendar_today,
                ),

                title:
                    const Text(
                        "Next Eligible Date"),

                subtitle:
                    Text(
                  formatDate(next),
                ),
              ),
            ),

            const SizedBox(
                height: 25),

            Container(

              padding:
                  const EdgeInsets.all(
                      16),

              decoration:
                  BoxDecoration(
                color:
                    Colors.white,

                borderRadius:
                    BorderRadius.circular(
                        20),
              ),

              child: const Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Text(
                    "Blood Donation Guidelines",

                    style:
                        TextStyle(
                      fontWeight:
                          FontWeight.bold,

                      fontSize:
                          20,
                    ),
                  ),

                  SizedBox(
                      height: 15),

                  Text(
                    "• Eat healthy before donation\n\n"
                    "• Stay hydrated\n\n"
                    "• Maintain iron levels\n\n"
                    "• Avoid smoking before donation\n\n"
                    "• Wait recovery period\n\n"
                    "• Whole blood donors generally wait around 3 months before donating again.",
                  ),

                  SizedBox(
                      height: 20),

                  Text(
                    "Why waiting period exists?",

                    style:
                        TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(
                      height: 10),

                  Text(
                    "Your body needs time to rebuild red blood cells and maintain safe iron levels before another donation.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}