import 'package:flutter/material.dart';
import 'utils/db_helper.dart';
import 'models/artwork.dart';

class AddArtworkPage extends StatefulWidget {
  const AddArtworkPage({Key? key}) : super(key: key);

  @override
  _AddArtworkPageState createState() => _AddArtworkPageState();
}

class _AddArtworkPageState extends State<AddArtworkPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final artistNameController = TextEditingController();
  final imageUrlController = TextEditingController();
  final descriptionController = TextEditingController();

  String ensureHttpScheme(String url) {
    if (!url.startsWith(RegExp(r'https?://'))) {
      return 'https://$url';
    }
    return url;
  }

  bool isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  bool _isImageUrl(String url) {
    try {
      var img = NetworkImage(url).resolve(const ImageConfiguration());
      var isImage = false;
      img.addListener(ImageStreamListener((info, call) {
        isImage = true;
        return;
      }, onError: (dynamic exception, StackTrace? stackTrace) {
        isImage = false;
        return;
      }));
      return isImage;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    titleController.dispose();
    artistNameController.dispose();
    imageUrlController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _saveArtwork() {
    final String imageUrl = ensureHttpScheme(imageUrlController.text);
    if (_formKey.currentState!.validate()) {
      final artwork = Artwork(
        title: titleController.text,
        artistName: artistNameController.text,
        imageUrl: imageUrl,
        description: descriptionController.text,
        id: null,
      );

      if (isValidUrl(imageUrl) && _isImageUrl(artwork.imageUrl)) {
        DatabaseHelper.instance.insertArtwork(artwork).then((_) {
          Navigator.pop(context, true);
        }).catchError((error) {
          const SnackBar(
              content: Text('Failed to save artwork'),
              backgroundColor: Colors.red);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter a valid URL.'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Artwork'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: artistNameController,
                decoration: InputDecoration(labelText: 'Artist Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the artist\'s name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  if (!isValidUrl(ensureHttpScheme(value))) {
                    return 'Please enter a valid URL with http or https';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: _saveArtwork,
                  child: const Text(
                    'Save Artwork',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
