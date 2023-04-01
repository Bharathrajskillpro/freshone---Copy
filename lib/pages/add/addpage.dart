import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshone/auth.dart';
import 'package:freshone/pdf/api/qrpdf.dart';
import 'package:freshone/pdf/model/qrinvoice.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../pdf/api/pdf_api.dart';
import '../../theme/theme.dart';
import '../widgets/back.dart';

class addpage extends StatefulWidget {
  const addpage({super.key});

  @override
  State<addpage> createState() => _addpageState();
}

class _addpageState extends State<addpage> {
  final collection = FirebaseFirestore.instance.collection('products');
  GlobalKey _screenShotKey = GlobalKey();
  String? catname;
  String scan = 'scan';
  bool rescan = false;
  bool startcamera = false;
  Uint8List showimage = Uint8List(0);
  late String barcode = '';
  final faculty_email = auth().currentUser!.email;

  //
  var pname = TextEditingController();
  // var fname = TextEditingController();
  var room = TextEditingController();
  var company = TextEditingController();
  var price = TextEditingController();
  var spec = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    pname.dispose();
    // fname.dispose();
    room.dispose();
    company.dispose();
    price.dispose();
    spec.dispose();
    super.dispose();
  }

  clear() {
    pname.clear();
    // fname.clear();
    room.clear();
    company.clear();
    price.clear();
    spec.clear();
    barcode = '';
    showimage = Uint8List(0);
  }

  Future add() async {
    await collection.doc(catname).set({
      barcode.replaceAll('.', ""): {
        'department': catname,
        'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
        'name': pname.text.trim(),
        'faculty': faculty_email!.trim(),
        'room': room.text.trim(),
        'company': company.text.trim(),
        'price': int.parse(price.text.trim()),
        'spec': spec.text.trim()
      }
    }, SetOptions(merge: true));
    print('true');
  }

  void pdfgenerator() async {
    final invoice = QRInvoice(
      item: InvoiceItem(
          barcode: barcode.replaceAll(".", ""), product: pname.text.trim()),
    );
    final pdfFile = await QRinvoiceApi.generate(invoice);
    PdfApi.openFile(pdfFile);
  }

  var a = 0;
  // var fontcolor = (opacity) => Color.fromRGBO(48, 40, 76, opacity);
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
        padding: EdgeInsets.only(
            top: height * .01, left: width * 0.04, right: width * 0.04),
        child: SafeArea(
          child: ListView(
            children: [
              tophead(width, fontcolor),
              SizedBox(
                height: height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Category',
                    style: TextStyle(
                        color: fontcolor(0.9),
                        fontWeight: FontWeight.w500,
                        fontSize: width * 0.045),
                  ),
                  catname == null
                      ? Text(
                          "Choose an category",
                          style: TextStyle(
                              color: fontcolor(.6),
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.035),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ShaderMask(
                            shaderCallback: (Rect rect) => const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 19, 149, 255),
                                  Color.fromARGB(255, 234, 114, 255)
                                ]).createShader(rect),
                            child: Text(
                              catname!.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: width * 0.045),
                            ),
                          ),
                        ),
                ],
              ),
              SizedBox(
                height: height * 0.015,
              ),
              SizedBox(
                height: height * 0.045,
                child: StreamBuilder(
                    stream: collection.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var list = snapshot.data!.docs.toList();
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => setState(() {
                                catname = list[index].id.toString();
                                a = index;
                              }),
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                    color: (a == index && catname != null)
                                        ? Color.fromARGB(255, 30, 154, 255)
                                        : fontcolor(.1),
                                    border: Border.all(color: fontcolor(.1)),
                                    borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Center(
                                  child: Text(
                                    list[index].id.toUpperCase(),
                                    style: TextStyle(
                                        color: (a == index && catname != null)
                                            ? Colors.white
                                            : fontcolor(0.9),
                                        fontWeight: FontWeight.w500,
                                        fontSize: width * 0.035),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              field(width, 'Product Name', pname, TextInputType.text,
                  Icons.inventory_2_outlined, fontcolor, ''),
              // SizedBox(
              //   height: height * 0.02,
              // ),
              // field(width, 'Faculty Name', fname, TextInputType.text,
              //     Icons.person),
              SizedBox(
                height: height * 0.02,
              ),
              field(width, 'Room No.', room, TextInputType.text,
                  Icons.meeting_room_rounded, fontcolor, ''),
              SizedBox(
                height: height * 0.02,
              ),
              field(width, 'Company', company, TextInputType.text,
                  Icons.apartment_sharp, fontcolor, ""),
              SizedBox(
                height: height * 0.02,
              ),
              field(width, 'price', price, TextInputType.number,
                  Icons.currency_rupee_rounded, fontcolor, "a"),
              SizedBox(
                height: height * 0.02,
              ),
              field(width, 'Specification', spec, TextInputType.text,
                  Icons.description_outlined, fontcolor, ""),
              SizedBox(
                height: height * 0.02,
              ),
              shifter(width, fontcolor),
              scanner(height, width, fontcolor),
              SizedBox(
                height: height * 0.04,
              ),
              addbutton(width),
              SizedBox(
                height: height * .05,
              )
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton addbutton(double width) {
    return ElevatedButton(
        onPressed: () => setState(() {
              if (catname == null ||
                  pname.text.trim() == '' ||
                  // fname.text.trim() == '' ||
                  room.text.trim() == '' ||
                  company.text.trim() == '' ||
                  price.text.trim() == '' ||
                  spec.text.trim() == '' ||
                  barcode == '') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(milliseconds: 500),
                    backgroundColor: Color.fromARGB(255, 255, 73, 60),
                    content: Center(
                        child: Text(
                      'Kindly enter all the details!!',
                    )),
                  ),
                );
              } else {
                add();

                if (scan == 'create') {
                  pdfgenerator();
                }

                clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(milliseconds: 300),
                    content: Center(
                        child: Text(
                      'Successfuly added the product',
                    )),
                  ),
                );
                Navigator.pop(context);
              }
            }),
        style: ButtonStyle(
            padding: const MaterialStatePropertyAll(EdgeInsets.all(12)),
            textStyle: MaterialStatePropertyAll(TextStyle(
                fontWeight: FontWeight.w600, fontSize: width * 0.05))),
        child: const Text("Add Product"));
  }

  Row shifter(double width, Function fontcolor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () => setState(() {
            scan = 'scan';
          }),
          child: Text(
            'Scan QR',
            style: TextStyle(
                fontFamily: 'TiltNeon',
                color: scan == 'scan' ? fontcolor(1.0) : fontcolor(.2),
                fontWeight: FontWeight.w500,
                fontSize: width * 0.045),
          ),
        ),
        TextButton(
          onPressed: () => setState(() {
            scan = 'create';
            startcamera = false;
            barcode =
                "${pname.text.trim()}_${faculty_email!.trim().replaceAll('.', '')}";
          }),
          child: Text(
            'Create QR',
            style: TextStyle(
                fontFamily: 'TiltNeon',
                color: scan == 'create' ? fontcolor(1.0) : fontcolor(.2),
                fontWeight: FontWeight.w500,
                fontSize: width * 0.045),
          ),
        ),
      ],
    );
  }

  Widget scanner(double height, double width, Function fontcolor) {
    return scan == 'scan'
        ? !startcamera
            ? showimage != Uint8List(0)
                ? GestureDetector(
                    onTap: () => setState(() {
                      startcamera = !startcamera;
                    }),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 181, 154, 255)),
                              color: const Color.fromARGB(255, 234, 226, 255)),
                          child: const Text(
                            'Scan to Register',
                            style: TextStyle(
                                fontFamily: 'TiltNeon',
                                fontWeight: FontWeight.w600),
                          )),
                    ),
                  )
                : Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 255, 121, 166))),
                          child: Image(
                            image: MemoryImage(showimage),
                            height: height * 0.2,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          barcode,
                          style: TextStyle(
                              fontSize: width * 0.035,
                              color: fontcolor(.6),
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            rescan = !rescan;
                            showimage = Uint8List(0);
                            barcode = '';
                          }),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(colors: [
                                  Color.fromARGB(255, 203, 232, 255),
                                  Color.fromARGB(255, 255, 198, 217)
                                ])),
                            child: Text(
                              'Rescan',
                              style: TextStyle(
                                  color: fontcolor(.9),
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
            : SizedBox(
                height: height * 0.225,
                child: MobileScanner(
                  fit: BoxFit.contain,
                  controller: MobileScannerController(
                    autoStart: startcamera,
                    returnImage: true,
                  ),
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    final Uint8List? image = capture.image;
                    barcode = barcodes.first.rawValue.toString();
                    print('i found the bar code guys....$barcode');
                    setState(() {
                      if (barcode != '') {
                        startcamera = !startcamera;
                      }
                    });

                    if (image != null) {
                      setState(() {
                        showimage = image;
                      });
                    }
                  },
                ),
              )
        : Align(
            alignment: Alignment.center,
            child: RepaintBoundary(
              key: _screenShotKey,
              child: QrImage(
                  data: '${pname.text.trim()}_${faculty_email!.trim()}',
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(6),
                  size: width * 0.3,
                  version: QrVersions.auto),
            ),
          );
  }

  TextField field(
      double width,
      String labeltext,
      TextEditingController controller,
      TextInputType type,
      IconData icon,
      Function fontcolor,
      String a) {
    return TextField(
      controller: controller,
      cursorColor: fontcolor(1.0),
      scrollPadding: EdgeInsets.zero,
      style: TextStyle(fontSize: width * 0.04, color: fontcolor(1.0)),
      keyboardType: type,
      decoration: InputDecoration(
        errorText: a == "a"
            ? controller.text.contains(RegExp(r'[a-zA-Z]'))
                ? "This Field can't have character"
                : null
            : null,
        errorStyle: TextStyle(),
        labelText: labeltext,
        labelStyle:
            TextStyle(color: fontcolor(.5), fontWeight: FontWeight.w500),
        prefixIconColor: fontcolor(.4),
        fillColor: fontcolor(.8),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: fontcolor(.9)),
            borderRadius: BorderRadius.circular(12),
            gapPadding: 6),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: fontcolor(.2)),
            borderRadius: BorderRadius.circular(8),
            gapPadding: 6),
        focusColor: fontcolor(.9),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: fontcolor(.5)),
            borderRadius: BorderRadius.circular(2),
            gapPadding: 6),
        contentPadding: EdgeInsets.zero,
        prefixIcon: Icon(
          icon,
          size: width * 0.07,
        ),
      ),
    );
  }

  Row tophead(double width, var fontcolor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        back(width: width, fontcolor: fontcolor),
        Text(
          'Add Product',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: width * 0.056,
            color: fontcolor(1.0),
          ),
        ),
        SizedBox(
          width: width * 0.07,
        )
      ],
    );
  }
}
