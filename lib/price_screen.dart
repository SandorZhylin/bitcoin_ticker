import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'cryptodata.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CryptoData cryptoData = new CryptoData();
  String selectedCurrency = 'USD';

  String rateBTC = 'Retrieving data...';
  String rateETH = 'Retrieving data...';
  String rateLTC = 'Retrieving data...';

  @override
  void initState() {
    getRate(selectedCurrency);
    super.initState();
  }

  void getRate(String currency) async {
    var newRateBTC = await cryptoData.getCryptoData(currency, cryptoList[0]);
    newRateBTC = num.parse(newRateBTC.toStringAsFixed(0));
    var newRateETH = await cryptoData.getCryptoData(currency, cryptoList[1]);
    newRateETH = num.parse(newRateETH.toStringAsFixed(0));
    var newRateLTC = await cryptoData.getCryptoData(currency, cryptoList[2]);
    newRateLTC = num.parse(newRateLTC.toStringAsFixed(0));

    setState(
      () {
        rateBTC = newRateBTC.toString();
        rateETH = newRateETH.toString();
        rateLTC = newRateLTC.toString();
      },
    );
  }

  DropdownButton<String> androidDropdownButton() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String currency in currenciesList) {
      Widget newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(
          () {
            selectedCurrency = value;
            rateBTC = 'Retrieving data...';
            rateETH = 'Retrieving data...';
            rateLTC = 'Retrieving data...';
            getRate(selectedCurrency);
          },
        );
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> cupertinoPickerItems = [];
    for (String currency in currenciesList) {
      cupertinoPickerItems.add(
        Text(currency),
      );
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {},
      children: cupertinoPickerItems,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else if (Platform.isAndroid) {
      return androidDropdownButton();
    }
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
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CryptoCard(
                  rate: rateBTC,
                  selectedCurrency: selectedCurrency,
                  typeOfCurrency: cryptoList[0],
                ),
                CryptoCard(
                  rate: rateETH,
                  selectedCurrency: selectedCurrency,
                  typeOfCurrency: cryptoList[1],
                ),
                CryptoCard(
                  rate: rateLTC,
                  selectedCurrency: selectedCurrency,
                  typeOfCurrency: cryptoList[2],
                ),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:
                Platform.isAndroid ? androidDropdownButton() : Platform.isIOS,
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    @required this.rate,
    @required this.selectedCurrency,
    @required this.typeOfCurrency,
  });

  final String typeOfCurrency;
  final String rate;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlue,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $typeOfCurrency = $rate $selectedCurrency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
