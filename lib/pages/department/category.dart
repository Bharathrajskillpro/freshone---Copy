import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:freshone/csv.dart';
import 'package:freshone/pages/widgets/detail.dart';
import 'package:freshone/pages/department/department.dart';
import 'package:freshone/pages/widgets/search.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../pdf/api/pdf_api.dart';
import '../../pdf/api/pdf_invoice_api.dart';
import '../../pdf/model/invoice.dart';
import '../../theme/theme.dart';
import '../widgets/back.dart';

enum SampleItem { itemOne, itemtwo, itemthree, itemfour }

class category extends StatefulWidget {
  category({super.key, required this.controller, required this.depart});
  final depart;
  final controller;

  @override
  State<category> createState() => _categoryState();
}

late String name;

class _categoryState extends State<category> {
  String sort = "Date in AO";

  final collection = FirebaseFirestore.instance.collection("products");
  int aa = 0;
  SampleItem? selectedMenu;
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
          height: height,
          width: width,
          padding: EdgeInsets.only(
              top: height * .02, left: width * 0.04, right: width * 0.04),
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    back(width: width, fontcolor: fontcolor),
                    Text(
                      widget.depart.toString().toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.06,
                        color: fontcolor(1.0),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.share,
                        size: width * 0.07,
                        color: fontcolor(1.0),
                      ),
                      onPressed: pdfgenerator,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sorted According to $sort",
                      style: TextStyle(
                          color: fontcolor(.4), fontSize: width * 0.04),
                    ),
                    PopupMenuButton(
                      iconSize: 26,
                      tooltip: "Sort",
                      color: fontcolor(1.0),
                      initialValue: selectedMenu,
                      onSelected: (SampleItem item) => {
                        setState(() {
                          selectedMenu = item;
                        })
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<SampleItem>>[
                        PopupMenuItem(
                          child: Text(
                            "Sort In AO",
                            style: TextStyle(
                                color: !isdark ? Colors.black : Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              aa = 0;
                              sort = "";
                              sort += "Date in AO";
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: Text(
                            "Sort by DO",
                            style: TextStyle(
                                color: !isdark ? Colors.black : Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              aa = 1;
                              sort = "";
                              sort += "Date in Do";
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: Text(
                            "Sort by Name",
                            style: TextStyle(
                                color: !isdark ? Colors.black : Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              aa = 2;
                              sort = "";
                              sort += "Name";
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: Text(
                            "Sort by Price",
                            style: TextStyle(
                                color: !isdark ? Colors.black : Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              aa = 3;
                              sort = "";
                              sort += "Price";
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: height * 0.02),
                    child: StreamBuilder(
                        stream: collection.doc(widget.depart).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final snap = snapshot.data!.data()!.values.toList();
                            final qr = snapshot.data!.data()!.keys.toList();
                            DateTime now = DateTime.now();
                            // final format =
                            //     DateFormat('dd/MM/yy').format(snapshot.data!);
                            // for (var i = 0; i < qr.length; i++) {
                            //   snap[i]['date'] = DateFormat('dd/MM/yy')
                            //       .format(DateTime.parse("2012-02-27"));

                            //   print(snap[i]['date']);
                            // }

                            // print(snap);
                            // final fer = [];
                            // print(format);
                            aa == 0
                                ? snap.sort((a, b) {
                                    var adate = a['date'];
                                    var bdate = b['date'];
                                    return adate.compareTo(bdate);
                                  })
                                : aa == 1
                                    ? snap.sort((a, b) {
                                        var adate = a['date'];
                                        var bdate = b['date'];
                                        return bdate.compareTo(adate);
                                      })
                                    : aa == 2
                                        ? snap.sort((a, b) {
                                            var aname = a['name']
                                                .toString()
                                                .toLowerCase();

                                            var bname = b['name']
                                                .toString()
                                                .toLowerCase();
                                            return aname.compareTo(bname);
                                          })
                                        : snap.sort((a, b) {
                                            var aname = a['price'];
                                            var bname = b['price'];

                                            return aname.compareTo(bname);
                                          });

                            // print(snap);

                            //decendind
                            // snap.sort((a, b) {
                            //   return DateTime.parse(b['date'])
                            //       .compareTo(DateTime.parse(a['date']));
                            // });
                            // fer.sort((a, b) => a.compareTo(b));
                            // for (var i = 0; i < qr.length; i++) {
                            //   // print(qr[i]);
                            //   fer.add(snap[i]['date']);
                            //   print(snap[i]['date']);
                            // }
                            // print(snap);
                            return ListView.builder(
                              itemCount: snap.length,
                              itemBuilder: (context, index) {
                                final data = snap[index] as Map;
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          FadeTransition(
                                        opacity: Tween<double>(begin: 1, end: 0)
                                            .animate(widget.controller),
                                        child: detail(
                                          qr: qr[index],
                                          data: data,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            fontcolor(.02),
                                            fontcolor(.06)
                                          ]),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border:
                                              Border.all(color: fontcolor(.1)),
                                        ),
                                        child: Row(children: [
                                          QrImage(
                                            data: qr[index],
                                            size: width * 0.175,
                                            foregroundColor: fontcolor(.8),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              log(width, 'Name: ', data['name'],
                                                  fontcolor),
                                              facultynamer(
                                                  width: width,
                                                  fontcolor: fontcolor,
                                                  email: data['faculty'])
                                            ],
                                          ),
                                        ]),
                                      ),
                                      Positioned(
                                          bottom: 15,
                                          right: 0,
                                          child: IconButton(
                                            onPressed: () =>
                                                fieldDelete(qr[index]),
                                            icon: Icon(
                                              Icons.delete_forever_rounded,
                                              color: Colors.red,
                                              size: width * 0.08,
                                            ),
                                          ))
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return SizedBox();
                          }
                        }),
                  ),
                )
              ],
            ),
          )),
    );
  }

  void fieldDelete(key) async {
    print(key);
    final ref =
        FirebaseFirestore.instance.collection('products').doc(widget.depart);
    await ref.update({key: FieldValue.delete()}).catchError(
        (onError) => print("Error"));
  }

  void pdfgenerator() async {
    final dataref = await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.depart)
        .get();
    List<InvoiceItem> listofInvoice = [];
    for (var data in dataref.data()!.entries) {
      final map = data.value as Map;
      final invice = InvoiceItem(
          category: widget.depart.toString().toUpperCase(),
          url: data.key,
          name: map['name'],
          date: map['date'],
          company: map['company'],
          faculty: name,
          room: map['room'],
          price: map['price'],
          spec: map['spec']);
      listofInvoice.add(invice);
    }
    final date = DateTime.now();
    final dueDate = date.add(Duration(days: 7));

    final invoice = Invoice(
      items: listofInvoice,
    );

    final pdfFile = await PdfInvoiceApi.generate(invoice);

    PdfApi.openFile(pdfFile);
  }

  Row log(double width, String sub, String val, Function fontcolor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          sub,
          style: TextStyle(
              fontSize: width * 0.04,
              fontWeight: FontWeight.w500,
              color: fontcolor(.5)),
        ),
        Text(
          val,
          style: TextStyle(
              fontSize: width * 0.045,
              fontWeight: FontWeight.w600,
              color: fontcolor(.85)),
        ),
      ],
    );
  }
}

class facultynamer extends StatefulWidget {
  const facultynamer({
    super.key,
    required this.width,
    required this.fontcolor,
    required this.email,
  });

  final String email;
  final double width;
  final Color Function(dynamic opacity) fontcolor;

  @override
  State<facultynamer> createState() => _facultynamerState();
}

class _facultynamerState extends State<facultynamer> {
  // late String name = '';
  @override
  void initState() {
    // TODO: implement initState
    namefinder(widget.email);
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Faculty: ',
          style: TextStyle(
              fontSize: widget.width * 0.04,
              fontWeight: FontWeight.w500,
              color: widget.fontcolor(.5)),
        ),
        Text(
          name,
          style: TextStyle(
              fontSize: widget.width * 0.045,
              fontWeight: FontWeight.w600,
              color: widget.fontcolor(.85)),
        ),
      ],
    );
  }
}
