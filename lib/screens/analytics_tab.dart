import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({super.key});

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab> {
  String selectedRange = 'day';
  Map<DateTime, int> userData = {};

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final now = DateTime.now();
    late DateTime start;

    if (selectedRange == 'day') {
      start = DateTime(now.year, now.month, now.day);
    } else if (selectedRange == 'week') {
      start = now.subtract(const Duration(days: 7));
    } else {
      start = now.subtract(const Duration(days: 30));
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .get();

    Map<DateTime, int> counts = {};

    for (var doc in snapshot.docs) {
      final ts = (doc['createdAt'] as Timestamp).toDate();
      final day = DateTime(ts.year, ts.month, ts.day);
      counts[day] = (counts[day] ?? 0) + 1;
    }

    setState(() {
      userData = counts;
    });
  }

  Widget buildUserBarChart() {
  final sortedDates = userData.keys.toList()..sort();

  if (userData.isEmpty) {
    return const SizedBox(
      height: 200,
      child: Center(child: Text("No user data available")),
    );
  }

  // Convert to index-based bar groups
  final barGroups = <BarChartGroupData>[];
  final labels = <String>[];

  for (int i = 0; i < sortedDates.length; i++) {
    final date = sortedDates[i];
    final count = userData[date] ?? 0;

    barGroups.add(
      BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: count.toDouble(),
            width: 12,
            color: Colors.purple,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );

    labels.add("${date.month}/${date.day}");
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 12, bottom: 8),
        child: Text(
          "User Signup History",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 250,
        child: BarChart(
          BarChartData(
            barGroups: barGroups,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    int index = value.toInt();
                    return Text(
                      index >= 0 && index < labels.length ? labels[index] : '',
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                  reservedSize: 32,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, _) {
                    return Text('${value.toInt()}', style: TextStyle(fontSize: 10));
                  },
                ),
              ),
            ),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: true),
          ),
        ),
      ),
    ],
  );
}
  Widget _buildCountCard(String label, String collectionName) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _statCard(label, '...');
        }
        final count = snapshot.data!.docs.length;
        return _statCard(label, count.toString());
      },
    );
  }

  Widget _statCard(String label, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Metric Cards
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCountCard('Requests', 'receiver_requests'),
              _buildCountCard('Donations', 'donations'),
              _buildCountCard('Users', 'users'),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButton<String>(
            value: selectedRange,
            isExpanded: true,
            items: ['day', 'week', 'month'].map((range) {
              return DropdownMenuItem(value: range, child: Text(range.toUpperCase()));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedRange = value;
                });
                fetchUserData();
              }
            },
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: buildUserBarChart(),
          ),
        ),
      ],
    );
  }
}