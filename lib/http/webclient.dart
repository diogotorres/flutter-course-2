import 'dart:convert';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    print('Request');
    print('Url: ${data.url}');
    print('Headers: ${data.headers}');
    print('Body: ${data.body}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    print('Response');
    print('Status code: ${data.statusCode}');
    print('Headers: ${data.headers}');
    print('Body: ${data.body}');
    return data;
  }
}

const String baseUrl = 'http://172.17.0.1:8080/transactions';

final Client client = HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);

Future<List<Transaction>> findAll() async {
  final Response response = await client.get(baseUrl).timeout(Duration(seconds: 5));
  final List<dynamic> decodedJson = jsonDecode(response.body);
  final List<Transaction> transactions = List();
  for (Map<String, dynamic> item in decodedJson) {
    final Transaction transaction = Transaction(
        item['value'],
        Contact(
          0,
          item['contact']['name'],
          item['contact']['accountNumber'],
        )
    );
    transactions.add(transaction);
  }
  return transactions;
}

Future<Transaction> save(Transaction transaction) async {
  final Map<String, dynamic> transactionMap = {
    'value': transaction.value,
    'contact': {
      'name': transaction.contact.name,
      'accountNumber': transaction.contact.accountNumber
    }
  };
  String transactionJson = jsonEncode(transactionMap);
  final Response response = await client.post(
    baseUrl,
    headers: {
      'Content-type': 'application/json',
      'password': '1000',
    },
    body: transactionJson
  );
  Map<String, dynamic> decodedJson = jsonDecode(response.body);
  return Transaction(
      decodedJson['value'],
      Contact(
        0,
        decodedJson['contact']['name'],
        decodedJson['contact']['accountNumber'],
      )
  );
}
