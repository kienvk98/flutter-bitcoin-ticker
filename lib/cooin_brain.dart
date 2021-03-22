import 'dart:convert';
import 'dart:math';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:http/http.dart' as http;

const apiKey = "4BA65EF3-D6A3-480C-B0BF-8A20C53F90FB";

class CoinBrain{
  Future<String> getExchangeRatesCoin(String concurrency, String coin) async{
    Uri uri = Uri.parse("https://rest.coinapi.io/v1/exchangerate/$coin/$concurrency");
    Map<String, String> header = {"X-CoinAPI-Key": apiKey};
    final response = await http.get(uri, headers: header);
    var responseJson = jsonDecode(response.body);
    return double.parse((Random().nextDouble()*1000).toString()).toStringAsFixed(2);
    return double.parse(CoinData.fromJson(responseJson).rate.toString()).toStringAsFixed(2);
  }
}