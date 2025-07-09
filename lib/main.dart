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
  State<SprocketMatchDashboard> createState() => _SprocketMatchDashboardState();
}

class _SprocketMatchDashboardState extends State<SprocketMatchDashboard> {
  final List<int> weightOptions = [for (var i = 40; i <= 150; i += 5) i];
  final List<String> tireSizes = [
    '70/90-17', '80/90-17', '90/90-17', '100/80-17',
    '110/80-17', '120/70-17', '130/70-17', '140/70-17',
    '90/80-17', '100/90-17'
  ];
  final List<String> roadConditions = ['Uphill', 'Downhill', 'Straight'];

  int? selectedDriverWeight = 65;
  int? selectedBackrideWeight = 50;
  String? selectedFrontTire = '80/90-17';
  String? selectedRearTire = '90/80-17';
  String? selectedRoadCondition = 'Straight';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B4DED),
        title: const Text('Sprocket Match Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildDropdownCard<int>(
              title: 'Weight of Driver',
              value: selectedDriverWeight,
              items: weightOptions,
              unit: 'kg',
              onChanged: (val) => setState(() => selectedDriverWeight = val),
            ),
            _buildDropdownCard<int>(
              title: 'Weight of BackRide',
              value: selectedBackrideWeight,
              items: weightOptions,
              unit: 'kg',
              onChanged: (val) => setState(() => selectedBackrideWeight = val),
            ),
            _buildDropdownCard<String>(
              title: 'Tire Size (Front)',
              value: selectedFrontTire,
              items: tireSizes,
              onChanged: (val) => setState(() => selectedFrontTire = val),
            ),
            _buildDropdownCard<String>(
              title: 'Tire Size (Rear)',
              value: selectedRearTire,
              items: tireSizes,
              onChanged: (val) => setState(() => selectedRearTire = val),
            ),
            _buildDropdownCard<String>(
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
    required String title,
    required T? value,
    required List<T> items,
    String unit = '',
    required void Function(T?) onChanged,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.brown,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButton<T>(
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


