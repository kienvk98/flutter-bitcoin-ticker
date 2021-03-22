import 'dart:ffi';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  final String assetIdBase;
  final String assetIdQuote;
  final double rate;

  CoinData({this.assetIdBase, this.assetIdQuote, this.rate});

  factory CoinData.fromJson(Map<String, dynamic> json){
    return CoinData(
      assetIdBase: json['asset_id_base'],
      assetIdQuote: json['asset_id_quote'],
      rate: json['rate'],
    );
  }
}
