import 'dart:io';
import 'pdf_api.dart';
import '../model/invoice.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildTitle(invoice),
        buildInvoice(invoice),
      ],
    ));

    return PdfApi.saveDocument(
        name:
            '${invoice.items.first.category.toString().toUpperCase()} Department',
        pdf: pdf);
  }

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            invoice.items.first.category.toUpperCase(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Date',
      'Name',
      'Faculty',
      'Company',
      'Room',
      'Price',
      // 'Specification',
    ];
    final data = invoice.items.map((item) {
      final total = item.price;

      return [
        item.date,
        item.name,
        item.faculty,
        item.company,
        item.room,
        item.price,
        // item.spec,
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      tableWidth: TableWidth.max,
      cellPadding: EdgeInsets.all(10),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        5: Alignment.centerRight,
        4: Alignment.centerLeft,
      },
    );
  }
}
