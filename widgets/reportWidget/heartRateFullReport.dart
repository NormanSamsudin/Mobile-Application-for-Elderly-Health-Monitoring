import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/widgets/tableRow.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as chart;

class heartRateFullReport extends StatefulWidget {
  @override
  State<heartRateFullReport> createState() => _heartRateFullReportState();
}

class _heartRateFullReportState extends State<heartRateFullReport> {
  List<Map<String, dynamic>> data = [
    {"id": 1, "date": "2024-01-15", "min": 70, "max": 90},
    {"id": 2, "date": "2024-02-20", "min": 65, "max": 91},
    // Add more data as needed
  ];

  List<MonthlyChartData> aggregateWeeklyDataToMonthly(
      List<ChartData2> weeklyData) {
    // Implement your logic to aggregate weekly data into monthly data
    // Example:
    return [
      MonthlyChartData('Jan', 65, 95),
      MonthlyChartData('Feb', 0, 0),
      MonthlyChartData('Mar', 0, 0),
      MonthlyChartData('Jun', 0, 0),
      MonthlyChartData('Jul', 0, 0),
      MonthlyChartData('Aug', 0, 0),
      MonthlyChartData('Sep', 0, 0),
      MonthlyChartData('Okt', 0, 0),
      MonthlyChartData('Nov', 0, 0),
      MonthlyChartData('Dec', 0, 0),
    ];
  }

  String selectedMonth = 'January';

