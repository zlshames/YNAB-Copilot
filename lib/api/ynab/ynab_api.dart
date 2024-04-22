import 'dart:convert';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:ynab_copilot/api/ynab/errors.dart';
import 'package:http/http.dart' as http;

class YnabApi {
  String clientId;

  String callbackUrlScheme;

  String? accessToken;

  String get oauthUrl =>
      'https://app.youneedabudget.com/oauth/authorize?client_id=$clientId&redirect_uri=$callbackUrlScheme:/&response_type=code&scope=';

  Function()? onNeedsReauthorization;

  YnabApi({required this.clientId, required this.callbackUrlScheme, this.accessToken, this.onNeedsReauthorization});

  /// Starts the Oauth flow by invoking flutter_web_auth
  /// and opening the YNAB authorization page.
  Future<String> startOauth() async {
    try {
      // Present the dialog to the user
      final result = await FlutterWebAuth.authenticate(url: oauthUrl, callbackUrlScheme: callbackUrlScheme);

      // Extract code from resulting url
      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) {
        throw YnabOauthNoAuthorizationCodeError();
      }

      accessToken = code;
      return code;
    } catch (e) {
      throw YnabOauthCancelledError();
    }
  }

  Future<dynamic> getUserInfo() async {
    return _request(method: 'GET', path: '/user');
  }

  Future<dynamic> getBudgets() async {
    return _request(method: 'GET', path: '/budgets');
  }

  Future<dynamic> getBudgetCategories(String budgetId) async {
    return _request(method: 'GET', path: '/budgets/$budgetId/categories');
  }

  Future<dynamic> getBudgetAccounts(String budgetId) async {
    return _request(method: 'GET', path: '/budgets/$budgetId/accounts');
  }

  Future<dynamic> getBudgetSettings(String budgetId) async {
    return _request(method: 'GET', path: '/budgets/$budgetId/settings');
  }

  Future<dynamic> getBudgetTransactions(String budgetId) async {
    return _request(method: 'GET', path: '/budgets/$budgetId/transactions');
  }

  Future<dynamic> getBudgetPayees(String budgetId) async {
    return _request(method: 'GET', path: '/budgets/$budgetId/payees');
  }

  Future<dynamic> getBudgetMonths(String budgetId) async {
    return _request(method: 'GET', path: '/budgets/$budgetId/months');
  }

  Future<dynamic> getBudgetMonth(String budgetId, String month) async {
    // Validate that the month is in the format YYYY-MM
    if (!RegExp(r'^(?:\d{4}-\d{2}(?:-\d{2})?)|(?:current)$').hasMatch(month)) {
      throw ArgumentError('Month must be "current" or in the format YYYY-MM.');
    }

    if (month.contains('-') && !month.endsWith('-01')) {
      month = "$month-01";
    }

    return _request(method: 'GET', path: '/budgets/$budgetId/months/$month');
  }

  Map<String, String> _buildDefaultHeaders({String method = 'GET'}) {
    final Map<String, String> headers = {};
    headers['Authorization'] = 'Bearer $accessToken';
    headers['Accept'] = 'application/json';

    if (['POST', 'PUT', 'PATCH'].contains(method.toUpperCase())) {
      headers['Content-Type'] = 'application/json';
    }

    return headers;
  }

  Future<dynamic> _request({
    String method = 'GET',
    required String path,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    if (accessToken == null) {
      throw YnabNotAuthenticatedError();
    }

    // Build headers for the API request
    final finalHeaders = _buildDefaultHeaders();

    // Add custom headers
    if (headers != null) {
      headers.addAll(headers);
    }

    // Make the request
    final request = http.Request(method, Uri.parse('https://api.youneedabudget.com/v1$path'))
      ..headers.addAll(finalHeaders);

    // Add the body if it's a POST, PUT or PATCH request
    if (body != null && ['POST', 'PUT', 'PATCH'].contains(method.toUpperCase())) {
      request.body = jsonEncode(body);
    }

    // Add query parameters
    if (queryParameters != null) {
      request.url.queryParameters.addAll(queryParameters);
    }

    // Send the request
    http.StreamedResponse response = await request.send();
    if ([401].contains(response.statusCode) && onNeedsReauthorization != null) {
      await onNeedsReauthorization!();
      return await _request(method: method, path: path, queryParameters: queryParameters, headers: headers, body: body);
    }

    // Parse the response
    final responseJson = jsonDecode(await response.stream.bytesToString());
    return responseJson;
  }
}
