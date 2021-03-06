import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:webfeed/webfeed.dart';
import 'package:webview_flutter/webview_flutter.dart';


class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView({Key? key, this.url}) : super(key: key);
  final String? url;
  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {print(url);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: SafeArea(
        top: false,
        child: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
