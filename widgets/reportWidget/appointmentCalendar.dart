// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:flutter/widgets.dart';

// class appointmentCalendar extends StatefulWidget {
//   const appointmentCalendar({super.key, required this.title});

//   final String title;
//   @override
//   State<appointmentCalendar> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<appointmentCalendar> {
//   DateTime today = DateTime.now();

//   List<String> _selectedDayEvents = [];

//   Map<DateTime, String> events = {
//     DateTime.utc(2024, 1, 10): 'Event 1',
//     DateTime.utc(2024, 1, 15): 'Event 2',
//     // Add more events here
//   };

//   // This function will convert your _appointments map to the format expected by TableCalendar
//   String _getEventForDay(DateTime day) {
//     return events[day] ?? '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection('appointmentLog')
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             }

//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return CircularProgressIndicator();
//             }

//             for (var doc in snapshot.data!.docs) {
//               var data = doc.data() as Map<String, dynamic>;

//               String name = data['name'];
//               Timestamp time = data['time'];

//               DateTime date = DateTime(
//                 time.toDate().year,
//                 time.toDate().month,
//                 time.toDate().day,
//               );

//               // Add to _events map (assuming this is required in your logic)
//               // if (_events.containsKey(date)) {
//               //   _events[date]!.add(name);
//               // } else {
//               //   _events[date] = [name];
//               // }

//               events[date] = name;
//             }

//             print('processed appointment ${events.length}');
//             print(events.toString());

//             return content();
//           }),
//     );
//   }

//     Widget content() {
//     return Column(
//       children: [
//         Text('Selected Day = ${today.toString().split(" ")[0]}'),
//         Container(
//           child: TableCalendar(
//             locale: 'en_US',
//             rowHeight: 43,
//             headerStyle:
//                 HeaderStyle(formatButtonVisible: false, titleCentered: true),
//             availableGestures: AvailableGestures.all,
//             selectedDayPredicate: (day) => isSameDay(day, today),
//             focusedDay: today,
//             firstDay: DateTime.utc(2010, 10, 16),
//             lastDay: DateTime.utc(2030, 3, 14),
//             onDaySelected: _onDaySelected,
//             eventLoader: (day) => _getEventForDay(day).isEmpty ? [] : [_getEventForDay(day)],
//             calendarBuilders: CalendarBuilders(
//               markerBuilder: (context, date, events) {
//                 if (events.isNotEmpty) {
//                   return _buildEventsMarker(date, events);
//                 }
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

// Widget _buildEventsMarker(DateTime date, List events) {
//     return Positioned(
//       right: 1,
//       bottom: 1,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.purple,
//         ),
//         width: 16.0,
//         height: 16.0,
//         child: Center(
//           child: Text(
//             '1', // As each date has at most one event
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 12.0,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _onDaySelected(DateTime day, DateTime focusedDay) {
//     setState(() {
//       today = day;
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/widgets/tableRow.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class appointmentCalendar extends StatefulWidget {
  const appointmentCalendar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<appointmentCalendar> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<appointmentCalendar> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, String> _events = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('appointmentLog').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          _events.clear();
          for (var doc in snapshot.data!.docs) {
            var data = doc.data() as Map<String, dynamic>;
            String name = data['name'];
            Timestamp time = data['time'];
            String status = data['status'];

            DateTime date = DateTime.utc(
                time.toDate().year, time.toDate().month, time.toDate().day);

            _events[date] = name + ' : ' + status;
          }

          return Container(
            color: Color.fromARGB(255, 192, 233, 252),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCalendar(),
                  Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30, top: 30, bottom: 10),
                            child: Text(
                            'Appointment History',
                            style: GoogleFonts.lexend(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: Colors.black),
                                                    ),
                          ),
                          _tableAppointment(snapshot),
                        ],
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _tableAppointment(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    List<TableRow> eventWidgets =
        snapshot.data!.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      String name = data['name'];
      Timestamp time = data['time'];
      DateTime date = time.toDate();
      String status = data['status'];

      return TableRow(children: [
        tableRow('$name'),
        tableRow('${DateFormat('MM/dd/yyyy hh:mm a').format(date)}'),
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

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
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
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            //calendarStyle:  CalendarStyle(defaultTextStyle: TextStyle(color: Colors.white)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) =>
                _events.containsKey(day) ? [_events[day]!] : [],
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isNotEmpty) {
                  return _buildEventsMarker(day);
                }
              },
            ),
          ),
          if (_events.containsKey(_selectedDay))
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: Text(_events[_selectedDay]!,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date) {
    return Positioned(
      right: 1,
      bottom: 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.purple,
        ),
        width: 16.0,
        height: 16.0,
        child: const Center(
          child: Text(
            '1',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
