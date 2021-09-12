import 'networking.dart';

const String apiKey = '?apikey=A9229FBC-BD53-442F-A3E1-CA09498FD0C7';
const coinAPIUrl = 'https://rest.coinapi.io/v1/exchangerate';

class CryptoData {
  Future<dynamic> getCryptoData(String currency, String typeOfCurrency) async {
    NetworkHelper networkHelper =
        NetworkHelper('$coinAPIUrl/$typeOfCurrency/$currency$apiKey');
    var cryptoData = await networkHelper.getData();
    return cryptoData['rate'];
  }
}
