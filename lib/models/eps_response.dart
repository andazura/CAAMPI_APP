import 'dart:convert';

EpsResponse epsResponseFromJson(String str) => EpsResponse.fromJson(json.decode(str));

String epsResponseToJson(EpsResponse data) => json.encode(data.toJson());

class EpsResponse {
    EpsResponse({
        required this.ok,
        required this.eps,
    });

    final bool ok;
    final List<EpsModel> eps;

    factory EpsResponse.fromJson(Map<String, dynamic> json) => EpsResponse(
        ok: json["ok"],
        eps: List<EpsModel>.from(json["eps"].map((x) => EpsModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "eps": List<dynamic>.from(eps.map((x) => x.toJson())),
    };
}

class EpsModel {
    EpsModel({
        required this.eapb,
    });

    final String eapb;

    factory EpsModel.fromJson(Map<String, dynamic> json) => EpsModel(
        eapb: json["EAPB"],
    );

    Map<String, dynamic> toJson() => {
        "EAPB": eapb,
    };
}
