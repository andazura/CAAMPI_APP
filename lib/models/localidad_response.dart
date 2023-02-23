// To parse this JSON data, do
//
//     final localidadesResponse = localidadesResponseFromJson(jsonString);

import 'dart:convert';

LocalidadesResponse localidadesResponseFromJson(String str) => LocalidadesResponse.fromJson(json.decode(str));

String localidadesResponseToJson(LocalidadesResponse data) => json.encode(data.toJson());

class LocalidadesResponse {
    LocalidadesResponse({
        required this.ok,
        required this.localidades,
    });

    bool ok;
    List<LocalidadesModel> localidades;

    factory LocalidadesResponse.fromJson(Map<String, dynamic> json) => LocalidadesResponse(
        ok: json["ok"],
        localidades: List<LocalidadesModel>.from(json["localidades"].map((x) => LocalidadesModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "localidades": List<dynamic>.from(localidades.map((x) => x.toJson())),
    };
}

class LocalidadesModel {
    LocalidadesModel({
        required this.codigo,
        required this.value,
    });

    String codigo;
    String value;

    factory LocalidadesModel.fromJson(Map<String, dynamic> json) => LocalidadesModel(
        codigo: json["codigo"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "value": value,
    };
}
