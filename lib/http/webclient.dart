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

Future<List<Transaction>> findAll() async {
  final Client client = HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);
  final Response response = await client.get('http://172.17.0.1:8080/transactions').timeout(Duration(seconds: 5));
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
