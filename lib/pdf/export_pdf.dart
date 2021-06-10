import 'dart:io';
import 'package:bottom_navigation/controllers/weeklyAuditController.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class dataAudit {
  final int no;
  final String subject;
  final String description;
  final String target;
  final String result;
  final String photo;
  final String remarks;

  dataAudit(
      {this.no,
      this.subject,
      this.description,
      this.target,
      this.result,
      this.photo,
      this.remarks});
}

class ExportPdfApi {
  static Future<File> saveDocument({
    String name,
    Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static Future<File> generateMyPDF(
      {id, station, tgl, title, aln, score, auditedBy, auditedNo}) async {
    final WeeklyAuditController _listAnggotaController =
        Get.put(WeeklyAuditController());

    final pdf = Document();

    final headers = [
      'No',
      'Description',
      'How to show\nif any Photo?',
      'Remarks'
    ];

    var anggotas = _listAnggotaController.dataList;

    List<dataAudit> users = [];

    for (var i = 0; i < anggotas.length; i++) {
      //for (var i = 0; i < 100; i++) {

      users = users +
          ([
            dataAudit(
              no: i + 1,
              description: anggotas[i].description,
              photo: anggotas[i].idGambar,
              remarks: anggotas[i].remark,
            )
          ]);
    }

    final data = users
        .map((user) => [user.no, user.description, user.photo, user.remarks])
        .toList();

    pdf.addPage(
      MultiPage(
        maxPages: 100,
        build: (context) => [
          buildTitle(),
          SizedBox(height: 15),
          Table.fromTextArray(
            headers: headers,
            data: data,
            columnWidths: {
              0: const FractionColumnWidth(3),
              1: const FractionColumnWidth(15),
              2: const FractionColumnWidth(8),
              3: const FractionColumnWidth(10),
            },
            cellAlignments: {
              0: Alignment.center,
              1: Alignment.centerLeft,
              2: Alignment.centerLeft,
              3: Alignment.center,
            },
          ),
          SizedBox(height: 20),
          buildListImage(),
        ],
      ),
    );
    return saveDocument(name: 'data.pdf', pdf: pdf);
  }

  static Widget buildListImage() {
    final WeeklyAuditController _controller = Get.put(WeeklyAuditController());

    return ListView.builder(
        itemCount: _controller.dataList.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            horizontalRadius: 32,
            verticalRadius: 32,
            child: Image(
              MemoryImage(viewImage(_controller.dataList[index].idGambar)),
              height: 100,
            ),
          );
        });
  }

  static viewImage(image) async {
    print(image);

    final imageJpg1 = (await NetworkAssetBundle(Uri.parse(image)).load(image))
        .buffer
        .asUint8List();

    return imageJpg1;
  }

  static Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.7 * PdfPageFormat.cm),
          Text(
            'Data Tabel PDF with Image',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.1 * PdfPageFormat.cm),
        ],
      );
}
