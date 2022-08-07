import 'dart:async';
import 'dart:convert' as convert;

import 'package:bet/config/config.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';
import 'package:line_icons/line_icons.dart';

import '../global/internet.dart';
import '../global/notification.dart';
import '../global/storage.dart';

class RemoteServices {
  static var client = Dio();

  static String url = AddressConfig.apiBaseUrl;

  static Future<dynamic> signUpService(var data) async {
    if (await checkConnectionInternet()) {
      String theUrl = '$url/users/register';
      try {
        Response response = await client
            .post(theUrl,
                options: Options(headers: {
                  'content-type': 'application/json',
                  'accept': "*/*",
                  'access-control-allow-origin': "Accept",
                }),
                data: data)
            .timeout(const Duration(seconds: 10));
        return response.data;
      } on TimeoutException catch (_) {
        showSnackbar("Error", "Time Out", LineIcons.exclamationTriangle);
        return null;
      } on DioError catch (error) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          handle401_403Status();
          return null;
        } else {
          return error.response?.data;
        }
      }
    } else {
      showSnackbar(
          "Error", "Internet disconnected", LineIcons.exclamationTriangle);
      return null;
    }
  }

  static Future<dynamic> checkUserService(String data) async {
    if (await checkConnectionInternet()) {
      String theUrl = '$url/users/username=$data';
      try {
        Response response = await client
            .get(
              theUrl,
              options: Options(
                  validateStatus: (status) {
                    return status! < 500;
                  },
                  headers: {
                    'content-type': 'application/json',
                    'accept': "*/*",
                    'access-control-allow-origin': "Accept",
                  }),
            )
            .timeout(const Duration(seconds: 10));
        return response.data;
      } on TimeoutException catch (_) {
        showSnackbar("Error", "Time Out", LineIcons.exclamationTriangle);
        return null;
      } on DioError catch (error) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          handle401_403Status();
          return null;
        } else {
          return error.response?.data;
        }
      }
    } else {
      showSnackbar(
          "Error", "Internet disconnected", LineIcons.exclamationTriangle);
      return null;
    }
  }

  static Future<dynamic> twoAuthOptionService(var data) async {
    if (await checkConnectionInternet()) {
      String theUrl = '$url/users/securityOptions';
      try {
        String token = await getValue('token');
        Response response = await client
            .patch(theUrl,
                options: Options(
                    validateStatus: (status) {
                      return status! < 500;
                    },
                    headers: {
                      'content-type': 'application/json',
                      'accept': "*/*",
                      'access-control-allow-origin': "Accept",
                      'Authorization': "Bearer $token",
                    }),
                data: convert.json.encode(data))
            .timeout(const Duration(seconds: 10));
        return response.data;
      } on TimeoutException {
        showSnackbar("Error", "Time Out", LineIcons.exclamationTriangle);
        return null;
      } on DioError catch (error) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          handle401_403Status();
          return null;
        } else {
          return error.response?.data;
        }
      }
    } else {
      showSnackbar(
          "Error", "Internet disconnected", LineIcons.exclamationTriangle);
      return null;
    }
  }

  static Future<dynamic> logInService(var data) async {
    if (await checkConnectionInternet()) {
      String theUrl = '$url/auth/login';
      try {
        Response response = await client
            .post(theUrl,
                options: Options(validateStatus: (status) => true, headers: {
                  'content-type': 'application/json',
                  'accept': "*/*",
                  'access-control-allow-origin': "Accept",
                }),
                data: convert.jsonEncode(data))
            .timeout(const Duration(seconds: 20));
        // print("++++++++++++++++++++++++ login");
        // print(response.data);
        return response.data;
      } on TimeoutException catch (_) {
        showSnackbar("Error", "Time Out", LineIcons.exclamationTriangle);
        return null;
      } on DioError catch (error) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          handle401_403Status();
          return null;
        } else {
          return error.response?.data;
        }
      }
    } else {
      showSnackbar(
          "Error", "Internet disconnected", LineIcons.exclamationTriangle);
      return null;
    }
  }

  static Future<dynamic> twoAuthForLogin(var data, String token) async {
    if (await checkConnectionInternet()) {
      String theUrl = '$url/auth/twoFactorAuth';
      try {
        Response response = await client
            .post(theUrl,
                options: Options(validateStatus: (status) => true, headers: {
                  'content-type': 'application/json',
                  'accept': "*/*",
                  'access-control-allow-origin': "Accept",
                  'Authorization': "Bearer $token"
                }),
                data: convert.jsonEncode(data))
            .timeout(const Duration(seconds: 20));
        return response.data;
      } on TimeoutException catch (_) {
        showSnackbar("Error", "Time Out", LineIcons.exclamationTriangle);
        return null;
      } on DioError catch (error) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          handle401_403Status();
          return null;
        } else {
          return error.response?.data;
        }
      }
    } else {
      showSnackbar(
          "Error", "Internet disconnected", LineIcons.exclamationTriangle);
      return null;
    }
  }

  static Future<dynamic> getUserInfoService() async {
    String token = await getValue('token');
    if (await checkConnectionInternet()) {
      String theUrl = '$url/users/';
      try {
        Response response = await client
            .get(
              theUrl,
              options: Options(headers: {
                'content-type': 'application/json',
                'accept': "*/*",
                'access-control-allow-origin': "Accept",
                'Authorization': "Bearer $token",
              }),
            )
            .timeout(const Duration(seconds: 10));
        // print("+++++++++++++++++++++++++ get user data");
        // print(response.data);
        return response.data;
      } on TimeoutException catch (_) {
        showSnackbar("Error", "Time Out", LineIcons.exclamationTriangle);
        return null;
      } on DioError catch (error) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          handle401_403Status();
          return null;
        } else {
          return error.response?.data;
        }
      }
    } else {
      showSnackbar(
          "Error", "Internet disconnected", LineIcons.exclamationTriangle);
      return null;
    }
  }

  static Future<dynamic> getUserStateService(String userID) async {
    if (await checkConnectionInternet()) {
      String theUrl = '$url/journal/users/$userID/stats';
      try {
        Response response = await client
            .get(
              theUrl,
              options: Options(headers: {
                'content-type': 'application/json',
                'accept': "*/*",
                'access-control-allow-origin': "Accept",
              }),
            )
            .timeout(const Duration(seconds: 10));
        return response.data;
      } on TimeoutException catch (_) {
        showSnackbar("Error", "Time Out", LineIcons.exclamationTriangle);
        return null;
      } on DioError catch (error) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          handle401_403Status();
          return null;
        } else {
          return error.response?.data;
        }
      }
    } else {
      showSnackbar(
          "Error", "Internet disconnected", LineIcons.exclamationTriangle);
      return null;
    }
  }

  static Future<dynamic> logOutService() async {
    String token = await getValue('token');
    // print(token);
    if (await checkConnectionInternet()) {
      String theUrl = '$url/auth/logout/';
      try {
        Response response = await client
            .delete(
              theUrl,
              options: Options(headers: {
                'content-type': 'application/json',
                'accept': "*/*",
                'access-control-allow-origin': "Accept",
                'Authorization': "Bearer $token",
              }),
            )
            .timeout(const Duration(seconds: 10));
        // print(response.data);
        return response.data;
      } on TimeoutException catch (_) {
        showSnackbar("Error", "Time Out", LineIcons.exclamationTriangle);
        return null;
      } on DioError catch (error) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          handle401_403Status();
          return null;
        } else {
          return error.response?.data;
        }
      }
    } else {
      showSnackbar(
          "Error", "Internet disconnected", LineIcons.exclamationTriangle);
      return null;
    }
  }

  static Future<dynamic> changePasswordService(var data) async {
    String token = await getValue('token');
    if (await checkConnectionInternet()) {
      String theUrl = '$url/users/password';
      try {
        Response response = await client
            .patch(theUrl,
                options: Options(headers: {
                  'content-type': 'application/json',
                  'accept': "*/*",
                  'access-control-allow-origin': "Accept",
                  'Authorization': "Bearer $token",
                }),
                data: data)
            .timeout(const Duration(seconds: 10));
        return response.data;
      } on TimeoutException catch (_) {
        showSnackbar("Error", "Time Out", LineIcons.exclamationTriangle);
        return null;
      } on DioError catch (error) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          handle401_403Status();
          return null;
        } else {
          return error.response?.data;
        }
      }
    } else {
      showSnackbar(
          "Error", "Internet disconnected", LineIcons.exclamationTriangle);
      return null;
    }
  }

  static Future<dynamic> resetPasswordService(var data) async {
    if (await checkConnectionInternet()) {
      String theUrl = '$url/auth/resetPassword';
      try {
        Response response = await client
            .post(theUrl,
                options: Options(headers: {
                  'content-type': 'application/json',
                  'accept': "*/*",
                  'access-control-allow-origin': "Accept",
                }),
                data: data)
            .timeout(const Duration(seconds: 10));
        return response.data;
      } on TimeoutException catch (_) {
        showSnackbar("Error", "Time Out", LineIcons.exclamationTriangle);
        return null;
      } on DioError catch (error) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          handle401_403Status();
          return null;
        } else {
          return error.response?.data;
        }
      }
    } else {
      showSnackbar(
          "Error", "Internet disconnected", LineIcons.exclamationTriangle);
      return null;
    }
  }

  static Future<dynamic> sendForgetPasswordService(var data) async {
    if (await checkConnectionInternet()) {
      String theUrl = '$url/auth/forgetPassword';
      try {
        Response response = await client
            .post(theUrl,
                options: Options(headers: {
                  'content-type': 'application/json',
                  'accept': "*/*",
                  'access-control-allow-origin': "Accept",
                }),
                data: data)
            .timeout(const Duration(seconds: 10));
        return response.data;
      } on TimeoutException catch (_) {
        showSnackbar("Error", "Time Out", LineIcons.exclamationTriangle);
        return null;
      } on DioError catch (error) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          handle401_403Status();
          return null;
        } else {
          return error.response?.data;
        }
      }
    } else {
      showSnackbar(
          "Error", "Internet disconnected", LineIcons.exclamationTriangle);
      return null;
    }
  }

  static Future<dynamic> swapService(var data) async {
    String token = await getValue('token');
    if (await checkConnectionInternet()) {
      String theUrl = '$url/users/balance/swap';
      try {
        Response response = await client
            .patch(theUrl,
                options: Options(headers: {
                  'content-type': 'application/json',
                  'accept': "*/*",
                  'access-control-allow-origin': "Accept",
                  'Authorization': "Bearer $token",
                }),
                data: data)
            .timeout(const Duration(seconds: 10));
        return response.data;
      } on TimeoutException catch (_) {
        showSnackbar("Error", "Time Out", LineIcons.exclamationTriangle);
        return null;
      } on DioError catch (error) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          handle401_403Status();
          return null;
        } else {
          return error.response?.data;
        }
      }
    } else {
      showSnackbar(
          "Error", "Internet disconnected", LineIcons.exclamationTriangle);
      return null;
    }
  }

  static Future<dynamic> depositService(var data) async {
    String token = await getValue('token');
    if (await checkConnectionInternet()) {
      String theUrl = '$url/transactions/init';
      try {
        Response response = await client
            .post(theUrl,
                options: Options(headers: {
                  'content-type': 'application/json',
                  'accept': "*/*",
                  'access-control-allow-origin': "Accept",
                  'Authorization': "Bearer $token",
                }),
                data: data)
            .timeout(const Duration(seconds: 10));
        return response.data;
      } on TimeoutException catch (_) {
        showSnackbar("Error", "Time Out", LineIcons.exclamationTriangle);
        return null;
      } on DioError catch (error) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          handle401_403Status();
          return null;
        } else {
          return error.response?.data;
        }
      }
    } else {
      showSnackbar(
          "Error", "Internet disconnected", LineIcons.exclamationTriangle);
      return null;
    }
  }

  static Future<dynamic> updateAddressService(var data) async {
    String token = await getValue('token');
    if (await checkConnectionInternet()) {
      String theUrl = '$url/users/publicAddress';
      try {
        Response response = await client
            .patch(theUrl,
                options: Options(headers: {
                  'content-type': 'application/json',
                  'accept': "*/*",
                  'access-control-allow-origin': "Accept",
                  'Authorization': "Bearer $token",
                }),
                data: data)
            .timeout(const Duration(seconds: 10));
        // print(data);
        return response.data;
      } on TimeoutException catch (_) {
        showSnackbar("Error", "Time Out", LineIcons.exclamationTriangle);
        return null;
      } on DioError catch (error) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          handle401_403Status();
          return null;
        } else {
          return error.response?.data;
        }
      }
    } else {
      showSnackbar(
          "Error", "Internet disconnected", LineIcons.exclamationTriangle);
      return null;
    }
  }

  static Future<dynamic> getFeeService(var data) async {
    String token = await getValue('token');
    if (await checkConnectionInternet()) {
      String theUrl = '$url/users/balance/swap/checkup';
      try {
        Response response = await client
            .post(theUrl,
                options: Options(headers: {
                  'content-type': 'application/json',
                  'accept': "*/*",
                  'access-control-allow-origin': "Accept",
                  'Authorization': "Bearer $token",
                }),
                data: data)
            .timeout(const Duration(seconds: 10));
        return response.data;
      } on TimeoutException catch (_) {
        showSnackbar("Error", "Time Out", LineIcons.exclamationTriangle);
        return null;
      } on DioError catch (error) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          handle401_403Status();
          return null;
        } else {
          return error.response?.data;
        }
      }
    } else {
      showSnackbar(
          "Error", "Internet disconnected", LineIcons.exclamationTriangle);
      return null;
    }
  }

  static Future<dynamic> leaderboardService(
      {required String sort,
      required String order,
      required String date}) async {
    if (await checkConnectionInternet()) {
      String theUrl =
          '$url/journal/leaderbord?sort=$sort&order=$order&date=$date';
      try {
        Response response =
            await client.get(theUrl).timeout(const Duration(seconds: 15));
        return response.data;
      } on TimeoutException catch (_) {
        showSnackbar("Error", "Time Out", LineIcons.exclamationTriangle);
        return null;
      } on DioError catch (error) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          handle401_403Status();
          return null;
        } else {
          return error.response?.data;
        }
      }
    } else {
      showSnackbar(
          "Error", "Internet disconnected", LineIcons.exclamationTriangle);
      return null;
    }
  }

  static Future<dynamic> transactionsHistoryService(
      {required String type,
      required String status,
      required int order,
      required int page,
      required int limit}) async {
    String token = await getValue('token');
    if (await checkConnectionInternet()) {
      String theUrl =
          '$url/transactions?type=$type&status=$status&order=$order&page=$page&limit=$limit';
      try {
        Response response = await client
            .get(
              theUrl,
              options: Options(headers: {
                'content-type': 'application/json',
                'accept': "*/*",
                'access-control-allow-origin': "Accept",
                'Authorization': "Bearer $token",
              }),
            )
            .timeout(const Duration(seconds: 15));
        return response.data;
      } on TimeoutException catch (_) {
        showSnackbar("Error", "Time Out", LineIcons.exclamationTriangle);
        return null;
      } on DioError catch (error) {
        if (error.response?.statusCode == 401 ||
            error.response?.statusCode == 403) {
          handle401_403Status();
          return null;
        } else {
          return error.response?.data;
        }
      }
    } else {
      showSnackbar(
          "Error", "Internet disconnected", LineIcons.exclamationTriangle);
      return null;
    }
  }

  static handle401_403Status() {
    clearAll();
    Get.offAllNamed('/home');
    Storage.isTokenSaved.value = false;
    showSnackbar(
        "Warning", "Please Login Again", LineIcons.exclamationTriangle);
  }
}
