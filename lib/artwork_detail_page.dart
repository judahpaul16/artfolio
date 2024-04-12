import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:artfolio/utils/settings.dart';
import 'package:artfolio/webview_page.dart';
import 'package:flutter/material.dart';
import 'models/disqus_comments.dart';
import 'package:share/share.dart';
import 'models/artwork.dart';
import 'dart:io';

class ArtworkDetailPage extends StatelessWidget {
  final Artwork artwork;

  const ArtworkDetailPage({super.key, required this.artwork});

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
            Stack(
              children: [
                // Display the artwork image
                !artwork.imageUrl.startsWith('http')
                    ? Image.file(
                        File(artwork.imageUrl),
                        fit: BoxFit.cover,
                        height: screenHeight * 0.75,
                        width: double.infinity,
                      )
                    : Image.network(
                        artwork.imageUrl,
                        fit: BoxFit.cover,
                        height: screenHeight * 0.5,
                        width: double.infinity,
                      ),
                // Share button at the bottom left of the image
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(FontAwesomeIcons.shareNodes,
                        color: Colors.white),
                    onPressed: () {
                      Share.share(artwork.imageUrl);
                    },
                  ),
                ),
                // Fullscreen button at the bottom right of the image
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(FontAwesomeIcons.expand,
                        color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: Text(artwork.title),
                            ),
                            body: Center(
                              child: !artwork.imageUrl.startsWith('http')
                                  ? Image.file(
                                      File(artwork.imageUrl),
                                      fit: BoxFit.contain,
                                    )
                                  : Image.network(
                                      artwork.imageUrl,
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Social media buttons
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.pinterest),
                    onPressed: () {
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
                        url: artwork.imageUrl,
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
