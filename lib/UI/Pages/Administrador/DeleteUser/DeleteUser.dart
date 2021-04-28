import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_diego_lechona/UI/Pages/Authenticate/Widgets/Logo.dart';
import 'package:demo_diego_lechona/data/Repository/Repository_Alterno.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteUsers extends StatefulWidget {
  final QuerySnapshot data;
  DeleteUsers({Key key, @required this.data}) : super(key: key);

  @override
  _DeleteUsersState createState() => _DeleteUsersState();
}

class _DeleteUsersState extends State<DeleteUsers> {
  bool isLoading = true;
  QuerySnapshot docdta;
  @override
  void initState() {
    setState(() {
      docdta = widget.data;
      isLoading = false;
    });
    super.initState();
  }

  RepositoryAlterno _alterno = RepositoryAlterno();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: docdta.docs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black)),
                height: 120,
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Logo(
                      kheight: 100,
                      kwidth: 90,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              docdta.docs[index]['fullName'],
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Text(
                            'Cel. ' + docdta.docs[index]['telefono'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            docdta.docs[index]['email'],
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                            overflow: TextOverflow.fade,
                          )
                        ],
                      ),
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () async {
                        final resp = await _alterno.deleteUser(
                            email: docdta.docs[index]['email'],
                            phone: docdta.docs[index]['telefono'],
                            name: docdta.docs[index]['fullName'],
                            role: docdta.docs[index]['role']);
                        if (resp != null) {
                          Navigator.pop(context);
                        } else {
                          return showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('No podemos concretar esta accion'),
                                content: Text('Intente mas tarde'),
                              ));
                        }
                      },
                      child: Icon(
                        CupertinoIcons.trash,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
