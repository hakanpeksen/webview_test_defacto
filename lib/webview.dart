import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  //final String url = "https://html5.flamebird.gameontech.co.uk/45fvcdQWDaf96kgkjfssftrAQW34543DVVzxsda/";
  final String url = "https://flamebird.gameontech.co.uk/45fvcdQWDaf96kgkjfssftrAQW34543DVVzxsda/";
  //final Completer<WebViewController> controller = Completer<WebViewController>();

  late WebViewController _controller;
  String title = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = WebViewController()
      ..addJavaScriptChannel('flamebird', onMessageReceived: (message) {
        setState(() {
          title = message.message;
        });
        print(message);
      })
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _WebViewState();
  }

//!  başla butonuna basmadan, geri tuşuna basarsa appden çıkıyor
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: (() async => {
                    _controller.reload(),
                  }),
              //   if (await _controller.canGoBack())
              //     {
              //       _controller.goBack(),
              //     }
              // }),
              // setState(() {
              //Navigator.of(context).pop();
              //   var noncase = "self.onbeforeunload=null";
              //   _controller.removeJavaScriptChannel('flamebird');
              //_controller.goBack();
              // }),

              icon: const Icon(Icons.close),
            ),
            title: Text(title)),
        body: WebViewWidget(
          controller: _controller,
        ),
      ),
    );
  }
}
