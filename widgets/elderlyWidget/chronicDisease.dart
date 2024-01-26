import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seniorconnect/widgets/elderlyWidget/multiSelectWidget.dart';

class chronicDiseaseElderly extends StatefulWidget {
  final DocumentSnapshot<Object?> snapshots;

  const chronicDiseaseElderly({super.key, required this.snapshots});

  @override
  State<chronicDiseaseElderly> createState() => _chronicDiseaseElderlyState();
}

class _chronicDiseaseElderlyState extends State<chronicDiseaseElderly> {

    void _showMultiSelect() async {
    final List<String> items = [
      'Diabetes',
      'Cancer',
      'Chronic Kidney Disease',
      'Mental Health Disorders',
      'Osteoporosis',
      'HIV/AIDS',
    ];

    // final List<String>? results =

    await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return MultiSelect(items: items);
      },
    );

    // if (results != null) {
    //   setState(() {
    //     _selectedItems = results;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {

            //var DocData = widget.snapshot.data as DocumentSnapshot;

            Map<String, dynamic> data = widget.snapshots.data() as Map<String, dynamic>;

    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 130,
            child: ElevatedButton(
              onPressed: _showMultiSelect,
              child: Text(
                'Chronic Disease',
                style: GoogleFonts.lexend(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          data.containsKey('chronic')
              ? Container(
                  width: 260,
                  child: Wrap(
                    spacing: 10,
                    children:
                        List<String>.from(widget.snapshots['chronic'] as List<dynamic>)
                            .map((e) => Chip(
                                  backgroundColor: Colors.white,
                                  visualDensity: VisualDensity.comfortable,
                                  labelStyle: GoogleFonts.lexend(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide.none,
                                    borderRadius: BorderRadius.circular(
                                        20), // Adjust the radius to get the desired roundness
                                  ),
                                  label: Text(e),
                                ))
                            .toList(),
                  ),
                )
              : Container(
                  child: Text(
                    'No Chronic Disease',
                    style: GoogleFonts.lexend(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        color: Colors.black),
                  ),
                )
        ],
      ),
    );
  }
}
