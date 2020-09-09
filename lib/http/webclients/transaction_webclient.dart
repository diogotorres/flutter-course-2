import 'dart:convert';
import 'package:bytebank/http/webclient.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:http/http.dart';

class TransactionWebClient {

  Future<List<Transaction>> findAll() async {
    final Response response = await client.get(baseUrl).timeout(Duration(seconds: 5));
    return _toTransactions(response);
  }

  Future<Transaction> save(Transaction transaction) async {
    Map<String, dynamic> transactionMap = _toMap(transaction);
    String transactionJson = jsonEncode(transactionMap);
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

  Map<String, dynamic> _toMap(Transaction transaction) {
    final Map<String, dynamic> transactionMap = {
      'value': transaction.value,
      'contact': {
        'name': transaction.contact.name,
        'accountNumber': transaction.contact.accountNumber
      }
    };
    return transactionMap;
  }

  Transaction _toTransaction(Response response) {
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
}