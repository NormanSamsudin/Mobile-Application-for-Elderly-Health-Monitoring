import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class infoWidget extends StatelessWidget {
  final String label;
  final String value;
  infoWidget({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(label,
                style: GoogleFonts.lexend(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    color: Colors.black)),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            // color: const Color.fromARGB(255, 182, 237, 184),
            color: Colors.white,
            child: Container(
                height: 40,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(value,
                      style: GoogleFonts.lexend(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          color: Colors.black)),
                )),
          )
        ],
      ),
    );
  }
}
