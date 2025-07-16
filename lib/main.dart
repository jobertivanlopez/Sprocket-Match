import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardWelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/frontbg.jpg',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );
  }
}

// Welcome Screen after splash
class DashboardWelcomeScreen extends StatelessWidget {
  const DashboardWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/frontbg.jpg',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: const Text(
                    'Welcome To Sprocket Match!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SprocketMatchDashboard(),
                        ),
                      );
                    },
                    child: const Text(
                      'Start',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Main Dashboard
class SprocketMatchDashboard extends StatefulWidget {
  const SprocketMatchDashboard({super.key});

  @override
  State<SprocketMatchDashboard> createState() =>
      _SprocketMatchDashboardState();
}

class _SprocketMatchDashboardState extends State<SprocketMatchDashboard> {
  final TextEditingController driverWeightCtrl = TextEditingController();
  final TextEditingController backrideWeightCtrl = TextEditingController();
  final TextEditingController frontTireCtrl = TextEditingController();
  final TextEditingController rearTireCtrl = TextEditingController();
  final TextEditingController engineCcCtrl = TextEditingController();

  final List<String> roadConditions = ['Uphill', 'Downhill', 'Straight'];
  String? selectedRoadCondition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/mylogo.jpg',
              height: 30,
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildInputCard(
                    icon: Icons.person,
                    title: 'Weight of Driver',
                    controller: driverWeightCtrl,
                    hint: 'Enter kg',
                    keyboardType: TextInputType.number,
                  ),
                  _buildInputCard(
                    icon: Icons.person_add,
                    title: 'Weight of BackRide',
                    controller: backrideWeightCtrl,
                    hint: 'Enter kg',
                    keyboardType: TextInputType.number,
                  ),
                  _buildInputCard(
                    icon: Icons.sync_alt,
                    title: 'Tire Size (Front)',
                    controller: frontTireCtrl,
                    hint: 'e.g. 80/90-17',
                    keyboardType: TextInputType.text,
                  ),
                  _buildInputCard(
                    icon: Icons.sync,
                    title: 'Tire Size (Rear)',
                    controller: rearTireCtrl,
                    hint: 'e.g. 90/80-17',
                    keyboardType: TextInputType.text,
                  ),
                  _buildDropdownCard<String>(
                    icon: Icons.terrain,
                    title: 'Road Condition',
                    value: selectedRoadCondition,
                    items: roadConditions,
                    onChanged: (val) => setState(() => selectedRoadCondition = val),
                  ),
                  _buildInputCard(
                    icon: Icons.speed,
                    title: 'Engine Displacement',
                    controller: engineCcCtrl,
                    hint: 'Enter cc',
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (_validateInputs()) {
                    String driverWeight = driverWeightCtrl.text;
                    String backrideWeight = backrideWeightCtrl.text;
                    String frontTire = frontTireCtrl.text;
                    String rearTire = rearTireCtrl.text;
                    String engineCc = engineCcCtrl.text;
                    String? road = selectedRoadCondition;

                    // Get recommendation
                    String sprocketSize = getRecommendedSprocket(
                      driverWeight: int.tryParse(driverWeight) ?? 0,
                      backrideWeight: int.tryParse(backrideWeight) ?? 0,
                      engineCc: int.tryParse(engineCc) ?? 0,
                      roadCondition: road ?? "",
                    );

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Recommended Sprocket'),
                        content: Text(
                          'Driver: $driverWeight kg\n'
                              'BackRide: $backrideWeight kg\n'
                              'Front Tire: $frontTire\n'
                              'Rear Tire: $rearTire\n'
                              'Engine: $engineCc cc\n'
                              'Road: ${road ?? "None"}\n\n'
                              'Recommended Sprocket Size: $sprocketSize',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text(
                  'Sprocket Set',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Validate inputs
  bool _validateInputs() {
    if (driverWeightCtrl.text.isEmpty ||
        backrideWeightCtrl.text.isEmpty ||
        frontTireCtrl.text.isEmpty ||
        rearTireCtrl.text.isEmpty ||
        engineCcCtrl.text.isEmpty ||
        selectedRoadCondition == null) {
      _showErrorDialog("Please fill in all fields.");
      return false;
    }
    return true;
  }

  // Show an error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String getRecommendedSprocket({
    required int driverWeight,
    required int backrideWeight,
    required int engineCc,
    required String roadCondition,
  }) {
    int totalWeight = driverWeight + backrideWeight;

    if (engineCc >= 150) {
      if (roadCondition == 'Uphill') {
        return '14T front / 42T rear';  // For Uphill terrain, use lower gearing
      } else if (roadCondition == 'Downhill') {
        return '15T front / 38T rear';  // For Downhill, use slightly higher gearing
      } else {  // For straight roads
        return '15T front / 40T rear';  // For straight, optimal gearing for speed and balance
      }
    } else if (engineCc >= 110) {
      if (totalWeight > 140) {
        return '13T front / 45T rear';  // For heavier load, use lower gearing
      } else {
        return '14T front / 42T rear';  // Balanced gearing for average weight
      }
    } else {
      // For low CC bikes or heavy loads
      return '13T front / 48T rear';  // For lower displacement, more torque is needed
    }
  }

  Widget _buildInputCard({
    required IconData icon,
    required String title,
    required TextEditingController controller,
    required String hint,
    required TextInputType keyboardType,
  }) {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.brown),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hint,
                border: const UnderlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownCard<T>({
    required IconData icon,
    required String title,
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
  }) {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.brown),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButton<T>(
              hint: const Text("Select"),
              value: value,
              isExpanded: true,
              underline: Container(height: 1, color: Colors.grey.shade300),
              items: items.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    item.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

















