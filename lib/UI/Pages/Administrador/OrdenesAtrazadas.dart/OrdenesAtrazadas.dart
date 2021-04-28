import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdenesAtrazadas extends StatefulWidget {
  final QuerySnapshot data;
  OrdenesAtrazadas({Key key,@required this.data}) : super(key: key);

  @override
  _OrdenesAtrazadasState createState() => _OrdenesAtrazadasState();
}

class _OrdenesAtrazadasState extends State<OrdenesAtrazadas> {
  List entrega;
  bool isLoading = true;
  @override
  void initState() {
    setState(() {
      isLoading = false;
      entrega = widget.data.docs;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List data = entrega;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text('Pedidos Atrazados', style: TextStyle(fontSize: 18, color: Colors.black),),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_outlined), onPressed:()=>Navigator.pop(context)),
      ),
      body: Container(
          height: size.height,
          child: data.length == 0
              ? Center(
                  child: Text('No tenemos ordenes atrazadas'),
                )
              : validate(isLoading, data)),
    );
  }

  Widget validate(bool isLoading, List data) {
    if (isLoading) {
      return Center(
          child: Container(
        child: CircularProgressIndicator(),
      ));
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: data.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black)),
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Orden Atrazada', style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),),
                        Text(
                          '${data[index]['direccion']}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${data[index]['name']}',
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text(
                              '${data[index]['producto']}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              ' ${data[index]['person']}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text('|'),
                            Text('Total: ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            Text(
                              '${data[index]['precio']}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${data[index]['fecha']}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'estado: ${data[index]['staterepartidor']}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Container(
                          child: Text(
                            '${data[index]['nota']}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    ),
                  ],
                )));
      },
    );
  }
}
