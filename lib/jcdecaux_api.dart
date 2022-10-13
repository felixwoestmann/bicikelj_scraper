import 'package:dio/dio.dart';

import 'model/bike.dart';
import 'model/station.dart';

class JCDecauxAPI {
  final String apiKey;
  final String contract;
  final Dio dio;

  JCDecauxAPI({required this.apiKey, required this.dio, required this.contract});

  static JCDecauxAPI setupApi() {
    const String apiKey = 'd14e5c3e8f5ddb62e49354b321294d20b137e143';
    const String contract = 'Ljubljana';
    final api = JCDecauxAPI(apiKey: apiKey, contract: contract, dio: Dio());
    return api;
  }

  Future<List<Station>> getStations() async {
    try {
      final response = await dio.get('https://api.jcdecaux.com/vls/v3/stations?contract=$contract&apiKey=$apiKey');
      final List<Station> stations = (response.data as List).map((e) => Station.fromJson(e)).toList();
      return stations;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Bike>> getBikesAtStation({required int stationNumber, required String accessToken}) async {
    try {
      final response = await dio.get(
          'https://api.cyclocity.fr/contracts/ljubljana/bikes?stationNumber=$stationNumber&apiKey=$apiKey',
          options: Options(headers: _createHeaderForBikesRequest(accessToken)));
      final List<Bike> bikesAtStation = (response.data as List).map((e) => Bike.fromJson(e)).toList();
      return bikesAtStation;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<String> getAccessToken({required String refreshToken}) async {
    try {
      final response = await dio.post(
        'https://api.cyclocity.fr/auth/access_tokens',
        data: {'refreshToken': refreshToken},
        options: Options(headers: _getHeadersForAccessTokenRequest()),
      );
      return response.data['accessToken'];
    } catch (e) {
      return Future.error(e);
    }
  }

  Map<String, dynamic> _createHeaderForBikesRequest(String accessToken) => {
        'Authorization': 'Taknv1 $accessToken',
        'Accept': 'application/vnd.bikes.v3+json',
        'If-None-Match': 748303801,
        'Host': 'api.cyclocity.fr',
        'Sec-Fetch-Mode': 'cors',
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36 OPR/64.0.3417.92",
      };

  Map<String, String> _getHeadersForAccessTokenRequest() => {
        'Sec-Fetch-Site': 'cross-site',
        'Sec-Fetch-Mode': 'cors',
        "DNT": "1",
        "Connection": "keep-alive",
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Host": "api.cyclocity.fr",
        "Origin": "https://www.bicikelj.si",
        "Referer": "https://www.bicikelj.si",
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36 OPR/64.0.3417.92",
        "Access-Control-Request-Headers": "access-control-allow-headers,access-control-allow-origin,content-type",
        "Access-Control-Request-Method": "POST",
      };
}
