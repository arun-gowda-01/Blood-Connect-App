import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  String selectedBloodGroup = "A+";

  final List<String> bloodGroups = [
    "A+","A-","B+","B-","AB+","AB-","O+","O-"
  ];

  Future<void> registerUser() async {
    try {

      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = userCredential.user;

      if (user != null) {

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .set({

          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": phoneController.text.trim(),
          "city": cityController.text.trim(),
          "bloodGroup": selectedBloodGroup,
          "isAvailable": true,
          "createdAt": Timestamp.now(),

        });

      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Successful")),
      );

      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {

      String message = "Registration failed";

      if (e.code == 'email-already-in-use') {
        message = "Email already registered";
      }

      if (e.code == 'weak-password') {
        message = "Password must be at least 6 characters";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.red,
      ),

      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(

            children: [

              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Full Name",
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "Phone Number",
                  prefixIcon: Icon(Icons.phone),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  hintText: "City",
                  prefixIcon: Icon(Icons.location_city),
                ),
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: selectedBloodGroup,
                items: bloodGroups.map((group) {

                  return DropdownMenuItem(
                    value: group,
                    child: Text(group),
                  );

                }).toList(),

                onChanged: (value) {

                  setState(() {
                    selectedBloodGroup = value!;
                  });

                },

                decoration: const InputDecoration(
                  labelText: "Blood Group",
                  prefixIcon: Icon(Icons.bloodtype),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: registerUser,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                ),

                child: const Text("Create Account"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}