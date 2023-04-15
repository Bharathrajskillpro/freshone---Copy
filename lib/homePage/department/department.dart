import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'category.dart';

class department extends StatefulWidget {
  department({
    super.key,
    required this.fontcolor,
  });
  final fontcolor;

  @override
  State<department> createState() => _departmentState();
}

class _departmentState extends State<department> with TickerProviderStateMixin {
  final list = [
    'cse',
    'cce',
    'mech',
    'it',
    'ai&ds',
    'cyber',
    'eee',
    'ece',
    'csbs'
  ];
  late AnimationController controller;
  Animation<double>? animation;
  var dept = TextEditingController();

  final collection = FirebaseFirestore.instance.collection('products');

  @override
  void initState() {
    // TODO: implement initState
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    dept.dispose();
    super.dispose();
  }

  Future adddept() async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(dept.text.trim())
        .set({});
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Department',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: width * 0.045,
            color: widget.fontcolor(1.0),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: height * 0.005),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    dept.clear();
                  });
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) =>
                        AlertDialog(alignment: Alignment.center, actions: [
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'New Department',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: width * 0.04,
                              color: widget.fontcolor(1.0)),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      field(width, 'Department name', dept, TextInputType.text,
                          Icons.create, widget.fontcolor),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            adddept();
                            Navigator.pop(context);
                          },
                          child: const Text('Add'))
                    ]),
                  );
                },
                child: Image.asset(
                  'assets/icon/add.png',
                  width: width * 0.125,
                ),
              ),
              SizedBox(
                width: width * 0.7,
                height: height * 0.165,
                child: StreamBuilder(
                  stream: collection.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var snap = snapshot.data!.docs.toList();
                      return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        scrollDirection: Axis.horizontal,
                        itemCount: snap.length,
                        itemBuilder: (context, index) {
                          return single(height, width, snap[index].id, context);
                        },
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget single(double height, double width, String dep, BuildContext context) {
    var path = 'new';
    if (list.contains(dep)) {
      path = dep;
    }
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ScaleTransition(
            scale: animation,
            child: FadeTransition(
              opacity: Tween<double>(begin: 1, end: 0).animate(controller),
              child: category(controller: controller, depart: dep),
            ),
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.fontcolor(.1)),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [widget.fontcolor(.05), widget.fontcolor(0.08)])),
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'assets/icon/$path.png',
              width: width * 0.15,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Text(
              dep.length > 9
                  ? '${dep.toString().toUpperCase().substring(0, 9)}..'
                  : dep.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: width * 0.035,
                  color: widget.fontcolor(.75)),
            )
          ],
        ),
      ),
    );
  }

  TextField field(
      double width,
      String labeltext,
      TextEditingController controller,
      TextInputType type,
      IconData icon,
      Function fontcolor) {
    return TextField(
      controller: controller,
      cursorColor: widget.fontcolor(1.0),
      scrollPadding: EdgeInsets.zero,
      style: TextStyle(fontSize: width * 0.04, color: fontcolor(1.0)),
      keyboardType: type,
      decoration: InputDecoration(
        labelText: labeltext,
        labelStyle:
            TextStyle(color: widget.fontcolor(.5), fontWeight: FontWeight.w500),
        prefixIconColor: widget.fontcolor(.4),
        fillColor: widget.fontcolor(.8),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.fontcolor(.9)),
            borderRadius: BorderRadius.circular(12),
            gapPadding: 6),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.fontcolor(.2)),
            borderRadius: BorderRadius.circular(8),
            gapPadding: 6),
        focusColor: widget.fontcolor(.9),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: widget.fontcolor(.5)),
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
}
