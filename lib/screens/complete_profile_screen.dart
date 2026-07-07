import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main_navigation.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();

  String? selectedBloodGroup;

  final List<String> bloodGroups = [
    "A+","A-","B+","B-","AB+","AB-","O+","O-"
  ];

  bool isLoading = false;

  Future<void> saveProfile() async {

    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        cityController.text.isEmpty ||
        selectedBloodGroup == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    setState(() => isLoading = true);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .set({
      "name": nameController.text.trim(),
      "phone": phoneController.text.trim(),
      "city": cityController.text.trim(),
      "bloodGroup": selectedBloodGroup,
    });

    setState(() => isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainNavigation(),
      ),
    );
  }

  Widget inputField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget bloodDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedBloodGroup,
      hint: const Text("Select Blood Group"),
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
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Profile"),
        backgroundColor: Colors.red,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            inputField(nameController, "Name"),
            const SizedBox(height: 10),

            inputField(phoneController, "Phone"),
            const SizedBox(height: 10),

            inputField(cityController, "City"),
            const SizedBox(height: 10),

            bloodDropdown(),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading ? null : saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save & Continue"),
            ),
          ],
        ),
      ),
    );
  }
}