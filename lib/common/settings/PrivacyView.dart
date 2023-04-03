import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyView extends ConsumerStatefulWidget {
  const PrivacyView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _PrivacyViewState();
}

class _PrivacyViewState extends ConsumerState<PrivacyView> {

  WebViewController controller = WebViewController();

  @override
  void initState() {
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            print("started");
          },
          onPageFinished: (String url) {
            print("finished");
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://docs.google.com/document/d/1aVNcGCtMvDZlT5tkIWwNjFTwv7NbYmcu/edit'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: WebViewWidget(
              controller: controller,
          )
      ),
    );
  }
}
