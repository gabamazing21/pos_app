import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_app/Models/OrderDetail.dart';
import 'package:pos_app/Models/OrderItem.dart';
import 'package:pos_app/Utils/utils.dart';
import 'package:pos_app/component/tool_bar.dart';
import 'package:printing/printing.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

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
  ByteData _byteData;
  _MyPrintState(this.itemPrinting, this.callback);
  File imagefile;
  final String title = 'king is a billionaire';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImagefromFile('images/start_logo.png');
  }

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
          final image = pw.MemoryImage(_byteData.buffer.asUint8List());

          return pw.Center(
            child: pw.Column(children: [
              pw.Container(
                height: 100,
                width: 100,
                child: pw.Image.provider(image),
              ),
              pw.SizedBox(height: 15),
              pw.Text(
                'POLLO CAMPELL\'s ',
                textAlign: pw.TextAlign.left,
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                height: 20,
                child: pw.Stack(
                  children: [
                    pw.Positioned(
                      left: 10,
                      top: 5,
                      child: pw.Text('Guayaquil y rocafuerte'),
                    ),
                    pw.Positioned(
                      right: 10,
                      top: 5,
                      //Get Date from Item
                      child: pw.Text(
                          '${itemPrinting.orderCreation.toDate().toLocal().toString().split(" ")[0]}'),
                    )
                  ],
                ),
              ),
              pw.Container(
                height: 40,
                child: pw.Stack(
                  //mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Positioned(
                        left: 10,
                        top: 4,
                        child: pw.Text('Milagro 00121',
                            textAlign: pw.TextAlign.left)),
                    pw.Positioned(
                        right: 10,
                        top: 4,
                        //Get time from item
                        child: pw.Text(
                            '${itemPrinting.orderCreation.toDate().toLocal().toString().split(" ")[1].split(".")[0]}',
                            textAlign: pw.TextAlign.right)),
                    pw.Positioned(
                      left: 10,
                      top: 20,
                      child: pw.Text('593990012734'),
                    )
                  ],
                ),
              ),
              pw.Text('PURCHASE'),

              pw.Divider(
                thickness: 2,
                height: 10,
                color: PdfColors.black,
              ),
              pw.SizedBox(height: 10),

              //Get Ticket From item

              pw.Container(
                height: 30,
                child: pw.Stack(children: [
                  pw.Positioned(
                    left: 10,
                    child: pw.Text('Ticket: #63'),
                  ),
                  pw.Positioned(
                    left: 10,
                    top: 12,
                    child: pw.Text('Receipt TrmM'),
                  )
                ]),
              ),

              pw.Divider(
                thickness: 1,
                height: 10,
                color: PdfColors.black,
              ),
              pw.SizedBox(height: 10),

              pw.ListView.builder(
                  padding: pw.EdgeInsets.all(0),
                  itemBuilder: (pw.Context context, int index) =>
                      _printItem(itemPrinting.product.elementAt(index)),
                  itemCount: itemPrinting.product.length),

              pw.Divider(
                thickness: 1,
                height: 10,
                color: PdfColors.black,
              ),
              pw.SizedBox(height: 10),

              pw.Row(
                children: [
                  pw.Text('Total Price  ='),
                  pw.SizedBox(width: 10),
                  pw.Text(utils.localcurrency((itemPrinting.amount))),
                ],
              ),
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
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Container(
              //  width: MediaQuery.of(context).size.width * 0.2,
              child: pw.Text(orderitem.orderItemname)),
          pw.SizedBox(width: 10),
          pw.Text('x ${orderitem.quantity}'),
          pw.SizedBox(width: 10),
          pw.Text('price'),
        ]);
  }

  Future<File> getImagefromFile(String path) {
    rootBundle.load('assets/$path').then((value) {
      setState(() {
        _byteData = value;
      });
    });
  }
}
