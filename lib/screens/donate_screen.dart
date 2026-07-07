import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {

  // ❌ REMOVE bloodController
  // final bloodController = TextEditingController();

  final cityController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = false;

  // ✅ BLOOD GROUP DROPDOWN
  String? selectedBloodGroup;

  final List<String> bloodGroups = [
    "A+","A-","B+","B-","AB+","AB-","O+","O-"
  ];

  Future<void> registerDonor() async {

    // ✅ UPDATED VALIDATION
    if (selectedBloodGroup == null ||
        cityController.text.isEmpty ||
        phoneController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set({
        // ✅ SAVE DROPDOWN VALUE
        "bloodGroup": selectedBloodGroup,
        "city": cityController.text.trim(),
        "phone": phoneController.text.trim(),
        "isDonor": true,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You are now a donor ❤️")),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error updating")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget inputField(TextEditingController controller, String hint,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ✅ DROPDOWN WIDGET (SAME UI STYLE)
  Widget bloodDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: selectedBloodGroup,
        decoration: InputDecoration(
          hintText: "Blood Group",
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        items: bloodGroups.map((group) {
          return DropdownMenuItem(
            value: group,
            child: Text(group),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedBloodGroup = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Become a Donor"),
        backgroundColor: Colors.red,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            const Text(
              "Save lives by registering as a donor ❤️",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // ✅ REPLACED TEXTFIELD WITH DROPDOWN
            bloodDropdown(),

            inputField(cityController, "City / Area"),
            inputField(phoneController, "Phone Number",
                type: TextInputType.phone),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : registerDonor,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Register as Donor"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}