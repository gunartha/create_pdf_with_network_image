import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'button_widget.dart';
import 'pdf/export_pdf.dart';
import 'controllers/weeklyAuditController.dart';

class PdfPage extends StatefulWidget {
  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  final WeeklyAuditController _controllerQuestion =
      Get.put(WeeklyAuditController());

  @override
  void initState() {
    _controllerQuestion.fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _controllerQuestion.dataList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 24),
                ButtonWidget(
                  text: 'Export PDF',
                  onClicked: () async {
                    final pdfFile = await ExportPdfApi.generateMyPDF();
                    ExportPdfApi.openFile(pdfFile);
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
