import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class RssApi {
  Future<AtomFeed> getRssData(String url) async {
    // 取得データ
    AtomFeed feed = AtomFeed();

    try {
      // API通信
      var client = http.Client();
      var response = await client.get(Uri.parse(url));

      // 結果
      if(response.statusCode == 200){
        feed = AtomFeed.parse(utf8.decode(response.bodyBytes));
      }
    } catch(e) {
      print(e.toString());
    }
    return feed;
  }
}
