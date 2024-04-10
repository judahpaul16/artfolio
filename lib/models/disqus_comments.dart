import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DisqusComments extends StatelessWidget {
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
  Widget build(BuildContext context) {
    String disqusHtml = """
      <!DOCTYPE html>
      <html lang="en">
      <head><meta charset="UTF-8"><title>Disqus Thread</title>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      </head>
      <body>
      <div id="disqus_thread"></div>
      <script>
        var disqus_config = function () {
          this.page.url = '$url';
          this.page.identifier = '$identifier';
        };
        (function() {
          var d = document, s = d.createElement('script');
          s.src = 'https://${disqusShortname}.disqus.com/embed.js';
          s.setAttribute('data-timestamp', +new Date());
          (d.head || d.body).appendChild(s);
        })();
      </script>
      </body>
      </html>
      """;

    String contentBase64 =
        base64Encode(const Utf8Encoder().convert(disqusHtml));
    return Expanded(
      child: WebView(
        initialUrl: 'data:text/html;base64,$contentBase64',
        javascriptMode: JavascriptMode.unrestricted,
        zoomEnabled: true,
      ),
    );
  }
}
