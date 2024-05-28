import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:ynab_copilot/api/ynab/errors.dart';
import 'package:http/http.dart' as http;
import 'package:ynab_copilot/database/models/ynab/account.dart';
import 'package:ynab_copilot/database/models/ynab/budget.dart';
import 'package:ynab_copilot/database/models/ynab/category_group.dart';
import 'package:ynab_copilot/database/models/ynab/transaction.dart';

class YnabApi extends ChangeNotifier {
  String clientId;

  String callbackUrlScheme;

  bool useDemoData = false;

  String? accessToken;

  DateTime? accessTokenExpiration;

  String get oauthUrl =>
      'https://app.youneedabudget.com/oauth/authorize?client_id=$clientId&redirect_uri=$callbackUrlScheme:/&response_type=token';

  bool get authIsExpired => accessTokenExpiration != null && DateTime.now().isAfter(accessTokenExpiration!);

  Future<bool> Function()? onNeedsReauthorization;

  YnabApi(
      {required this.clientId, required this.callbackUrlScheme, this.onNeedsReauthorization, this.useDemoData = false});

  void setAuth(String token, DateTime expiration) {
    accessToken = token;
    accessTokenExpiration = expiration;
    notifyListeners();
  }

  /// Starts the Oauth flow by invoking flutter_web_auth
  /// and opening the YNAB authorization page.
  Future<String> startOauth() async {
    if (useDemoData) return 'DEMO';

    try {
      // Present the dialog to the user
      final result = await FlutterWebAuth.authenticate(url: oauthUrl, callbackUrlScheme: callbackUrlScheme);

      // Extract the access_token from the URL fragment
      final fragment = Uri.parse(result).fragment;
      Map<String, String> fragmentParams = Uri.splitQueryString(fragment);
      final code = fragmentParams['access_token'];
      final expiration = fragmentParams['expires_in'] ?? '7200';
      if (code == null) {
        throw YnabOauthNoAccessToken();
      }

      setAuth(code, DateTime.now().add(Duration(seconds: int.parse(expiration))));

      // If authorization is successful, notify listeners
      notifyListeners();
      return code;
    } on YnabOauthNoAccessToken catch (_) {
      rethrow;
    } catch (e) {
      throw YnabOauthCancelledError();
    }
  }

  Future<String> getUserId() async {
    Map<String, dynamic> user = {};
    if (useDemoData) {
      user =
          jsonDecode(await rootBundle.loadString('assets/demo_data/user.json'))['data']['user'] as Map<String, dynamic>;
    } else {
      final res = await _request(method: 'GET', path: '/user');
      user = res['data']['user'] as Map<String, dynamic>;
    }

    return user['id'] as String;
  }

  Future<List<YnabBudget>> getBudgets() async {
    List<dynamic> budgets = [];
    if (useDemoData) {
      budgets =
          jsonDecode(await rootBundle.loadString('assets/demo_data/budgets.json'))['data']['budgets'] as List<dynamic>;
    } else {
      final res = await _request(method: 'GET', path: '/budgets');
      budgets = res['data']['budgets'] as List<dynamic>;
    }

    return budgets.map((e) => YnabBudget.fromJson(e)).toList();
  }

  Future<List<YnabCategoryGroup>> getBudgetCategories(String budgetId) async {
    List<dynamic> categories = [];
    if (useDemoData) {
      categories = jsonDecode(await rootBundle.loadString('assets/demo_data/categories.json'))['data']
          ['category_groups'] as List<dynamic>;
    } else {
      final res = await _request(method: 'GET', path: '/budgets/$budgetId/categories');
      categories = res['data']['category_groups'] as List<dynamic>;
    }

    return categories.map((e) => YnabCategoryGroup.fromJson(e)).toList();
  }

  Future<List<YnabAccount>> getBudgetAccounts(String budgetId) async {
    List<dynamic> accounts = [];
    if (useDemoData) {
      accounts = jsonDecode(await rootBundle.loadString('assets/demo_data/accounts.json'))['data']['accounts']
          as List<dynamic>;
    } else {
      final res = await _request(method: 'GET', path: '/budgets/$budgetId/accounts');
      accounts = res['data']['accounts'] as List<dynamic>;
    }

    return accounts.map((e) => YnabAccount.fromJson(e)).toList();
  }

  Future<List<YnabTransaction>> getBudgetTransactions(String budgetId) async {
    List<dynamic> transactions = [];
    print("GETING BUDGET TRANSACTIONS");
    if (useDemoData) {
      transactions = jsonDecode(await rootBundle.loadString('assets/demo_data/transactions.json'))['data']
          ['transactions'] as List<dynamic>;
    } else {
      final res = await _request(method: 'GET', path: '/budgets/$budgetId/transactions');
      transactions = res['data']['transactions'] as List<dynamic>;
    }

    print("GOT RESULTS");

    try {
      final test = transactions.map((e) => YnabTransaction.fromJson(e)).toList();
      print("RETURNING RESULTS");
      return test;
    } catch (e, stacktrace) {
      print("ERROR: $e");
      print("STACKTRACE: $stacktrace");
      return [];
    }
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
    // If the token has expired, call the onNeedsReauthorization callback
    if (authIsExpired) {
      if (onNeedsReauthorization != null) {
        final shouldRetry = await onNeedsReauthorization!();
        if (!shouldRetry) {
          return null;
        }

        return await _request(
            method: method, path: path, queryParameters: queryParameters, headers: headers, body: body);
      }

      throw YnabNotAuthenticatedError();
    }

    // Build headers for the API request
    final finalHeaders = _buildDefaultHeaders();

    // Add custom headers
    if (headers != null) {
      finalHeaders.addAll(headers);
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

    // If the response is a 401, call the onNeedsReauthorization callback
    if ([401].contains(response.statusCode)) {
      if (onNeedsReauthorization != null) {
        final shouldRetry = await onNeedsReauthorization!();
        if (!shouldRetry) {
          return null;
        }

        return await _request(
            method: method, path: path, queryParameters: queryParameters, headers: headers, body: body);
      }

      throw YnabNotAuthenticatedError();
    }

    // Parse the response
    final responseJson = jsonDecode(await response.stream.bytesToString());
    return responseJson;
  }
}
