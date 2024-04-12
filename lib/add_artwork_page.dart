import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'utils/db_helper.dart';
import 'models/artwork.dart';

class AddArtworkPage extends StatefulWidget {
  const AddArtworkPage({super.key});

  @override
  AddArtworkPageState createState() => AddArtworkPageState();
}

class AddArtworkPageState extends State<AddArtworkPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final artistNameController = TextEditingController();
  final imageUrlController = TextEditingController();
  final descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;
  bool useUrl = true; // This boolean will toggle between URL and File upload

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

  void _toggleUploadType(bool? value) {
    setState(() {
      useUrl = value ?? true;
      imageUrlController.clear();
      imageFile = null;
    });
  }

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = pickedFile;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    artistNameController.dispose();
    imageUrlController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _saveArtwork() {
    if (_formKey.currentState!.validate()) {
      final String imageUrl = useUrl
          ? ensureHttpScheme(imageUrlController.text)
          : (imageFile != null ? imageFile!.path : '');
      final artwork = Artwork(
        title: titleController.text,
        artistName: artistNameController.text,
        imageUrl: imageUrl,
        description: descriptionController.text,
        id: null,
      );

      if ((useUrl && isValidUrl(imageUrl)) || imageFile != null) {
        DatabaseHelper.instance.insertArtwork(artwork).then((_) {
          Navigator.pop(context, true);
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to save artwork'),
                backgroundColor: Colors.red),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter a valid URL or select a file.'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: artistNameController,
                decoration: const InputDecoration(labelText: 'Artist Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the artist\'s name';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Use URL for Image?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14)),
                value: useUrl,
                onChanged: _toggleUploadType,
                activeColor: Theme.of(context).colorScheme.secondary,
                inactiveThumbColor: Theme.of(context).colorScheme.tertiary,
                inactiveTrackColor: Theme.of(context).colorScheme.primary,
              ),
              if (useUrl)
                TextFormField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL';
                    }
                    if (!isValidUrl(ensureHttpScheme(value)) ||
                        !_isImageUrl(value)) {
                      return 'Please enter a valid URL with http or https';
                    }
                    return null;
                  },
                ),
              if (!useUrl)
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                      ),
                      child: const Text('Select Image',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(imageFile?.path.split('/').last ??
                          'No file selected'),
                    ),
                  ],
                ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
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
