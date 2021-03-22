import 'package:bitcoin_ticker/cooin_brain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:isolate';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  static String concurrency = 'USD';
  static CoinBrain coinBrain = CoinBrain();
  String exchangeBTC = "1 BTC = ?USD";
  String exchangeETH = "1 ETH = ?USD";
  String exchangeLTC = "1 LTC = ?USD";
  Isolate _isolate1;

  @override
  void initState() {
    super.initState();
  }

  void startIsolate() async{
    ReceivePort _receivePort1 = ReceivePort();
    _isolate1 = await Isolate.spawn(getExchangeBTC, _receivePort1.sendPort);
    ReceivePort _receivePort2 = ReceivePort();
    _isolate1 = await Isolate.spawn(getExchangeETH, _receivePort2.sendPort);
    ReceivePort _receivePort3 = ReceivePort();
    _isolate1 = await Isolate.spawn(getExchangeLTC, _receivePort3.sendPort);
    _receivePort1.listen((message) {
      setState(() {
        print('end 1 ${DateTime.now()}');
        exchangeBTC = "1 BTC = $message USD";
      });
    },onDone:(){
      print('done1');
    });
    _receivePort2.listen((message) {
      setState(() {
        print('end 2 ${DateTime.now()}');
        exchangeETH = "1 ETH = $message USD";
      });
    },onDone:(){
      print('done2');
    });
    _receivePort3.listen((message) {
      setState(() {
        print('end 3 ${DateTime.now()}');
        exchangeLTC = "1 LCT = $message USD";
      });
    },onDone:(){
      print('done3');
    });
    _receivePort3.close();
    _isolate1.kill(priority: Isolate.immediate);
  }

  static void getExchangeBTC(SendPort sendPort) async{
    print('start 1 ${DateTime.now()}');
    String exchange = await coinBrain.getExchangeRatesCoin(concurrency, "BTC");
    sendPort.send(exchange);
  }

  static void getExchangeETH(SendPort sendPort) async{
    print('start 2 ${DateTime.now()}');
    sendPort.send(await coinBrain.getExchangeRatesCoin(concurrency, "ETH"));
  }

  static void getExchangeLTC(SendPort sendPort) async{
    print('start 3 1 ${DateTime.now()}');
    sendPort.send(await coinBrain.getExchangeRatesCoin(concurrency, "LTC"));
    print('start 3 2 ${DateTime.now()}');
    sendPort.send(await coinBrain.getExchangeRatesCoin(concurrency, "LTC"));
  }

  Widget iosPicker(){
    return CupertinoPicker(
      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
        background: Colors.transparent,
      ),
      onSelectedItemChanged: (value){
        concurrency = currenciesList[value];
        startIsolate();
      },
      itemExtent: 50,
      children: currenciesList.map<Widget>((value) {
        return  Center(child: Text(value));
      }).toList(),
    );
  }

  Widget androidDropdown(){
    return DropdownButton(
      value: concurrency,
      onChanged: (value) {
        setState(() {
          concurrency = value;
          startIsolate();
        });
      },
      items: currenciesList.map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExchangeWidget(exchange: exchangeBTC,),
              ExchangeWidget(exchange: exchangeETH,),
              ExchangeWidget(exchange: exchangeLTC,),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            // child: Platform.isIOS ? iosPicker(): androidDropdown(),
            child: androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class ExchangeWidget extends StatefulWidget {
  String exchange;
  ExchangeWidget({this.exchange});
  @override
  _ExchangeWidgetState createState() => _ExchangeWidgetState();
}

class _ExchangeWidgetState extends State<ExchangeWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            widget.exchange,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}


