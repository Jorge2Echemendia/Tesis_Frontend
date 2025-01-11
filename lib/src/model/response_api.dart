import 'dart:convert';

ResponseApi responseApiFromJson(String str) =>
    ResponseApi.fromJson(json.decode(str));

String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

class ResponseApi {
  String? msg;
  String? error;
  bool? success;
  String? token;
  dynamic data;

  ResponseApi({
    required this.msg,
    required this.error,
    required this.success,
    required this.token,
  });

  ResponseApi.fromJson(Map<String, dynamic> json) {
    msg = json["msg"];
    error = json["error"];
    success = json["success"];
    token = json["token"];

    try {
      data = json['data'];
    } catch (e) {
      print('Exception data $e');
    }
  }

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "error": error,
        "success": success,
        "token": token,
      };
}
