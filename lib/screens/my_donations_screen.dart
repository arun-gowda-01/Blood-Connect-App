import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDonationsScreen extends StatelessWidget {
  const MyDonationsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("User not logged in"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Donations"),
        backgroundColor: Colors.red,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("responses")
            .where("donorId", isEqualTo: user.uid)
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No donation responses yet"),
            );
          }

          final responses = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: responses.length,
            itemBuilder: (context, index) {

              final responseDoc = responses[index];
              final responseData =
                  responseDoc.data() as Map<String, dynamic>;

              final requestId = responseData["requestId"];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("emergency_requests")
                    .doc(requestId)
                    .get(),

                builder: (context, requestSnap) {

                  if (!requestSnap.hasData) {
                    return const SizedBox();
                  }

                  if (!requestSnap.data!.exists) {
                    return const SizedBox();
                  }

                  final requestData =
                      requestSnap.data!.data()
                          as Map<String, dynamic>;

                  final acceptedDonorId =
                      requestData["acceptedDonorId"];

                  final isAccepted =
                      acceptedDonorId == user.uid;

                  final status =
                      requestData["status"] ?? "active";

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          // BLOOD GROUP
                          Row(
                            children: [

                              Text(
                                "${requestData["bloodGroup"]} Needed",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isAccepted
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),

                              const Spacer(),

                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: isAccepted
                                      ? Colors.green
                                      : Colors.orange,
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: Text(
                                  isAccepted
                                      ? "Accepted"
                                      : "Pending",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // NAME
                          Text(
                            "Receiver: ${requestData["name"] ?? "Unknown"}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          // LOCATION
                          Text(
                            "📍 ${requestData["location"] ?? ""}",
                          ),

                          const SizedBox(height: 5),

                          // MESSAGE
                          if (requestData["message"] != null)
                            Text(
                              "📝 ${requestData["message"]}",
                            ),

                          const SizedBox(height: 10),

                          // PHONE SECURITY
                          if (isAccepted)
                            Container(
                              padding:
                                  const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  const Text(
                                    "✅ You were accepted as donor",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    "📞 ${requestData["phone"]}",
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Container(
                              padding:
                                  const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "⏳ Waiting for receiver approval",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),

                          const SizedBox(height: 10),

                          // COMPLETED STATUS
                          if (status == "completed")
                            Container(
                              padding:
                                  const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "✔ Request completed",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}