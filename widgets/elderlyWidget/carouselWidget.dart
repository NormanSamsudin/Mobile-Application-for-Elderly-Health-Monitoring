import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class carouselWidget extends StatelessWidget {
  final String mainText;
  final String subText;
  final String imagePath;
  Color? color;

  carouselWidget({super.key, required this.mainText, required this.subText, required this.color, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      alignment: Alignment.center,
      child: Center(
        child: Row(
          children: [
            SizedBox(
              width: 30,
            ),
            Container(
              width: 250,
              height: 100,
              child: Column(
                children: [
                  Text(
                    mainText,
                    style: GoogleFonts.lexend(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    subText,
                    style: GoogleFonts.lexend(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Container(
              height: 100,
              width: 100,
              child: Image.asset(imagePath),
            )
          ],
        ),
      ),
    );
  }
}
