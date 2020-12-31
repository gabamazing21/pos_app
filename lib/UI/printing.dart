import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_app/Models/OrderDetail.dart';
import 'package:pos_app/Models/OrderItem.dart';
import 'package:pos_app/Utils/utils.dart';
import 'package:pos_app/component/tool_bar.dart';
import 'package:printing/printing.dart';

class MyPrint extends StatefulWidget {
  OrderDetails itemPrint;
  VoidCallback callback;
  MyPrint(this.itemPrint, this.callback);

  @override
  _MyPrintState createState() => _MyPrintState(itemPrint, callback);
}

class _MyPrintState extends State<MyPrint> {
  OrderDetails itemPrinting;
  VoidCallback callback;
  _MyPrintState(this.itemPrinting, this.callback);

  final String title = 'king is a billionaire';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(top: 30),
                  child: ToolBar(
                    callback: callback,
                    title: 'Printing',
                  )),
              Expanded(
                child: Container(
                  child: PdfPreview(
                    build: (format) => _generatePdf(format, title),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
    String title,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Center(
            child: pw.Column(children: [
              pw.ListView.builder(
                  itemBuilder: (pw.Context context, int index) =>
                      _printItem(itemPrinting.product.elementAt(index)),
                  itemCount: itemPrinting.product.length),
              pw.Row(children: [
                pw.Text('Total Price  ='),
                pw.SizedBox(width: 10),
                pw.Text(utils.localcurrency((itemPrinting.amount))),
              ]),
              pw.SizedBox(height: 5),
              pw.Row(children: [
                pw.Text('Change  ='),
                pw.SizedBox(width: 10),
                pw.Text(utils.localcurrency((itemPrinting.chargeToReceived))),
              ]),
            ]),
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _printItem(Orderitem orderitem) {
    return pw.Row(children: [
      pw.Text(orderitem.orderItemname),
      pw.SizedBox(width: 10),
      pw.Text('x'),
      pw.SizedBox(width: 10),
      pw.Text('${orderitem.quantity}'),
      pw.SizedBox(width: 10),
      pw.Text('price'),
    ]);
  }
}
