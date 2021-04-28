import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/Widgets/TotalOrdenesTexto.dart';
import 'package:demo_diego_lechona/data/Repository/Repository.dart';
import 'package:demo_diego_lechona/UI/Utils/Paddins.dart';
import 'package:flutter/material.dart';

class TOrdenes extends StatefulWidget {
  final Size size;
  TOrdenes({Key key, @required this.size}) : super(key: key);

  @override
  _TOrdenesState createState() => _TOrdenesState();
}

class _TOrdenesState extends State<TOrdenes> {
  BlocOtherRepository _repository = BlocOtherRepository();
  int numero, totalpedidos, pendiente;
  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kPaddinDefaulHorizontal / 2),
      child: Container(
        height: 140,
        width: size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Color(0xff9DA8BA)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Order(
            orderText: '\nPendientes',
            ordernumber: pendiente == null? 0 :pendiente, 
            press: () => contabilizar3()),
            Order(
              orderText: '  Ordenes\nEntregadas',
              ordernumber: totalpedidos == null? 0 : totalpedidos,
              press: () => contabilizar2(),
            ),
            Order(
              press: () => contabilizar(),
              orderText: '\nTotal',
              ordernumber: numero == null ? 0 : numero,
            )
          ],
        ),
      ),
    );
  }

  contabilizar() async {
    final QuerySnapshot total = await _repository.getPedidos();
    final List data = total.docs;
    setState(() {
      numero = data.length;
    });
  }

  contabilizar2() async {
    final QuerySnapshot total = await _repository.getPedidoEntregadosTotal();
    final List data = total.docs;
    setState(() {
      totalpedidos = data.length;
    });
  }
  contabilizar3() async {
    final QuerySnapshot total = await _repository.getPendientes();
    final List data = total.docs;
    setState(() {
      pendiente = data.length;
    });
  }
}
