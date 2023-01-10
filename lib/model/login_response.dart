class LoginResponse {
  bool? _success;
  String? _message;
  int? _statusCode;
  List<String>? _errors;
  bool? _data;

  LoginResponse(
      {bool? success,
      String? message,
      int? statusCode,
      List<String>? errors,
      bool? data}) {
    this._success = success;
    this._message = message;
    this._statusCode = statusCode;
    this._errors = errors;
    this._data = data;
  }

  bool get success => _success!;
  set success(bool success) => _success = success;
  String get message => _message!;
  set message(String message) => _message = message;
  int get statusCode => _statusCode!;
  set statusCode(int statusCode) => _statusCode = statusCode;
  List<String> get errors => _errors!;
  set errors(List<String> errors) => _errors = errors;
  bool get data => _data!;
  set data(bool data) => _data = data;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    _success = json['Success'];
    _message = json['Message'];
    _statusCode = json['StatusCode'];
    _errors = json['Errors'].cast<String>();
    _data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Success'] = this._success;
    data['Message'] = this._message;
    data['StatusCode'] = this._statusCode;
    data['Errors'] = this._errors;
    data['data'] = this._data;
    return data;
  }
}
