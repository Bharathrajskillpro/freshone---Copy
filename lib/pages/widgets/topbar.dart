import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshone/auth.dart';

class topbar extends StatefulWidget {
  const topbar({
    super.key,
    required this.fontcolor,
  });

  final Color Function(dynamic opacity) fontcolor;

  @override
  State<topbar> createState() => _topbarState();
}

class _topbarState extends State<topbar> {
  String? email = auth().currentUser!.email;
  String? name;
  String? photo;

  @override
  void initState() {
    // TODO: implement initState
    finder();
    super.initState();
  }

  Future finder() async {
    final entity =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    final entries = entity.data()!.entries;
    setState(() {
      name = entries.firstWhere((element) => element.key == 'name').value;
      photo = entries.firstWhere((element) => element.key == 'photo').value;
      print(name);
      print(photo);
    });

    print(name);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        auth().signout();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color.fromARGB(255, 217, 217, 217)),
        ),
        padding: const EdgeInsets.all(6),
        child: photo != null
            ? Image.network(
                photo.toString(),
                fit: BoxFit.cover,
                height: height * 0.07,
                width: height * 0.07,
              )
            : Icon(
                Icons.person,
                size: height * 0.07,
              ),
      ),
    );
    // StreamBuilder(
    //     stream: FirebaseFirestore.instance
    //         .collection('users')
    //         .doc(email)
    //         .get()
    //         .asStream(),
    //     builder: (context, snapshot) {
    //       print(auth().currentUser!.email);
    //       if (snapshot.error != null) {
    //         return Text('dfg');
    //       }
    //       if (snapshot.hasData) {
    //         final entries = snapshot.data!.data()!.entries;
    //         final name =
    //             entries.firstWhere((element) => element.key == 'name').value;
    //         final photo =
    //             entries.firstWhere((element) => element.key == 'photo').value;
    //         return Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             Column(
    //               mainAxisAlignment: MainAxisAlignment.spaceAround,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   'welcome',
    //                   style: TextStyle(
    //                       color: widget.fontcolor(0.5),
    //                       fontWeight: FontWeight.w500,
    //                       fontSize: width * 0.045),
    //                 ),
    //                 const SizedBox(
    //                   height: 4,
    //                 ),
    //                 Text(
    //                   name,
    //                   style: TextStyle(
    //                       color: widget.fontcolor(1.0),
    //                       fontWeight: FontWeight.w600,
    //                       fontSize: width * 0.055),
    //                 ),
    //               ],
    //             ),
    //             GestureDetector(
    //               onTap: () {
    //                 auth().signout();
    //               },
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(8),
    //                   border: Border.all(
    //                       color: const Color.fromARGB(255, 217, 217, 217)),
    //                 ),
    //                 padding: const EdgeInsets.all(6),
    //                 child: photo != null
    //                     ? Image.network(
    //                         photo.toString(),
    //                         fit: BoxFit.cover,
    //                         height: height * 0.07,
    //                         width: height * 0.07,
    //                       )
    //                     : Icon(
    //                         Icons.person,
    //                         size: height * 0.07,
    //                       ),
    //               ),
    //             )
    //           ],
    //         );
    //       } else {
    //         print('nodata');
    //         return SizedBox();
    //       }
    //     });
    // }
  }
}
