import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/widgets/reportWidget/medicineCircle.dart';
import 'package:seniorconnect/widgets/tableRow.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class medicationHistory extends StatefulWidget {
  const medicationHistory({super.key});

  @override
  State<medicationHistory> createState() => _medicationHistoryState();
}

class _medicationHistoryState extends State<medicationHistory> {
  String? selectedMonth;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medication History'),
      ),
      body: Container(
        color: Color.fromARGB(255, 192, 233, 252),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(height: 125, child: medicineCircle()),
              dropDownButton(),
              tableMedication(),
            ],
          ),
        ),
      ),
    );
  }

  Widget dropDownButton() {
    return Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        height: 420,
        child: ListView(children: [
          barChart(),
          Row(
            children: [
              const Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text('Medication History List'),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Container(
                  child: DropdownButton<String>(
                    value: selectedMonth,
                    items: <String>[
                      'January',
                      'February',
                      'March',
                      'April',
                      'May',
                      'June',
                      'July',
                      'August',
                      'September',
                      'October',
                      'November',
                      'December'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text("Select Month"),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMonth = newValue;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ]));
  }

  int _getMonthNumber(String? monthName) {
    // Convert month name to month number
    return [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December'
        ].indexOf(monthName!) +
        1;
  }

  Widget tableMedication() {
    return StreamBuilder<QuerySnapshot>(
      stream: selectedMonth == null
          ? FirebaseFirestore.instance.collection('medicationLog').snapshots()
          : FirebaseFirestore.instance
              .collection('medicationLog')
              .where('time',
                  isGreaterThanOrEqualTo: DateTime(
                      DateTime.now().year, _getMonthNumber(selectedMonth), 1))
              .where('time',
                  isLessThan: DateTime(DateTime.now().year,
                      _getMonthNumber(selectedMonth) + 1, 1))
              .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255)),
                child: Center(child: Text('Loading...')));
          default:
            List<TableRow> eventWidgets =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              String name = data['name'];
              Timestamp time = data['time'];
              DateTime date = time.toDate();
              String status = data['status'];

              return TableRow(children: [
                tableRow('$name'),
                tableRow('${date.toLocal()}'), // Display local time
                tableRow('$status')
              ]);
            }).toList();

            eventWidgets.insert(
                0,
                TableRow(children: [
                  tableRow('Name'),
                  tableRow('Date'),
                  tableRow('Status')
                ]));

            return Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255)),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Table(
                  columnWidths: const {
                    0: FixedColumnWidth(150),
                    1: FlexColumnWidth(),
                    2: FlexColumnWidth()
                  },
                  children: eventWidgets,
                  border: TableBorder.all(
                    width: 1,
                    color: darkCyan,
                    style: BorderStyle.solid,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}

// Widget barChart() {
//   final List<ChartData3> chartData = [
//     ChartData3('January', 10),
//     ChartData3('February', 15),
//     ChartData3('March', 7),
//     ChartData3('April', 20),
//     ChartData3('May', 25),
//   ];

//   return Center(
//     child: Container(
//       child: SfCartesianChart(
//         primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Month')),
//         primaryYAxis: NumericAxis(title: AxisTitle(text: 'Quantity')),
//         series: <CartesianSeries<ChartData3, String>>[
//           ColumnSeries<ChartData3, String>(
//             dataSource: chartData,
//             xValueMapper: (ChartData3 data, _) => data.x,
//             yValueMapper: (ChartData3 data, _) => data.y,
//             name: 'Medicine Intake',
//           )
//         ],
//         tooltipBehavior: TooltipBehavior(enable: true),
//       ),
//     ),
//   );
// }

Widget barChart() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('medicationLog').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      final data = processMedicationData(snapshot.data!.docs);
      return buildChart(data);
    },
  );
}

// List<ChartData3> processMedicationData(List<QueryDocumentSnapshot> docs) {
//   Map<String, double> medicationCounts = {};

//   for (var doc in docs) {
//     var data = doc.data() as Map<String, dynamic>;
//     if (data['status'] == 'taken') {
//       DateTime time = (data['time'] as Timestamp).toDate();
//       String month = getMonthName(time);
//       medicationCounts[month] = (medicationCounts[month] ?? 0) + 1;
//     }
//   }

//   return medicationCounts.entries
//       .map((entry) => ChartData3(entry.key, entry.value))
//       .toList();
// }

List<ChartData3> processMedicationData(List<QueryDocumentSnapshot> docs) {
  Map<String, double> medicationCounts = {};

  // Initialize medicationCounts with all months and zero values
  List<String> months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'
  ];
  for (var month in months) {
    medicationCounts[month] = 0;
  }

  // Update counts for months with actual data
  for (var doc in docs) {
    var data = doc.data() as Map<String, dynamic>;
    if (data['status'] == 'taken') {
      DateTime time = (data['time'] as Timestamp).toDate();
      String month = getMonthName(time);
      medicationCounts[month] = (medicationCounts[month] ?? 0) + 1;
    }
  }

  return medicationCounts.entries
      .map((entry) => ChartData3(entry.key, entry.value))
      .toList();
}

String getMonthName(DateTime dateTime) {
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'June',
    'Jul',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec'
  ];
  return months[dateTime.month - 1];
}

Widget buildChart(List<ChartData3> chartData) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color.fromARGB(255, 255, 255, 255)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SfCartesianChart(
            title: ChartTitle(
                text: 'Total Medicine Taken Monthly',
                textStyle: GoogleFonts.lexend(
                    fontWeight: FontWeight.normal, fontSize: 15)),
            // primaryXAxis: CategoryAxis(
            //   title: AxisTitle(text: 'Month'),
            //   //axisLine: cMajorGridLines(width: 0),
            //   ),
            primaryXAxis: CategoryAxis(
              title: AxisTitle(
                  text: 'Month',
                  textStyle: GoogleFonts.lexend(
                      fontSize: 13, fontWeight: FontWeight.normal)),
              borderWidth: 0,
              axisLine: const AxisLine(width: 0, dashArray: <double>[100, 100]),
              majorGridLines: MajorGridLines(width: 0),
              borderColor: Colors.white,
              isVisible: true,
            ),
            // primaryYAxis: NumericAxis(title: AxisTitle(text: 'Quantity')),
            primaryYAxis: NumericAxis(
                title: AxisTitle(
                    text: 'Quantity',
                    textStyle: GoogleFonts.lexend(
                        fontSize: 13, fontWeight: FontWeight.normal)),
                borderWidth: 0,
                axisLine: const AxisLine(width: 0),
                majorGridLines: const MajorGridLines(width: 0),
                borderColor: Colors.white,
                isVisible: true,
                minorGridLines: const MinorGridLines(width: 0),
                minimum: 0,
                minorTickLines: const MinorTickLines(width: 0)),
            series: <CartesianSeries<ChartData3, String>>[
              ColumnSeries<ChartData3, String>(
                color: Colors.purple,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                dataSource: chartData,
                trackBorderWidth: 5,
                borderWidth: 15,
                width: 0.5,
                xValueMapper: (ChartData3 data, _) => data.x,
                yValueMapper: (ChartData3 data, _) => data.y,
                name: 'Medicine Intake',
              )
            ],
            tooltipBehavior: TooltipBehavior(enable: true),
          ),
        ),
      ),
    ),
  );
}

class ChartData3 {
  ChartData3(this.x, this.y);
  final String x;
  final double y;
}
