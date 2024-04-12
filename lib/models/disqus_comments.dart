import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DisqusComments extends StatefulWidget {
  final String disqusShortname;
  final String identifier;
  final String url;

  const DisqusComments({
    Key? key,
    required this.disqusShortname,
    required this.identifier,
    required this.url,
  }) : super(key: key);

  @override
  _DisqusCommentsState createState() => _DisqusCommentsState();
}

class _DisqusCommentsState extends State<DisqusComments> {
  late WebViewController _controller;
  double _height = 300;
  Timer? _heightAdjustmentTimer;

  @override
  void dispose() {
    _heightAdjustmentTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String disqusHtml = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Disqus Thread</title>
      <style>body {margin: 0; padding: 1em;}</style>
    </head>
    <body>
      <div id="disqus_thread"></div>
      <script>
        var disqus_config = function () {
          this.page.url = '${widget.url}';
          this.page.identifier = '${widget.identifier}';
        };
        (function() {
          var d = document, s = d.createElement('script');
          s.src = 'https://${widget.disqusShortname}.disqus.com/embed.js';
          s.setAttribute('data-timestamp', +new Date());
          (d.head || d.body).appendChild(s);
        })();
      </script>
    </body>
    </html>
    """;

    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(disqusHtml));

    return SizedBox(
      height: _height,
      child: WebView(
        initialUrl: 'data:text/html;base64,$contentBase64',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _controller = controller;
        },
        onPageFinished: (_) {
          _adjustHeightPeriodically();
        },
      ),
    );
  }

  void _adjustHeightPeriodically() {
    _heightAdjustmentTimer?.cancel();

    _heightAdjustmentTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _controller
          .evaluateJavascript("document.body.scrollHeight;")
          .then((result) {
        final newHeight = double.tryParse(result) ?? _height;
        if (newHeight != _height && newHeight > 0) {
          setState(() {
            _height = newHeight;
          });
        }
      }).catchError((error) {
        debugPrint("Error adjusting height: $error");
      });

      if (timer.tick >= 5) {
        timer.cancel();
      }
    });
  }
}
