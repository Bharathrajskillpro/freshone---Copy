import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'detail.dart';

class search extends StatefulWidget {
  const search({
    super.key,
    required this.fontcolor,
  });
  final fontcolor;

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  var namecontroller = TextEditingController();
  var barcode = '';
  var submited = false;
  Map? data;
  String? dept;
  bool checked = false;

  @override
  void dispose() {
    // TODO: implement dispose
    namecontroller.dispose();
    super.dispose();
  }

  Future search(qr) async {
    final collection =
        await FirebaseFirestore.instance.collection("products").get();
    for (var doc in collection.docs) {
      final list = doc.data().entries.toList();
      for (var check in list) {
        if (check.key.toLowerCase() == qr.toString().toLowerCase()) {
          setState(() {
            data = check.value;
            dept = doc.id;
          });
          print(dept);
        }
      }
    }
    setState(() {
      checked = true;
    });
  }

  Future searchUsingProductName(name) async {
    final collection =
        await FirebaseFirestore.instance.collection("products").get();
    for (var doc in collection.docs) {
      final list = doc.data().entries.toList();
      for (var check in list) {
        if (check.value['name'] == name) {
          setState(() {
            data = check.value;
            dept = doc.id;
            barcode = check.key;
          });
        }
      }
    }
    setState(() {
      checked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: width * 0.045,
            color: widget.fontcolor(1.0),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.fontcolor(.2))),
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: width * 0.07,
                color: widget.fontcolor(.5),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  autocorrect: true,
                  onSubmitted: (val) {
                    setState(() {
                      submited = true;
                      data = null;
                      barcode = '';
                      checked = false;
                      if (val != "") {
                        searchUsingProductName(val.trim());
                      }
                    });
                  },
                  controller: namecontroller,
                  style: TextStyle(
                      color: widget.fontcolor(.8),
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                          color: widget.fontcolor(0.5),
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w500),
                      contentPadding: const EdgeInsets.all(0),
                      border: InputBorder.none,
                      hintText: 'Enter product name'),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () => setState(() {
                  data = null;
                  barcode = '';
                  checked = false;
                  qrcapture(context, height, width);
                }),
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  size: width * 0.07,
                  color: widget.fontcolor(.5),
                ),
              )
            ],
          ),
        ),
        checked
            ? const SizedBox(
                height: 10,
              )
            : const SizedBox(),
        checked
            ? GestureDetector(
                onTap: () => Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      detail(
                    data: data,
                    qr: barcode,
                  ),
                )),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [widget.fontcolor(.05), widget.fontcolor(.1)],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      data != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                subfieled(width, 'Name: ', data!['name']),
                                subheight(),
                                subfieled(width, 'Dept: ', dept!),
                              ],
                            )
                          : Text('data not found'),
                      QrImage(
                        data: barcode,
                        size: width * 0.15,
                        foregroundColor: widget.fontcolor(.9),
                        padding: const EdgeInsets.all(6),
                      )
                    ],
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Future<dynamic> qrcapture(BuildContext context, double height, double width) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              actions: [
                Column(
                  children: [
                    SizedBox(
                      height: height * 0.4,
                      width: width * 0.7,
                      child: MobileScanner(
                        fit: BoxFit.contain,
                        controller: MobileScannerController(
                          autoStart: true,
                          returnImage: true,
                        ),
                        onDetect: (capture) {
                          final List<Barcode> barcodes = capture.barcodes;
                          final Uint8List? image = capture.image;
                          barcode = barcodes.first.rawValue.toString();
                          print('i found the bar code guys....$barcode');
                          setState(() {
                            if (image != null) {
                              print('got the image     !!!!!');
                            }
                            search(barcode);
                            if (data != null || checked) {
                              print('hello ok done');
                              Navigator.pop(context);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
        });
  }

  SizedBox subheight() {
    return const SizedBox(
      height: 4,
    );
  }

  Row subfieled(double width, String head, String val) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          head,
          style: TextStyle(
              fontSize: width * 0.03,
              fontWeight: FontWeight.w500,
              color: widget.fontcolor(.5)),
        ),
        SizedBox(
          width: width * 0.5,
          child: Text(
            val,
            style: TextStyle(
                fontSize: width * 0.035,
                fontWeight: FontWeight.w600,
                color: widget.fontcolor(.8)),
          ),
        ),
      ],
    );
  }
}
