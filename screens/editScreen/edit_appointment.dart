import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:seniorconnect/models/appointment.dart';
import 'package:seniorconnect/models/personal_inform.dart';
import 'package:seniorconnect/screens/caregiverScreen/appointment.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/config/constants.dart';
import 'package:seniorconnect/config/input_decoration.dart';
// import 'package:seniorconnect/rubbish/image_med_input.dart';
import 'package:seniorconnect/models/medication.dart';

class editAppointment extends StatefulWidget {
  editAppointment({super.key, required this.appointment});

  final Appointment appointment;

  @override
  State<editAppointment> createState() => _editProfileState();
}

class _editProfileState extends State<editAppointment> {
  final _formKey = GlobalKey<FormState>();

  String? _appointmentName;
  DateTime? _appointmentDate;
  String? _appointmentPlace;

  void _editAppointment(BuildContext context, String id) async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    print(_appointmentName);
    print(_appointmentPlace);
    print(_appointmentDate);

    try {
      // Handle Firestore update or upload logic here...
      await FirebaseFirestore.instance
          .collection('appointment')
          .doc(id)
          .update({
        'id': id,
        'name': _appointmentName,
        'place': _appointmentPlace,
        'dateTime': _appointmentDate,
      });

      Navigator.of(context).pop(); // Navigate back
    } on FirebaseFirestore catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  DateTime? selectedDate;
  TextEditingController? dateController = TextEditingController();
  TextEditingController? timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _appointmentDate = widget.appointment.date.toDate();
      dateController!.text =
          DateFormat('yyyy-MM-dd').format(widget.appointment.date.toDate());
      timeController!.text =
          DateFormat('HH:mm').format(widget.appointment.date.toDate());
    });
  }

  Future<void> _selectDateTime(DateTime? initialDateTime) async {
    //mula2 pick tarikh dlu
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    // baru pilih masa
    if (picked != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _appointmentDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          //nak format data
          dateController!.text =
              DateFormat('yyyy-MM-dd').format(_appointmentDate!);
          timeController!.text = DateFormat('HH:mm').format(_appointmentDate!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appointment')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'lib/assets/images/appointment_bg.jpg',
              ),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter),
        ),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30, top: 50, bottom: 180),
                  child: Text(
                    '',
                    style: GoogleFonts.lexend(
                      color: putih,
                      fontSize: 23,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: putih,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  // width: double.infinity,
                  // height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 40, bottom: 40),
                              child: Text(
                                'Edit Appointment',
                                style: GoogleFonts.lexend(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            DropdownButtonFormField<String>(
                              value: widget.appointment.name,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Medical Checkup',
                                  child: Text('Medical Checkup'),
                                ),
                                DropdownMenuItem(
                                  value: 'Dental Checkups',
                                  child: Text('Dental Checkups'),
                                ),
                                DropdownMenuItem(
                                  value: 'Vaccinations',
                                  child: Text('Vaccinations'),
                                ),
                                DropdownMenuItem(
                                  value: 'Mammograms',
                                  child: Text('Mammograms'),
                                ),
                                DropdownMenuItem(
                                  value: 'Colonoscopies',
                                  child: Text('Colonoscopies'),
                                ),
                                DropdownMenuItem(
                                  value: 'Prescription Refills',
                                  child: Text('Prescription Refills'),
                                ),
                                DropdownMenuItem(
                                  value: 'Hospital Selayang',
                                  child: Text('Hospital Selayang'),
                                ),
                                DropdownMenuItem(
                                  value: 'Follow-up Care',
                                  child: Text('Follow-up Care'),
                                ),
                                DropdownMenuItem(
                                  value: 'Surgery',
                                  child: Text('Surgery'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _appointmentName = value;
                                });
                              },
                              onSaved: (newValue) {
                                _appointmentName = newValue!;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Place',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(
                                    Icons.medical_services_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a place';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            TextFormField(
                              controller: dateController,
                              readOnly: true,
                              onTap: () => _selectDateTime(_appointmentDate),
                              decoration: const InputDecoration(
                                labelText: 'Appointment Date',
                                hintText: 'Appointment Date',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(
                                    Icons.inventory_sharp,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            TextFormField(
                              controller: timeController,
                              readOnly: true,
                              onTap: () => _selectDateTime(_appointmentDate),
                              decoration: const InputDecoration(
                                labelText: 'Appointment Time',
                                hintText: 'Appointment Time',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(
                                    Icons.access_time,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            DropdownButtonFormField<String>(
                              value: widget.appointment.place,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Hospital Kuala Lumpur',
                                  child: Text('Hospital Kuala Lumpur'),
                                ),
                                DropdownMenuItem(
                                  value: 'Hospital Selayang',
                                  child: Text('Hospital Selayang'),
                                ),
                                DropdownMenuItem(
                                  value: 'Hospital Serdang',
                                  child: Text('Hospital Serdang'),
                                ),
                                DropdownMenuItem(
                                  value: 'Hospital Putrajaya',
                                  child: Text('Hospital Putrajaya'),
                                ),
                                DropdownMenuItem(
                                  value: 'Institut Jantung Negara',
                                  child: Text('Institut Jantung Negara'),
                                ),
                                DropdownMenuItem(
                                  value: 'Hospital Pantai Kuala Lumpur',
                                  child: Text('Hospital Pantai Kuala Lumpur'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _appointmentPlace = value;
                                });
                              },
                              onSaved: (newValue) {
                                _appointmentPlace = newValue!;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Place',
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(
                                    Icons.place_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a place';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 100,
                                  height: 40,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: putih,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: const BorderSide(
                                                color:  Color.fromARGB(
                                                    255, 100, 100, 100),
                                                width: 1.0) // <-- Radius
                                            ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Back',
                                        style: GoogleFonts.lexend(
                                            fontSize: 15, color: hitam),
                                      )),
                                ),
                                const SizedBox(
                                  width: 10,
                                  height: 100,
                                ),
                                Container(
                                  width: 100,
                                  height: 40,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kepple,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              12), // <-- Radius
                                        ),
                                      ),
                                      onPressed: () {
                                        print('presses');
                                        _editAppointment(
                                            context, widget.appointment.id);
                                      },
                                      child: Text(
                                        'Edit',
                                        style: GoogleFonts.lexend(
                                            fontSize: 15, color: Colors.white),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
