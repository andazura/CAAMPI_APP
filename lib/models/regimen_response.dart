import 'dart:convert';

RegimenesResponse regimenesResponseFromJson(String str) => RegimenesResponse.fromJson(json.decode(str));

String regimenesResponseToJson(RegimenesResponse data) => json.encode(data.toJson());

class RegimenesResponse {
    RegimenesResponse({
        required this.ok,
        required this.regimen,
    });

    final bool ok;
    final List<RegimenModel> regimen;

    factory RegimenesResponse.fromJson(Map<String, dynamic> json) => RegimenesResponse(
        ok: json["ok"],
        regimen: List<RegimenModel>.from(json["regimen"].map((x) => RegimenModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "regimen": List<dynamic>.from(regimen.map((x) => x.toJson())),
    };
}

class RegimenModel {
    RegimenModel({
        required this.regimen,
    });

    final String regimen;

    factory RegimenModel.fromJson(Map<String, dynamic> json) => RegimenModel(
        regimen: json["regimen"],
    );

    Map<String, dynamic> toJson() => {
        "regimen": regimen,
    };
}
