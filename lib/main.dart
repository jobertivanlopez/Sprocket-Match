import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SprocketMatchDashboard(),
  ));
}

class SprocketMatchDashboard extends StatefulWidget {
  const SprocketMatchDashboard({super.key});

  @override
  State<SprocketMatchDashboard> createState() =>
      _SprocketMatchDashboardState();
}

class _SprocketMatchDashboardState extends State<SprocketMatchDashboard> {
  final List<int> weightOptions = [for (var i = 40; i <= 150; i += 5) i];
  final List<String> tireSizes = [
    '70/90-17', '80/90-17', '90/90-17', '100/80-17',
    '110/80-17', '120/70-17', '130/70-17', '140/70-17',
    '90/80-17', '100/90-17'
  ];
  final List<String> roadConditions = ['Uphill', 'Downhill', 'Straight'];

  int? selectedDriverWeight;
  int? selectedBackrideWeight;
  String? selectedFrontTire;
  String? selectedRearTire;
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
            const Text(
              'Sprocket Match',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildDropdownCard<int>(
              icon: Icons.person,
              title: 'Weight of Driver',
              value: selectedDriverWeight,
              items: weightOptions,
              unit: 'kg',
              onChanged: (val) => setState(() => selectedDriverWeight = val),
            ),
            _buildDropdownCard<int>(
              icon: Icons.person_add,
              title: 'Weight of BackRide',
              value: selectedBackrideWeight,
              items: weightOptions,
              unit: 'kg',
              onChanged: (val) => setState(() => selectedBackrideWeight = val),
            ),
            _buildDropdownCard<String>(
              icon: Icons.sync_alt,
              title: 'Tire Size (Front)',
              value: selectedFrontTire,
              items: tireSizes,
              onChanged: (val) => setState(() => selectedFrontTire = val),
            ),
            _buildDropdownCard<String>(
              icon: Icons.sync,
              title: 'Tire Size (Rear)',
              value: selectedRearTire,
              items: tireSizes,
              onChanged: (val) => setState(() => selectedRearTire = val),
            ),
            _buildDropdownCard<String>(
              icon: Icons.terrain,
              title: 'Road Condition',
              value: selectedRoadCondition,
              items: roadConditions,
              onChanged: (val) => setState(() => selectedRoadCondition = val),
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
    String unit = '',
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
                    item is int ? '$item $unit' : item.toString(),
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





