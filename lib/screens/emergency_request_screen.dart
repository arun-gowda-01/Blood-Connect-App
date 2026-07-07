import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/karnataka_data.dart';

class EmergencyRequestScreen extends StatefulWidget {
  const EmergencyRequestScreen({super.key});

  @override
  State<EmergencyRequestScreen> createState() =>
      _EmergencyRequestScreenState();
}

class _EmergencyRequestScreenState
    extends State<EmergencyRequestScreen> {

  final phoneController =
      TextEditingController();

  final messageController =
      TextEditingController();

  bool isLoading = false;

  String? selectedBloodGroup;

  String? selectedDistrict;

  String? selectedTaluk;

  final List<String> bloodGroups = [
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-"
  ];

  Future<Map<String, dynamic>> getEligibility() async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {

      return {
        "canDonate": true,
        "nextDate": null,
      };
    }

    final doc =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

    final data = doc.data();

    if (data == null ||
        data["nextEligibleDate"] ==
            null) {

      return {
        "canDonate": true,
        "nextDate": null,
      };
    }

    final next =
        (data["nextEligibleDate"]
                as Timestamp)
            .toDate();

    return {

      "canDonate":
          DateTime.now()
              .isAfter(next),

      "nextDate": next,
    };
  }

  Future<void> submitRequest() async {

    if (selectedBloodGroup == null ||
        selectedDistrict == null ||
        selectedTaluk == null ||
        phoneController.text.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Fill all fields"),
        ),
      );

      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      final user =
          FirebaseAuth
              .instance
              .currentUser;

      final userDoc =
          await FirebaseFirestore
              .instance
              .collection("users")
              .doc(user!.uid)
              .get();

      final userData =
          userDoc.data();

      await FirebaseFirestore
          .instance
          .collection(
              "emergency_requests")
          .add({

        "userId":
            user.uid,

        "name":
            userData?["name"],

        "bloodGroup":
            selectedBloodGroup,

        "district":
            selectedDistrict,

        "taluk":
            selectedTaluk,

        "phone":
            phoneController.text,

        "message":
            messageController.text,

        "status":
            "active",

        "acceptedDonorId":
            null,

        "createdAt":
            FieldValue
                .serverTimestamp(),
      });

      phoneController.clear();

      messageController.clear();

      selectedBloodGroup =
          null;

      selectedDistrict =
          null;

      selectedTaluk =
          null;

      setState(() {});

      ScaffoldMessenger.of(
              context)
          .showSnackBar(
        const SnackBar(
          content:
              Text(
                  "Request Posted"),
        ),
      );

    } finally {

      setState(() {
        isLoading = false;
      });
    }
  }

  Widget inputField(
      TextEditingController c,
      String hint) {

    return TextField(

      controller: c,

      decoration:
          InputDecoration(

        hintText:
            hint,

        filled:
            true,

        fillColor:
            Colors.grey[100],

        border:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(
                  14),

          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }

  Widget bloodDropdown() {

    return DropdownButtonFormField<String>(

      value:
          selectedBloodGroup,

      items:
          bloodGroups
              .map((e) {

        return DropdownMenuItem<String>(
          value: e,
          child:
              Text(e),
        );

      }).toList(),

      onChanged:
          (String? v) {

        setState(() {

          selectedBloodGroup =
              v;
        });
      },

      decoration:
          InputDecoration(

        filled:
            true,

        fillColor:
            Colors.grey[100],

        hintText:
            "Blood Group",

        border:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(
                  14),

          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context) {

    final currentUser =
        FirebaseAuth
            .instance
            .currentUser;

    return Scaffold(

      backgroundColor:
          const Color(
              0xFFF5F6FA),

      appBar: AppBar(
        title: const Text(
            "Emergency Requests"),

        backgroundColor:
            Colors.red,
      ),

      body:
          SingleChildScrollView(

        child: Column(

          children: [

            Container(

              margin:
                  const EdgeInsets
                      .all(16),

              padding:
                  const EdgeInsets
                      .all(16),

              decoration:
                  BoxDecoration(

                borderRadius:
                    BorderRadius.circular(
                        20),

                gradient:
                    LinearGradient(
                  colors: [

                    Colors.red
                        .shade100,

                    Colors.white,
                  ],
                ),
              ),

              child:
                  Column(

                children: [

                  bloodDropdown(),

                  const SizedBox(
                      height:
                          10),

                  DropdownButtonFormField<String>(

                    value:
                        selectedDistrict,

                    decoration:
                        const InputDecoration(
                      labelText:
                          "District",
                    ),

                    items:
                        karnatakaData
                            .keys
                            .map((e) {

                      return DropdownMenuItem<String>(

                        value:
                            e,

                        child:
                            Text(e),
                      );

                    }).toList(),

                    onChanged:
                        (String? v) {

                      setState(() {

                        selectedDistrict =
                            v;

                        selectedTaluk =
                            null;
                      });
                    },
                  ),

                  const SizedBox(
                      height:
                          10),

                  DropdownButtonFormField<String>(

                    value:
                        selectedTaluk,

                    decoration:
                        const InputDecoration(
                      labelText:
                          "Taluk",
                    ),

                    items:
                        selectedDistrict ==
                                null

                            ? []

                            : karnatakaData[
                                    selectedDistrict]!
                                .map((e) {

                                return DropdownMenuItem<String>(

                                  value:
                                      e,

                                  child:
                                      Text(e),
                                );

                              }).toList(),

                    onChanged:
                        (String? v) {

                      setState(() {

                        selectedTaluk =
                            v;
                      });
                    },
                  ),

                  const SizedBox(
                      height:
                          10),

                  inputField(
                    phoneController,
                    "Contact Number",
                  ),

                  const SizedBox(
                      height:
                          10),

                  inputField(
                    messageController,
                    "Message",
                  ),

                  const SizedBox(
                      height:
                          15),

                  SizedBox(

                    width:
                        double.infinity,

                    child:
                        ElevatedButton(

                      onPressed:
                          isLoading
                              ? null
                              : submitRequest,

                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            Colors.red,
                      ),

                      child:
                          const Text(
                        "Post Emergency Request",
                      ),
                    ),
                  ),
                ],
              ),
            ),

            StreamBuilder<
                QuerySnapshot>(

              stream:
                  FirebaseFirestore
                      .instance
                      .collection(
                          "emergency_requests")
                      .orderBy(
                        "createdAt",
                        descending:
                            true,
                      )
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

                final requests =
                    snapshot
                        .data!
                        .docs;

                return ListView.builder(

                  shrinkWrap:
                      true,

                  physics:
                      const NeverScrollableScrollPhysics(),

                  itemCount:
                      requests.length,

                  itemBuilder:
                      (context,
                          index) {

                    final doc =
                        requests[index];

                    final data =
                        doc.data()
                            as Map<String,
                                dynamic>;

                    return Card(

                      margin:
                          const EdgeInsets
                              .all(12),

                      child:
                          Padding(

                        padding:
                            const EdgeInsets
                                .all(15),

                        child:
                            Column(

                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Text(
                              data["name"],

                              style:
                                  const TextStyle(
                                fontSize:
                                    18,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            Text(
                              "🩸 ${data["bloodGroup"]}",
                            ),

                            Text(
                              "📍 ${data["district"]}",
                            ),

                            Text(
                              "🏠 ${data["taluk"]}",
                            ),

                            if (data["message"] != "")

                              Text(
                                data["message"],
                              ),

                            const SizedBox(
                                height:
                                    10),

                            StreamBuilder<
                                QuerySnapshot>(

                              stream:
                                  FirebaseFirestore
                                      .instance
                                      .collection(
                                          "responses")
                                      .where(
                                        "requestId",
                                        isEqualTo:
                                            doc.id,
                                      )
                                      .where(
                                        "donorId",
                                        isEqualTo:
                                            currentUser!
                                                .uid,
                                      )
                                      .snapshots(),

                              builder:
                                  (context,
                                      snap) {

                                final sent =
                                    snap.hasData &&
                                        snap
                                            .data!
                                            .docs
                                            .isNotEmpty;

                                return FutureBuilder(

                                  future:
                                      getEligibility(),

                                  builder:
                                      (
                                    context,
                                    e,
                                  ) {

                                    if (!e
                                        .hasData) {

                                      return const SizedBox();
                                    }

                                    final canDonate =
                                        e.data![
                                            "canDonate"];

                                    final next =
                                        e.data![
                                            "nextDate"];

                                    return Column(

                                      children: [

                                        if (!canDonate)

                                          Container(

                                            width:
                                                double.infinity,

                                            padding:
                                                const EdgeInsets.all(
                                                    10),

                                            color:
                                                Colors.orange.shade100,

                                            child:
                                                Text(

                                              "Next eligible donation date:\n${next.day}/${next.month}/${next.year}",

                                              textAlign:
                                                  TextAlign.center,
                                            ),
                                          ),

                                        const SizedBox(
                                            height:
                                                10),

                                        SizedBox(

                                          width:
                                              double.infinity,

                                          child:
                                              ElevatedButton(

                                            onPressed:
                                                sent ||
                                                        !canDonate

                                                    ? null

                                                    : () async {

                                                        final donor =
                                                            await FirebaseFirestore.instance.collection("users").doc(currentUser.uid).get();

                                                        final d =
                                                            donor.data();

                                                        await FirebaseFirestore.instance.collection("responses").doc("${doc.id}_${currentUser.uid}").set({

                                                          "requestId":
                                                              doc.id,

                                                          "donorId":
                                                              currentUser.uid,

                                                          "donorName":
                                                              d?["name"],

                                                          "donorPhone":
                                                              d?["phone"],

                                                          "bloodGroup":
                                                              d?["bloodGroup"],

                                                          "status":
                                                              "pending",

                                                          "createdAt":
                                                              FieldValue.serverTimestamp(),
                                                        });

                                                        setState(() {});
                                                      },

                                            style:
                                                ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  sent
                                                      ? Colors.grey
                                                      : Colors.red,
                                            ),

                                            child:
                                                Text(

                                              sent
                                                  ? "Request Sent"
                                                  : canDonate
                                                      ? "I Can Donate"
                                                      : "Not Eligible",
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}