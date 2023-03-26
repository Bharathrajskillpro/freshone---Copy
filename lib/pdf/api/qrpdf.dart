import 'dart:io';
import '../model/qrinvoice.dart';
import 'pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class QRinvoiceApi {
  static Future<File> generate(QRInvoice qrdata) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      build: (context) => [
        buildTitle(qrdata),
        BarcodeWidget(
            data: qrdata.item.barcode.trim(),
            barcode: Barcode.qrCode(),
            height: 15 * PdfPageFormat.cm,
            width: 15 * PdfPageFormat.cm),
      ],
    ));

    return PdfApi.saveDocument(name: qrdata.item.product, pdf: pdf);
  }

  static Widget buildTitle(QRInvoice qrdata) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            qrdata.item.product.toUpperCase(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2 * PdfPageFormat.cm),
        ],
      );
}
