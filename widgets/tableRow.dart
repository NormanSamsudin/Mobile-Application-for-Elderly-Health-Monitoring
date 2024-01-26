import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class tableRow extends StatelessWidget {
  final String data;

  tableRow(this.data);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      //color: Colors.white,
      child:  Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(this.data,
                style: GoogleFonts.lexend(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    color: Colors.black)),
      ),
    );
  }
}
