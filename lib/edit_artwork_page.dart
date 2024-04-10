import 'package:flutter/material.dart';
import 'utils/db_helper.dart';
import 'models/artwork.dart';

class EditArtworkPage extends StatefulWidget {
  final Artwork artwork;

  const EditArtworkPage({Key? key, required this.artwork}) : super(key: key);

  @override
  EditArtworkPageState createState() => EditArtworkPageState();
}

class EditArtworkPageState extends State<EditArtworkPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController artistNameController;
  late TextEditingController imageUrlController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with the current artwork details
    titleController = TextEditingController(text: widget.artwork.title);
    artistNameController =
        TextEditingController(text: widget.artwork.artistName);
    imageUrlController = TextEditingController(text: widget.artwork.imageUrl);
    descriptionController =
        TextEditingController(text: widget.artwork.description ?? '');
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

  void _updateArtwork() {
    if (_formKey.currentState!.validate()) {
      // Update the Artwork object
      Artwork updatedArtwork = Artwork(
        id: widget.artwork.id, // Keep the original ID
        title: titleController.text,
        artistName: artistNameController.text,
        imageUrl: imageUrlController.text,
        description: descriptionController.text,
      );

      DatabaseHelper.instance.updateArtwork(updatedArtwork).then((_) {
        Navigator.pop(context, true);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating artwork: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Artwork'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
              // Repeat for other fields
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
              TextFormField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: _updateArtwork,
                  child: const Text('Update Artwork',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
