// To parse this JSON data, do
//
//     final auditDetailModel = auditDetailModelFromJson(jsonString);

import 'dart:convert';

List<AuditDetailModel> auditDetailModelFromJson(String str) =>
    List<AuditDetailModel>.from(
        json.decode(str).map((x) => AuditDetailModel.fromJson(x)));

String auditDetailModelToJson(List<AuditDetailModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AuditDetailModel {
  AuditDetailModel({
    this.id,
    this.description,
    this.idGambar,
    this.remark,
  });

  String id;
  String description;
  String idGambar;
  String remark;

  factory AuditDetailModel.fromJson(Map<String, dynamic> json) =>
      AuditDetailModel(
        id: json["id"],
        description: json["description"],
        idGambar: json["id_gambar"],
        remark: json["remark"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "id_gambar": idGambar,
        "remark": remark,
      };
}
