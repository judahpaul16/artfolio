import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:artfolio/utils/settings.dart';
import 'package:artfolio/webview_page.dart';
import 'package:flutter/material.dart';
import 'models/disqus_comments.dart';
import 'models/artwork.dart';
import 'dart:io';

class ArtworkDetailPage extends StatelessWidget {
  final Artwork artwork;

  const ArtworkDetailPage({Key? key, required this.artwork}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(artwork.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //check for file:// and http(s):// prefixes
            !artwork.imageUrl.startsWith('http')
                ? Image.file(
                    File(artwork.imageUrl),
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    artwork.imageUrl,
                    fit: BoxFit.cover,
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // social media buttons
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.pinterest),
                    onPressed: () {
                      // open pinterest webview
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewPage(
                            title: 'Pinterest',
                            url: AppStrings.pinterestUrl,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.facebook),
                    onPressed: () {
                      // open facebook webview
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewPage(
                            title: 'Facebook',
                            url: AppStrings.facebookUrl,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.instagram),
                    onPressed: () {
                      // open instagram webview
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewPage(
                            title: 'Instagram',
                            url: AppStrings.instagramUrl,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.dribbble),
                    onPressed: () {
                      // open dribbble webview
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewPage(
                            title: 'Dribbble',
                            url: AppStrings.dribbbleUrl,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                artwork.artistName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                artwork.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
                height: screenHeight * 0.75,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DisqusComments(
                        disqusShortname: AppStrings.disqusShortname,
                        identifier: '${artwork.id}',
                        url: '${AppStrings.disqusUrl}/artwork/${artwork.id}',
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
