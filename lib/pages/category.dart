import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshone/pages/detail.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../pdf/api/pdf_api.dart';
import '../pdf/api/pdf_invoice_api.dart';
import '../pdf/model/invoice.dart';
import 'widgets/back.dart';

class category extends StatelessWidget {
  category({super.key, required this.controller, required this.depart});
  final depart;
  final controller;
  var fontcolor = (opacity) => Color.fromRGBO(48, 40, 76, opacity);
  final collection = FirebaseFirestore.instance.collection("products");

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.only(
              top: height * .02, left: width * 0.04, right: width * 0.04),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 241, 235, 252),
                Color.fromARGB(255, 255, 255, 255)
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
                      depart.toString().toUpperCase(),
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
                      ),
                      onPressed: pdfgenerator,
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: height * 0.02),
                    child: StreamBuilder(
                        stream: collection.doc(depart).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final snap = snapshot.data!.data()!.values.toList();
                            final qr = snapshot.data!.data()!.keys.toList();
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
                                            .animate(controller),
                                        child: detail(
                                          qr: qr[index],
                                          data: data,
                                          // fromwere: 'category',
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        fontcolor(.02),
                                        fontcolor(.06)
                                      ]),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: fontcolor(.1)),
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
                                          log(width, 'Name: ', data['name']),
                                          facultynamer(
                                              width: width,
                                              fontcolor: fontcolor,
                                              email: data['faculty'])
                                        ],
                                      )
                                    ]),
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

  void pdfgenerator() async {
    final dataref = await FirebaseFirestore.instance
        .collection('products')
        .doc(depart)
        .get();
    List<InvoiceItem> listofInvoice = [];
    for (var data in dataref.data()!.entries) {
      final map = data.value as Map;
      final invice = InvoiceItem(
          category: depart.toString().toUpperCase(),
          url: data.key,
          name: map['name'],
          date: map['date'],
          company: map['company'],
          faculty: map['faculty'],
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

  Row log(double width, String sub, String val) {
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
  late String name = '';
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
