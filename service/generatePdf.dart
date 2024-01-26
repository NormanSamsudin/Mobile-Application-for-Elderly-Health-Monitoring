import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/rendering.dart';

class pdfGenerator {
  // pdfGenerator( this.chart1,  this.chart2,  this.chart3, this.chart4, this.chart5, this.chart6);

  pdfGenerator(this.chart1, this.chart2, this.chart3, this.chart4, this.chart5);

  final GlobalKey chart1;
  final GlobalKey chart2;
  final GlobalKey chart3;
  final GlobalKey chart4;
  final GlobalKey chart5;

  // final GlobalKey chart1;
  // final GlobalKey chart2;
  // final GlobalKey chart3;
  // final GlobalKey chart4;
  // final GlobalKey chart5;
  // final GlobalKey chart6;

  Future<void> saveAndLaunchFile(List<int> bytes, String filename) async {
    final path = (await getExternalStorageDirectory())!.path;
    final file = File('$path/$filename');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$filename');
  }

  // untuk nak jadika chart kepada image
  Future<Uint8List> _capturePng(GlobalKey key) async {
    try {
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    } catch (e) {
      print(e);
      return Uint8List(0);
    }
  }

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('images/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  // design pdf header
  void _addHeader(PdfPage page) async {
    // Define the bounds of the header
    final Rect headerBounds =
        Rect.fromLTWH(0, 0, page.getClientSize().width, 100);

    // Add a rectangle (optional, for a colored header background)
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(229, 204, 255)), bounds: headerBounds);

    ////bahagian untuk nak tulis apa2 atau nk letak gambar apa2
    page.graphics.drawString('Health Report',
        PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
        ),
        bounds: Rect.fromLTWH(10, 10, 400, 50));

    page.graphics.drawString(
        'Elderly: Muhammad Norman Bin Samsudin',
        PdfStandardFont(PdfFontFamily.helvetica, 18,
            style: PdfFontStyle.regular),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
        ),
        bounds: Rect.fromLTWH(10, 30, 400, 50));

    page.graphics.drawString(
        'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
        PdfStandardFont(PdfFontFamily.helvetica, 18,
            style: PdfFontStyle.regular),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
        ),
        bounds: Rect.fromLTWH(10, 50, 400, 50));

    // Add an image (if desired)
    // page.graphics.drawImage(PdfBitmap(await _readImageData('img1.JPG')),
    //     Rect.fromLTWH(headerBounds.width - 100, 15, 70, 70));

    // Add a line under the header (optional)
    page.graphics.drawLine(
        PdfPen(PdfColor(0, 0, 0), width: 1),
        Offset(0, headerBounds.height),
        Offset(headerBounds.width, headerBounds.height));
  }

  // history operation
  _addHistoryOperation(PdfPage page) async {
    final Rect healthBound =
        Rect.fromLTWH(0, 310, page.getClientSize().width - 250, 150);

    //Draw the rectangle border
    //page.graphics.drawRectangle(bounds: healthBound, pen: PdfPen(PdfColor(0, 0, 0)));

    page.graphics.drawString('Operation History',
        PdfStandardFont(PdfFontFamily.helvetica, 15, style: PdfFontStyle.bold),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
        ),
        bounds: const Rect.fromLTWH(0, 320, 400, 50));

    PdfGrid grid = PdfGrid();

    // nak bagi ada style dekat pdf
    grid.style = PdfGridStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 12),
        cellPadding: PdfPaddings(left: 5, right: 50, top: 2, bottom: 2));

    grid.draw(page: page, bounds: const Rect.fromLTWH(0, 350, 0, 0));

    Uint8List chartImage4 = await _capturePng(chart1);
    page.graphics
        .drawImage(PdfBitmap(chartImage4), Rect.fromLTWH(0, 500, 450, 50));

    // page.graphics.drawImage(PdfBitmap(await _readImageData('logo.png')),
    //     Rect.fromLTWH(0, 600, 90, 80));
  }

  Future<void> createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    // Add header to the page
    _addHeader(page);

    //CHART 1
    Uint8List chart_1 = await _capturePng(chart1);
    page.graphics.drawImage(PdfBitmap(chart_1),
        Rect.fromLTWH(0, 150, page.getClientSize().width, 200));

    // CHART 2
    Uint8List chart_2 = await _capturePng(chart2);
    page.graphics.drawImage(PdfBitmap(chart_2),
        Rect.fromLTWH(0, 350, page.getClientSize().width, 200));



    // CHART 4
    Uint8List chart_4 = await _capturePng(chart4);
    page.graphics.drawImage(PdfBitmap(chart_4),
        Rect.fromLTWH(0, 550, page.getClientSize().width / 2, 200));

    //chart 5
    Uint8List chart_5 = await _capturePng(chart5);
    page.graphics.drawImage(
        PdfBitmap(chart_5),
        Rect.fromLTWH(page.getClientSize().width / 2, 550,
            page.getClientSize().width / 2, 200));

    final page2 = document.pages.add();

    // // CHART 3
    Uint8List chart_3 = await _capturePng(chart3);
    page2.graphics.drawImage(PdfBitmap(chart_3),
        Rect.fromLTWH(0, 0, page.getClientSize().width, 300));

    List<int> bytes = await document.save();
    document.dispose();

    saveAndLaunchFile(bytes, 'Elderly Report.pdf');
  }
}
