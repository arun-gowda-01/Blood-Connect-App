import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Requests"),
        backgroundColor: Colors.red,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("emergency_requests")
            .where("userId", isEqualTo: user.uid)
            .snapshots(), // 🔥 REMOVED orderBy (fixes error)

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print(snapshot.error); // 🔥 debug
            return const Center(child: Text("Error loading data"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No requests yet"));
          }

          // 🔥 MANUAL SORT (replaces orderBy)
          final requests = snapshot.data!.docs;
          requests.sort((a, b) {
            final aTime = a["createdAt"];
            final bTime = b["createdAt"];

            if (aTime == null || bTime == null) return 0;

            return (bTime as Timestamp)
                .compareTo(aTime as Timestamp);
          });

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: requests.length,
            itemBuilder: (context, index) {

              final doc = requests[index];
              final data = doc.data() as Map<String, dynamic>;

              final status = data["status"] ?? "active";
              final isCompleted = status == "completed";
              final acceptedDonorId = data["acceptedDonorId"];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // TITLE
                      Row(
                        children: [
                          Text(
                            "${data["bloodGroup"] ?? ""} Needed",
                            style: TextStyle(
                              color: isCompleted ? Colors.grey : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: isCompleted ? Colors.grey : Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isCompleted ? "Done" : "Active",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      // DETAILS
                      Text(
                        data["name"] ?? "Unknown",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("📍 ${data["location"] ?? ""}"),

                      // PHONE
                      if (acceptedDonorId != null)
                        Text("📞 ${data["phone"]}")
                      else
                        const Text("📞 Hidden until donor accepted 🔒"),

                      const SizedBox(height: 10),

                      // DONOR RESPONSES
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("responses")
                            .where("requestId", isEqualTo: doc.id)
                            .snapshots(),

                        builder: (context, responseSnap) {

                          if (!responseSnap.hasData ||
                              responseSnap.data!.docs.isEmpty) {
                            return const Text("No donors yet");
                          }

                          final responses = responseSnap.data!.docs;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text(
                                "Interested Donors:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),

                              ...responses.map((res) {

                                final r =
                                    res.data() as Map<String, dynamic>;
                                final isAccepted =
                                    r["donorId"] == acceptedDonorId;

                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    r["donorName"] ?? "Donor",
                                    style: TextStyle(
                                      fontWeight: isAccepted
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isAccepted
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                  ),

                                  trailing: isAccepted
                                      ? const Text("Accepted",
                                          style: TextStyle(
                                              color: Colors.green))
                                      : acceptedDonorId == null
                                          ? ElevatedButton(
                                              onPressed: () async {

                                                await FirebaseFirestore.instance
                                                    .collection("emergency_requests")
                                                    .doc(doc.id)
                                                    .update({
                                                  "acceptedDonorId":
                                                      r["donorId"],
                                                });

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          "Donor accepted")),
                                                );
                                              },
                                              child: const Text("Accept"),
                                            )
                                          : null,
                                );
                              }).toList(),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      // ACTIONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          if (!isCompleted)
                            IconButton(
                              icon: const Icon(Icons.check,
                                  color: Colors.green),
                              onPressed: () {
                                _markCompleted(context, doc.id);
                              },
                            ),

                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () {
                              _deleteRequest(context, doc.id);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _markCompleted(BuildContext context, String id) async {
    await FirebaseFirestore.instance
        .collection("emergency_requests")
        .doc(id)
        .update({"status": "completed"});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Marked as completed")),
    );
  }

  void _deleteRequest(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Request"),
        content: const Text("Have you received blood?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection("emergency_requests")
                  .doc(id)
                  .delete();

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Request deleted")),
              );
            },
            child: const Text("Delete",
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}