  @override
  Widget build(BuildContext context) {
    final List<ChartData2> weeklyData = <ChartData2>[
      ChartData2('Mon', 70, 90),
      ChartData2('Tue', 65, 91),
    ];
    final List<MonthlyChartData> monthlyData =
        aggregateWeeklyDataToMonthly(weeklyData);

    return Scaffold(
      appBar: AppBar(
        title: Text('Heart Rate Full Report'),
      ),
      backgroundColor: Color.fromARGB(255, 192, 233, 252),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
              child: Container(
                height: 250,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: Text(
                        'Average Heart Rate Report Annually',
                        style: GoogleFonts.lexend(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                    ),
                    Container(
                      height: 200,
                      child: chart.SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        primaryXAxis: const chart.CategoryAxis(
                          axisLine:
                              chart.AxisLine(width: 1, color: Colors.black),
                          majorGridLines: chart.MajorGridLines(width: 0),
                        ),
                        primaryYAxis: const chart.NumericAxis(
                          borderWidth: 0,
                          minimum: 40,
                          maximum: 130,
                          axisLine:
                              chart.AxisLine(width: 1, color: Colors.black),
                          majorGridLines: chart.MajorGridLines(
                              width: 0, color: Colors.white),
                        ),
                        series: <chart.CartesianSeries>[
                          chart.RangeColumnSeries<MonthlyChartData, String>(
                            color: Colors.purple,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            trackBorderWidth: 5,
                            borderWidth: 15,
                            width: 0.3,
                            dataSource: monthlyData,
                            xValueMapper: (MonthlyChartData data, _) =>
                                data.month,
                            lowValueMapper: (MonthlyChartData data, _) =>
                                data.low,
                            highValueMapper: (MonthlyChartData data, _) =>
                                data.high,
                          )
                        ],
                        tooltipBehavior: chart.TooltipBehavior(enable: true),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Text(
                      'Heart Rate Report Weekly',
                      style: GoogleFonts.lexend(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    height: 200,
                    child: chart.SfCartesianChart(
                      tooltipBehavior: chart.TooltipBehavior(enable: true),
                      //borderColor: Colors.white,
                      plotAreaBorderWidth: 0,
                      primaryXAxis: const chart.CategoryAxis(
                        axisLine: chart.AxisLine(width: 1, color: Colors.black),
                        majorGridLines: chart.MajorGridLines(width: 0),
                        borderWidth: 0,
                        borderColor: Colors.white,
                        isVisible: true,
                      ),
                      primaryYAxis: const chart.NumericAxis(
                        borderWidth: 0,
                        minimum: 40,
                        maximum: 130,
                        axisLine: chart.AxisLine(width: 1, color: Colors.black),
                        majorGridLines:
                            chart.MajorGridLines(width: 0, color: Colors.white),
                        borderColor: Colors.white,
                        isVisible: true,
                      ),
                      series: <chart.CartesianSeries>[
                        chart.RangeColumnSeries<ChartData2, String>(
                          color: Colors.purple,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          trackBorderWidth: 5,
                          borderWidth: 15,
                          width: 0.3,
                          dataSource: <ChartData2>[
                            ChartData2('Mon', 70, 90),
                            ChartData2('Tue', 65, 91),
                            ChartData2('Wed', 68, 93),
                            ChartData2('Thu', 70, 110),
                            ChartData2('Fri', 65, 93),
                            ChartData2('Sat', 66, 96),
                            ChartData2('Sun', 70, 90),
                          ],
                          xValueMapper: (ChartData2 data, _) => data.x,
                          lowValueMapper: (ChartData2 data, _) => data.low,
                          highValueMapper: (ChartData2 data, _) => data.high,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                    color: Colors.white),
                //height: 390,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButton<String>(
                      value: selectedMonth,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMonth = newValue!;
                          // Update the table based on the selected month
                        });
                      },
                      items: <String>[
                        'January',
                        'February',
                        'March', /* ... other months ... */
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: Table(
                        columnWidths: const {
                          0: FixedColumnWidth(42),
                          1: FlexColumnWidth(),
                          2: FlexColumnWidth(),
                          3: FlexColumnWidth()
                        },
                        children: [
                          TableRow(children: [
                            tableRow('id'),
                            tableRow('Date'),
                            tableRow('Minimum'),
                            tableRow('Maximum')
                          ]),
                          TableRow(children: [
                            tableRow('1'),
                            tableRow('1 Jan 2024'),
                            tableRow('60'),
                            tableRow('100'),
                          ]),
                          TableRow(children: [
                            tableRow('2'),
                            tableRow('2 Jan 2024'),
                            tableRow('62'),
                            tableRow('101'),
                          ]),
                          TableRow(children: [
                            tableRow('3'),
                            tableRow('3 Jan 2024'),
                            tableRow('60'),
                            tableRow('99'),
                          ]),
                          TableRow(children: [
                            tableRow('4'),
                            tableRow('4 Jan 2024'),
                            tableRow('55'),
                            tableRow('95'),
                          ]),
                          TableRow(children: [
                            tableRow('5'),
                            tableRow('5 Jan 2024'),
                            tableRow('60'),
                            tableRow('100'),
                          ]),
                          TableRow(children: [
                            tableRow('6'),
                            tableRow('6 Jan 2024'),
                            tableRow('58'),
                            tableRow('110'),
                          ]),
                          TableRow(children: [
                            tableRow('7'),
                            tableRow('7 Jan 2024'),
                            tableRow('63'),
                            tableRow('105'),
                          ]),
                          TableRow(children: [
                            tableRow('8'),
                            tableRow('8 Jan 2024'),
                            tableRow('60'),
                            tableRow('100'),
                          ]),
                          TableRow(children: [
                            tableRow('6'),
                            tableRow('5 Jan 2024'),
                            tableRow('60'),
                            tableRow('100'),
                          ]),
                        ],
                        border: TableBorder.all(
                          width: 1,
                          color: darkCyan,
                          style: BorderStyle.solid,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<TableRow> _generateTableRows() {
    List<TableRow> rows = [
      TableRow(children: [
        tableRow('ID'),
        tableRow('Date'),
        tableRow('Minimum'),
        tableRow('Maximum')
      ]),
    ];

    for (var rowData in data) {
      // Filter data based on the selected month
      if (rowData['date'].startsWith(_monthToNumber(selectedMonth))) {
        rows.add(TableRow(children: [
          tableRow(rowData['id'].toString()),
          tableRow(rowData['date']),
          tableRow(rowData['min'].toString()),
          tableRow(rowData['max'].toString()),
        ]));
      }
    }

    return rows;
  }

  String _monthToNumber(String month) {
    Map<String, String> monthMap = {
      'January': '01',
      'February': '02',
      'March': '03',
      // Map other months...
    };
    return monthMap[month] ?? '01';
  }
}

class ChartData2 {
  ChartData2(this.x, this.low, this.high);

  final String x;
  final double low;
  final double high;
}

class MonthlyChartData {
  MonthlyChartData(this.month, this.low, this.high);

  final String month;
  final double low;
  final double high;
}
