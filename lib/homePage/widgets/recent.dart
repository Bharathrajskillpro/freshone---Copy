import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../detail.dart';

class recent extends StatefulWidget {
  recent({
    super.key,
    required this.fontcolor,
  });
  final fontcolor;

  @override
  State<recent> createState() => _recentState();
}

class _recentState extends State<recent> with TickerProviderStateMixin {
  final list = ['cse', 'cce', 'mech', 'it', 'ai&ds', 'cyber'];
  late AnimationController controller;
  Animation<double>? animation;

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
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent',
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
              SizedBox(
                width: width - width * 0.1,
                height: height * 0.15,
                child: StreamBuilder(
                  stream: collection.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final snap = snapshot.data!.docs.toList();
                      if (snap.any((element) => element.data().isNotEmpty)) {
                        return ListView.builder(
                          padding: const EdgeInsets.all(10),
                          scrollDirection: Axis.horizontal,
                          itemCount: snap.length,
                          itemBuilder: (context, index) {
                            if (snap[index].data().values.isNotEmpty) {
                              final data =
                                  snap[index].data().values.first as Map;
                              final qr =
                                  snap[index].data().keys.first.toString();
                              return single(height, width, data, qr, context);
                            } else {
                              return SizedBox();
                            }
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            'No data found Yet!, Need to add Products',
                            style: TextStyle(
                                color: widget.fontcolor(.6),
                                fontWeight: FontWeight.w600,
                                fontSize: width * 0.04),
                          ),
                        );
                      }
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

  Widget single(
      double height, double width, Map data, String qr, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ScaleTransition(
            scale: animation,
            child: FadeTransition(
              opacity: Tween<double>(begin: 1, end: 0).animate(controller),
              child: detail(
                data: data,
                qr: qr,
                fromwere: 'recent',
              ),
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
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            QrImage(
              data: qr,
              size: width * 0.15,
              foregroundColor: widget.fontcolor(.9),
            ),
            Text(
              data['name'].length > 9
                  ? '${data['name'].toString().toUpperCase().substring(0, 9)}..'
                  : data['name'].toUpperCase(),
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
}
