import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/karnataka_data.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  final nameController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final cityController =
      TextEditingController();

  bool isLoading = false;

  String? selectedBloodGroup;

  String? selectedDistrict;

  String? selectedTaluk;

  DateTime? lastDonationDate;

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

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

    final data =
        doc.data();

    if (data == null) return;

    nameController.text =
        data["name"] ?? "";

    phoneController.text =
        data["phone"] ?? "";

    cityController.text =
        data["city"] ?? "";

    selectedBloodGroup =
        data["bloodGroup"];

    selectedDistrict =
        data["district"];

    selectedTaluk =
        data["taluk"];

    if (data["lastDonationDate"] !=
        null) {

      lastDonationDate =
          (data["lastDonationDate"]
                  as Timestamp)
              .toDate();
    }

    setState(() {});
  }

  Future<void> pickDate() async {

    final date =
        await showDatePicker(

      context:
          context,

      initialDate:
          DateTime.now(),

      firstDate:
          DateTime(2020),

      lastDate:
          DateTime.now(),
    );

    if (date != null) {

      setState(() {

        lastDonationDate =
            date;
      });
    }
  }

  void useCurrentLocation() {

    setState(() {

      selectedDistrict =
          "Bengaluru Urban";

      selectedTaluk =
          "Yelahanka";

      cityController.text =
          "Current Location";
    });
  }

  Future<void> updateProfile() async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    setState(() {
      isLoading = true;
    });

    DateTime? nextDate;

    if (lastDonationDate !=
        null) {

      nextDate =
          lastDonationDate!
              .add(
        const Duration(
            days: 90),
      );
    }

    await FirebaseFirestore
        .instance
        .collection("users")
        .doc(user.uid)
        .update({

      "name":
          nameController.text,

      "phone":
          phoneController.text,

      "city":
          cityController.text,

      "district":
          selectedDistrict,

      "taluk":
          selectedTaluk,

      "bloodGroup":
          selectedBloodGroup,

      "lastDonationDate":
          lastDonationDate,

      "nextEligibleDate":
          nextDate,
    });

    setState(() {
      isLoading = false;
    });

    Navigator.pop(context);
  }

  Widget field(
      TextEditingController c,
      String h,
      IconData i) {

    return TextField(

      controller: c,

      decoration:
          InputDecoration(

        hintText:
            h,

        prefixIcon:
            Icon(i),

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

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor:
            Colors.red,

        title:
            const Text(
                "Edit Profile"),
      ),

      body:
          SingleChildScrollView(

        padding:
            const EdgeInsets.all(
                20),

        child: Column(

          children: [

            field(
              nameController,
              "Name",
              Icons.person,
            ),

            const SizedBox(
                height: 15),

            field(
              phoneController,
              "Phone",
              Icons.phone,
            ),

            const SizedBox(
                height: 15),

            field(
              cityController,
              "City",
              Icons.location_city,
            ),

            const SizedBox(
                height: 15),

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
                height: 15),

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
                height: 15),

            DropdownButtonFormField<String>(

              value:
                  selectedBloodGroup,

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

                  selectedBloodGroup =
                      v;
                });
              },
            ),

            const SizedBox(
                height: 20),

            ElevatedButton.icon(

              onPressed:
                  useCurrentLocation,

              icon:
                  const Icon(
                      Icons.my_location),

              label:
                  const Text(
                "Use Current Location",
              ),
            ),

            const SizedBox(
                height: 20),

            ListTile(

              title:
                  const Text(
                "Last Donation Date",
              ),

              subtitle:
                  Text(

                lastDonationDate ==
                        null

                    ? "Not Added"

                    : "${lastDonationDate!.day}/${lastDonationDate!.month}/${lastDonationDate!.year}",
              ),

              trailing:
                  const Icon(
                Icons.calendar_today,
              ),

              onTap:
                  pickDate,
            ),

            const SizedBox(
                height: 25),

            SizedBox(

              width:
                  double.infinity,

              height:
                  55,

              child:
                  ElevatedButton(

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red,
                ),

                onPressed:
                    isLoading
                        ? null
                        : updateProfile,

                child:
                    const Text(
                  "Update Profile",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}