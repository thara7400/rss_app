import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rss_app/src/sample_feature/sample_item_api.dart';
import 'package:webfeed/webfeed.dart';
import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class SampleItemListView extends StatefulWidget {
  const SampleItemListView({Key? key,}) : super(key: key);
  static const routeName = '/';

  @override
  SampleItemListViewState createState() => SampleItemListViewState();
}

class SampleItemListViewState extends State<SampleItemListView> {

  List<SampleItem>? items;
   Future<AtomFeed>? feedData;

  @override
  void initState() {
    super.initState();
    // データ取得
    getRss();
  }

  // データ取得
  Future<void> getRss() async {
    if(kIsWeb){
      feedData = RssApi().getRssData('https://www.theverge.com/rss/index.xml');
    }else{
      feedData = RssApi().getRssData('http://himukamaru.jugem.jp/?mode=atom');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RSS Reader'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: getRss,
          child: FutureBuilder(
            future: feedData,
            builder: (BuildContext context, AsyncSnapshot<AtomFeed> snapshot) {
              // 通信時
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              // エラー時
              if (snapshot.hasError) {
                return const Center(child: Text("ERROR"));
              }
              // データ表示
              if (snapshot.hasData) {
                List<AtomItem>? items = snapshot.data?.items;
                return ListView.builder(
                  restorationId: 'feedItemListView',
                  itemCount: items?.length,
                  itemBuilder: (BuildContext context, int index) {
                    AtomItem item = items![index];

                    return GestureDetector(
                      onTap: () {
                        if(kIsWeb){
                          launch('${item.id}');
                        }else{
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SampleItemDetailsView(
                              url: '${item.id}',
                            ),
                          ),
                        );
                        }
                      },
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text('${item.title}',
                                  style: const TextStyle(fontSize: 22.0)
                                ),
                              ),
                              Html(data: '${item.content}'),
                              Container(
                                alignment: Alignment.centerRight,
                                child: Text('${item.updated}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    // return ListTile(
                    //   title: Text('${item.title}'),
                    //   subtitle: Column(
                    //     children: [
                    //       Html(data: '${item.content}'),
                    //       Container(
                    //         alignment: Alignment.centerRight,
                    //         child: Text('${item.updated}'),
                    //       ),
                    //     ],
                    //   ),
                    //   onTap: () {
                    //     // Navigator.restorablePushNamed(
                    //     //   context,
                    //     //   SampleItemDetailsView.routeName,
                    //     // );
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => SampleItemDetailsView(
                    //           url: '${item.id}',
                    //         ),
                    //       ),
                    //     );
                    //   }
                    // );
                  },
                );
              } else {
                return const Center(child: Text("ERROR"));
              }
            },
          ),
        ),
      ),
    );
  }
}
