import 'dart:convert';

DiagnosticosResponse diagnosticosResponseFromJson(String str) => DiagnosticosResponse.fromJson(json.decode(str));

String diagnosticosResponseToJson(DiagnosticosResponse data) => json.encode(data.toJson());

class DiagnosticosResponse {
    DiagnosticosResponse({
        required this.ok,
        required this.diagnosticos,
    });

    final bool ok;
    final List<DiagnosticoModel> diagnosticos;

    factory DiagnosticosResponse.fromJson(Map<String, dynamic> json) => DiagnosticosResponse(
        ok: json["ok"],
        diagnosticos: List<DiagnosticoModel>.from(json["diagnosticos"].map((x) => DiagnosticoModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "diagnosticos": List<dynamic>.from(diagnosticos.map((x) => x.toJson())),
    };
}

class DiagnosticoModel {
    DiagnosticoModel({
        required this.codigo,
        required this.nombre,
    });

    final String codigo;
    final String nombre;

    factory DiagnosticoModel.fromJson(Map<String, dynamic> json) => DiagnosticoModel(
        codigo: json["Codigo"],
        nombre: json["Nombre"],
    );

    Map<String, dynamic> toJson() => {
        "Codigo": codigo,
        "Nombre": nombre,
    };
}
