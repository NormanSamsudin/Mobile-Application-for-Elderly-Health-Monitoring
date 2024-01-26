import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData2 {
  String status;
  int count;
  Color color;

  ChartData2({required this.status, required this.count, required this.color});
}

Map<String, List<ChartData2>> processDummyData(
    List<Map<String, dynamic>> data) {
  Map<String, Map<String, int>> statusCountPerName = {};

  for (var item in data) {
    String name = item['name'];
    String status = item['status'];

    statusCountPerName.putIfAbsent(name, () => {});
    statusCountPerName[name]![status] =
        (statusCountPerName[name]![status] ?? 0) + 1;
  }

  Map<String, List<ChartData2>> chartDataPerName = {};
  statusCountPerName.forEach((name, statusCount) {
    chartDataPerName[name] = statusCount.entries
        .map((entry) => ChartData2(
              status: entry.key,
              count: entry.value,
              color: entry.key == 'taken'
                  ? Colors.purple
                  : const Color.fromARGB(157, 158, 158, 158),
            ))
        .toList();
  });

  return chartDataPerName;
}

class medicineCircle extends StatefulWidget {
  const medicineCircle({super.key});

  @override
  State<medicineCircle> createState() => _medicationHistoryState();
}

class _medicationHistoryState extends State<medicineCircle> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('medicationLog').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        var chartDataPerName = processDummyData(snapshot.data!.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());

        return ListView(
          scrollDirection: Axis.horizontal,
          children: chartDataPerName.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MedicinePieChart(chartData: entry.value),
                  Text(entry.key,
                      style: GoogleFonts.lexend(
                          fontSize: 13, fontWeight: FontWeight.w400)),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class MedicinePieChart extends StatelessWidget {
  final List<ChartData2> chartData;

  MedicinePieChart({Key? key, required this.chartData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalCount = chartData.fold(0, (sum, item) => sum + item.count);
    int takenCount = chartData
        .firstWhere((item) => item.status == 'taken',
            orElse: () =>
                ChartData2(status: 'taken', count: 0, color: Colors.green))
        .count;
    double takenPercentage =
        totalCount > 0 ? (takenCount / totalCount * 100) : 0;

    return Container(
      height: 90, // Adjust the height as needed
      width: 90, // Adjust the width as needed
      child: SfCircularChart(
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
            widget: Container(
              child: Text(
                '${takenPercentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
        legend: const Legend(
          isVisible: false,
          width: '50%',
          alignment: ChartAlignment.near,
          position: LegendPosition.right,
          offset: Offset(40, 0),
          itemPadding: 5,
        ),
        series: <CircularSeries>[
          DoughnutSeries<ChartData2, String>(
            innerRadius: '75%',
            dataSource: chartData,
            pointColorMapper: (ChartData2 data, _) => data.color,
            xValueMapper: (ChartData2 data, _) => data.status,
            yValueMapper: (ChartData2 data, _) => data.count,
            radius: '130%',
          ),
        ],
      ),
    );
  }
}
