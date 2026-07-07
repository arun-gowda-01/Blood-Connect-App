import 'package:flutter/material.dart';

class BloodInfoScreen extends StatelessWidget {
  const BloodInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blood Donation Guide"),
        backgroundColor: Colors.red,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          _sectionTitle("🩸 Who Can Donate Blood?"),

          _infoBox(
            "Eligibility Criteria",
            "• Age: 18–65 years\n"
            "• Weight: Minimum 50 kg\n"
            "• Hemoglobin: At least 12.5 g/dL\n"
            "• Must be physically and mentally healthy\n"
            "• No active infections or chronic illness\n"
            "• Normal pulse, BP and body temperature",
          ),

          _sectionTitle("❌ Who Should NOT Donate?"),

          _infoBox(
            "Not Eligible",
            "• Pregnant or breastfeeding women\n"
            "• Recent surgery (within 6 months)\n"
            "• History of hepatitis, HIV, or serious infections\n"
            "• Low hemoglobin or anemia\n"
            "• Recent tattoo or piercing (within 6 months)\n"
            "• Fever, cold, or illness",
          ),

          _sectionTitle("💪 Benefits of Donating Blood"),

          _infoBox(
            "Health Benefits",
            "• Reduces risk of heart diseases\n"
            "• Helps maintain iron levels\n"
            "• Stimulates production of new blood cells\n"
            "• Free health checkup\n"
            "• Saves lives ❤️",
          ),

          _sectionTitle("⏱️ How Often Can You Donate?"),

          _infoBox(
            "Donation Frequency",
            "• Men: Every 3 months\n"
            "• Women: Every 4 months\n"
            "• Platelets: Every 2 weeks\n"
            "• Plasma: Every 28 days",
          ),

          _sectionTitle("🧪 Types of Blood Donation"),

          _infoBox(
            "Donation Types",
            "• Whole Blood Donation (most common)\n"
            "• Platelet Donation (for cancer patients)\n"
            "• Plasma Donation (for critical care)\n"
            "• Double Red Cell Donation",
          ),

          _sectionTitle("🔄 Donation Process"),

          _infoBox(
            "Step-by-Step",
            "1. Registration & ID verification\n"
            "2. Medical screening\n"
            "3. Hemoglobin check\n"
            "4. Blood donation (10–15 mins)\n"
            "5. Rest & refreshments\n"
            "6. Certificate provided",
          ),

          _sectionTitle("⚠️ Before Donation"),

          _infoBox(
            "Preparation",
            "• Eat healthy meal before donation\n"
            "• Drink plenty of water\n"
            "• Avoid alcohol 24 hours prior\n"
            "• Get proper sleep",
          ),

          _sectionTitle("🛌 After Donation"),

          _infoBox(
            "Precautions",
            "• Rest for 10–15 minutes\n"
            "• Drink fluids\n"
            "• Avoid heavy exercise for 24 hours\n"
            "• Do not smoke immediately",
          ),

          _sectionTitle("❓ FAQs"),

          _infoBox(
            "Common Questions",
            "Q: Is blood donation painful?\n"
            "A: Only slight discomfort.\n\n"
            "Q: Is it safe?\n"
            "A: Yes, completely safe and sterile.\n\n"
            "Q: How much blood is taken?\n"
            "A: Around 350–450 ml.\n\n"
            "Q: Can I donate if I take medicines?\n"
            "A: Depends on medication, consult doctor.",
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // 🔴 SECTION TITLE
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 📦 INFO BOX
  Widget _infoBox(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 6),
          Text(content,
              style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}