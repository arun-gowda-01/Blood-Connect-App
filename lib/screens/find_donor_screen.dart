import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/karnataka_data.dart';

class FindDonorScreen extends StatefulWidget {
  const FindDonorScreen({super.key});

  @override
  State<FindDonorScreen> createState() =>
      _FindDonorScreenState();
}

class _FindDonorScreenState
    extends State<FindDonorScreen> {

  String? selectedBlood;

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

  void useCurrentLocation() {

    setState(() {

      selectedDistrict =
          "Bengaluru Urban";

      selectedTaluk =
          "Yelahanka";
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content:
            Text(
                "Current location selected"),
      ),
    );
  }

  Stream<QuerySnapshot> donorStream() {

    Query query =
        FirebaseFirestore.instance
            .collection("users");

    if (selectedBlood != null) {

      query =
          query.where(
        "bloodGroup",
        isEqualTo:
            selectedBlood,
      );
    }

    if (selectedDistrict !=
        null) {

      query =
          query.where(
        "district",
        isEqualTo:
            selectedDistrict,
      );
    }

    if (selectedTaluk !=
        null) {

      query =
          query.where(
        "taluk",
        isEqualTo:
            selectedTaluk,
      );
    }

    return query.snapshots();
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        backgroundColor:
            Colors.red,

        title:
            const Text(
                "Find Donor"),
      ),

      body:
          Column(

        children: [

          Container(

            margin:
                const EdgeInsets
                    .all(15),

            padding:
                const EdgeInsets
                    .all(15),

            child:
                Column(

              children: [

                DropdownButtonFormField<String>(

                  value:
                      selectedBlood,

                  decoration:
                      const InputDecoration(
                    labelText:
                        "Blood Group",
                  ),

                  items:
                      bloodGroups
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

                      selectedBlood =
                          v;
                    });
                  },
                ),

                const SizedBox(
                    height:
                        15),

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
                        15),

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
                        15),

                ElevatedButton.icon(

                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        Colors.red,
                  ),

                  onPressed:
                      useCurrentLocation,

                  icon:
                      const Icon(
                    Icons.location_on,
                  ),

                  label:
                      const Text(
                    "Use Current Location",
                  ),
                ),
              ],
            ),
          ),

          Expanded(

            child:
                StreamBuilder<
                    QuerySnapshot>(

              stream:
                  donorStream(),

              builder:
                  (
                context,
                snapshot,
              ) {

                if (!snapshot
                    .hasData) {

                  return const Center(

                    child:
                        CircularProgressIndicator(),
                  );
                }

                final docs =
                    snapshot
                        .data!
                        .docs;

                if (docs
                    .isEmpty) {

                  return const Center(

                    child:
                        Text(
                      "No donors found",
                    ),
                  );
                }

                return ListView.builder(

                  itemCount:
                      docs.length,

                  itemBuilder:
                      (
                    context,
                    index,
                  ) {

                    final data =
                        docs[index]
                                .data()
                            as Map<String,
                                dynamic>;

                    return Card(

                      margin:
                          const EdgeInsets
                              .all(
                                  12),

                      child:
                          ListTile(

                        leading:
                            const CircleAvatar(

                          backgroundColor:
                              Colors.red,

                          child:
                              Icon(
                                Icons.person,
                                color:
                                    Colors.white,
                              ),
                        ),

                        title:
                            Text(
                          data["name"] ??
                              "User",
                        ),

                        subtitle:
                            Column(

                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Text(
                              "🩸 ${data["bloodGroup"] ?? ""}",
                            ),

                            Text(
                              "📍 ${data["district"] ?? ""}",
                            ),

                            Text(
                              "🏠 ${data["taluk"] ?? ""}",
                            ),
                          ],
                        ),

                        trailing:
                            const Icon(
                          Icons.arrow_forward_ios,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}