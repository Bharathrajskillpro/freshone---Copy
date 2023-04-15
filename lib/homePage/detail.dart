import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../pdf/api/pdf_api.dart';
import '../pdf/api/qrpdf.dart';
import '../pdf/model/qrinvoice.dart';
import '../theme/theme.dart';
import 'widgets/back.dart';

class detail extends StatefulWidget {
  detail({
    super.key,
    required this.qr,
    required this.data,
    required this.fromwere,
  });
  final qr;
  final data;
  final fromwere;

  @override
  State<detail> createState() => _detailState();
}

class _detailState extends State<detail> {
  void pdfgenerator(barcode, name) async {
    final invoice = QRInvoice(
      item: InvoiceItem(barcode: barcode, product: name),
    );
    final pdfFile = await QRinvoiceApi.generate(invoice);
    PdfApi.openFile(pdfFile);
  }

  List<Uint8List> imageFileList = [];

  @override
  void initState() {
    // TODO: implement initState
    imageList();
    super.initState();
  }

  Future imageList() async {
    var ref = await FirebaseStorage.instance.ref(widget.data['path']).listAll();

    for (var img in ref.items) {
      Uint8List? image = await img.getData();
      setState(() {
        image != null ? imageFileList.add(image) : null;
      });
    }
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
                    widget.data['name'],
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
                    pdfgenerator(widget.qr, widget.data['name']);
                  },
                  child: QrImage(
                    data: widget.qr,
                    size: width * 0.3,
                    foregroundColor: fontcolor(.8),
                  ),
                ),
              ),
              spacer(height, .02),
              imageFileList.isNotEmpty
                  ? CarouselSlider.builder(
                      itemCount: imageFileList.length,
                      options: CarouselOptions(
                          height: height * 0.2,
                          autoPlay: true,
                          viewportFraction: .3,
                          scrollDirection: Axis.horizontal,
                          enlargeCenterPage: true,
                          clipBehavior: Clip.none,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          autoPlayInterval: Duration(milliseconds: 1500),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800)),
                      itemBuilder: (context, index, realIndex) => ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          imageFileList[index],
                          fit: BoxFit.cover,
                          // width: width * .3,
                        ),
                      ),
                    )
                  : SizedBox(),
              imageFileList.isNotEmpty
                  ? SizedBox(
                      height: height * 0.02,
                    )
                  : SizedBox(),
              widget.fromwere == 'recent'
                  ? log(width, 'Department: ', widget.data['department'],
                      fontcolor)
                  : SizedBox(),
              widget.fromwere == 'recent' ? spacer(height, .02) : SizedBox(),
              log(width, 'Date: ', widget.data['date'], fontcolor),
              spacer(height, .01),
              facultyname(
                  width: width,
                  fontcolor: fontcolor,
                  email: widget.data['faculty']),
              spacer(height, .01),
              log(width, 'Room: ', widget.data['room'], fontcolor),
              spacer(height, .01),
              log(width, 'Company: ', widget.data['company'], fontcolor),
              spacer(height, .01),
              log(width, 'Price: ', widget.data['price'].toString(), fontcolor),
              spacer(height, .01),
              log(width, 'Spec: ', widget.data['spec'], fontcolor),
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
