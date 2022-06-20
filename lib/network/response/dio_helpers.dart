import 'package:dio/dio.dart';

class DioHelpers {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://flights-api-02.herokuapp.com/api/v1",
        receiveDataWhenStatusError: true,
        receiveTimeout: 30 * 1000,
        connectTimeout: 30 * 1000,
      ),
    );
  }

  static Future<Response> getAllFlights({required url}) async {
    return await dio.get(
      url,
    );
  }

  static Future<Response> chooseFlight(
      {required token, required url, required data}) async {
    return await dio.get(
      url,
      queryParameters: {
        "from": data["from"],
        "to": data["to"],
        "flightDate": data["flightDate"],
        "PriceOfTheFlight": data["PriceOfTheFlight"]
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ' + token,
        },
      ),
    );
  }

  static Future<Response> logIn({required logInData, required url}) async {
    return await dio.post(
      url,
      data: logInData,
      options: Options(
        contentType: 'application/json',
          validateStatus: (_) => true
      ),
    );
  }

  static Future<Response> signUp({required signUpData, required url}) async {
    return await dio.post(
      url,
      data: signUpData,
      options: Options(
          contentType: 'application/json',
          validateStatus: (_) => true
      ),
    );
  }

  static Future<Response> myFlights({required token, required url}) async {
    return dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer ' + token,
        },
      ),
    );
  }

  static Future<Response> saveProfileInfo(
      {required token, required url, required data}) async {
    return await dio.patch(
      url,
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer ' + token,
        },
      ),
    );
  }

  static Future<Response> createTicket(
      {required url, required token, required body, required details}) async {
    return await dio.post(
      url + details['flightID'],
      queryParameters: {
        "from": details['from'],
        "to": details['to'],
        "flightID": details['flightID']
      },
      options: Options(headers: {
        'Authorization': 'Bearer ' + token,
      }),
      data: body,
    );
  }

  static Future<Response> deleteTicket(
      {required url, required token, required tickedId}) async {
    return await dio.delete(
      url + "$tickedId",
      queryParameters: {"ticketID": "$tickedId"},
      options: Options(headers: {
        'Authorization': 'Bearer ' + token,
      }),
    );
  }

  static Future<Response> ticketInfo(
      {required url, required token, required data}) async {
    return await dio.get(
      url + data['flightId'],
      options: Options(
        headers: {
          'Authorization': 'Bearer ' + token,
        }
      ),
      queryParameters: data
    );
  }
}
