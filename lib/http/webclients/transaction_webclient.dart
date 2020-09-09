import 'dart:convert';

import 'package:bytebank/http/webclient.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:http/http.dart';

class TransactionWebClient {

  Future<List<Transaction>> findAll() async {
    final Response response = await client.get(baseUrl).timeout(Duration(seconds: 5));
    return _toTransactions(response);
  }

  Future<Transaction> save(Transaction transaction) async {
    String transactionJson = jsonEncode(transaction.toJson());
    final Response response = await client.post(
        baseUrl,
        headers: {
          'Content-type': 'application/json',
          'password': '1000',
        },
        body: transactionJson
    );
    return _toTransaction(response);
  }

  List<Transaction> _toTransactions(Response response) {
    final List<dynamic> decodedJson = jsonDecode(response.body);
    final List<Transaction> transactions = List();
    for (Map<String, dynamic> item in decodedJson) {
      transactions.add(Transaction.fromJson(item));
    }
    return transactions;
  }

  Transaction _toTransaction(Response response) {
    Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return Transaction.fromJson(decodedJson);
  }
}