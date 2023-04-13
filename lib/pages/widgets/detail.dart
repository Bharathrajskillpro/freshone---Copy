import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../pdf/api/pdf_api.dart';
import '../../pdf/api/qrpdf.dart';
import '../../pdf/model/qrinvoice.dart';
import '../../theme/theme.dart';
import 'back.dart';

class detail extends StatelessWidget {
  detail({
    super.key,
    required this.qr,
    required this.data,
    required this.fromwere,
  });
  final qr;
  final data;
  final fromwere;

  void pdfgenerator(barcode, name) async {
    final invoice = QRInvoice(
      item: InvoiceItem(barcode: barcode, product: name),
    );
    final pdfFile = await QRinvoiceApi.generate(invoice);
    PdfApi.openFile(pdfFile);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isdark = themeProvider.isDark;
    fontcolor(opacity) => !isdark
        ? Color.fromRGBO(239, 241, 255, opacity)
        : Color.fromRGBO(48, 40, 76, opacity);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
            top: height * .02, left: width * 0.04, right: width * 0.04),
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isdark
                ? const [
                    Color.fromARGB(255, 255, 255, 255),
                    Color.fromRGBO(235, 235, 255, 1)
                  ]
                : const [
                    Color.fromRGBO(63, 64, 100, 1),
                    Color.fromRGBO(34, 34, 61, 1)
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  back(width: width, fontcolor: fontcolor),
                  Text(
                    data['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: width * 0.06,
                      color: fontcolor(1.0),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.07,
                  )
                ],
              ),
              spacer(height, .02),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onDoubleTap: () {
                    pdfgenerator(qr, data['name']);
                  },
                  child: QrImage(
                    data: qr,
                    size: width * 0.3,
                    foregroundColor: fontcolor(.8),
                  ),
                ),
              ),
              spacer(height, .02),
              fromwere == 'recent'
                  ? log(width, 'Department: ', data['department'], fontcolor)
                  : SizedBox(),
              fromwere == 'recent' ? spacer(height, .02) : SizedBox(),
              log(width, 'Date: ', data['date'], fontcolor),
              spacer(height, .01),
              facultyname(
                  width: width, fontcolor: fontcolor, email: data['faculty']),
              spacer(height, .01),
              log(width, 'Room: ', data['room'], fontcolor),
              spacer(height, .01),
              log(width, 'Company: ', data['company'], fontcolor),
              spacer(height, .01),
              log(width, 'Price: ', data['price'].toString(), fontcolor),
              spacer(height, .01),
              log(width, 'Spec: ', data['spec'], fontcolor),
            ],
          ),
        ),
      ),
    );
  }

  Row log(double width, String sub, String val, Function fontcolor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            sub,
            style: TextStyle(
                fontSize: width * 0.04,
                fontWeight: FontWeight.w500,
                color: fontcolor(.5)),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            val,
            style: TextStyle(
                fontSize: width * 0.045,
                fontWeight: FontWeight.w600,
                color: fontcolor(.85)),
          ),
        ),
      ],
    );
  }

  SizedBox spacer(double height, double h) {
    return SizedBox(
      height: height * h,
    );
  }
}

class facultyname extends StatefulWidget {
  const facultyname({
    super.key,
    required this.width,
    required this.fontcolor,
    required this.email,
  });

  final String email;
  final double width;
  final Color Function(dynamic opacity) fontcolor;

  @override
  State<facultyname> createState() => _facultynameState();
}

class _facultynameState extends State<facultyname> {
  late String name = '';
  @override
  void initState() {
    // TODO: implement initState
    namefinder(widget.email);
    print(widget.email);
    super.initState();
  }

  Future namefinder(email) async {
    final data =
        await FirebaseFirestore.instance.collection('users').doc(email).get();

    final dlist =
        data.data()!.entries.firstWhere((element) => element.key == 'name');
    print(dlist.value);
    setState(() {
      name = dlist.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            "Faculty: ",
            style: TextStyle(
                fontSize: widget.width * 0.04,
                fontWeight: FontWeight.w500,
                color: widget.fontcolor(.5)),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            name,
            style: TextStyle(
                fontSize: widget.width * 0.045,
                fontWeight: FontWeight.w600,
                color: widget.fontcolor(.85)),
          ),
        ),
      ],
    );
  }
}
