import 'package:artfolio/artwork_detail_page.dart';
import 'package:artfolio/edit_artwork_page.dart';
import 'package:artfolio/add_artwork_page.dart';
import 'package:flutter/material.dart';
import 'utils/db_helper.dart';
import 'models/artwork.dart';
import 'utils/strings.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Careful uncommenting this line, it will clear the database
  // await DatabaseHelper.instance.clearDatabase();
  runApp(const ArtfolioApp());
}

class ArtfolioApp extends StatelessWidget {
  const ArtfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: appTheme,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Future<List<Artwork>>? _artworkListFuture;
  Key _futureBuilderKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _refreshArtworkList();
  }

  void _refreshArtworkList() {
    _artworkListFuture = DatabaseHelper.instance.getArtworks();
  }

  void _editArtwork(BuildContext context, Artwork artwork) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditArtworkPage(artwork: artwork),
      ),
    ).then((_) {
      setState(() {
        _futureBuilderKey = UniqueKey();
        _refreshArtworkList();
      });
    });
  }

  void _deleteArtwork(BuildContext context, int? artworkId) {
    if (artworkId == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this artwork?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                DatabaseHelper.instance.deleteArtwork(artworkId).then((_) {
                  _refreshArtworkList();
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshArtworkList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(homePageTitle),
      ),
      body: FutureBuilder<List<Artwork>>(
        key: _futureBuilderKey,
        future: DatabaseHelper.instance.getArtworks(),
        builder: (BuildContext context, AsyncSnapshot<List<Artwork>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Artwork artwork = snapshot.data![index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArtworkDetailPage(artwork: artwork),
                  ),
                ),
                child: GridTile(
                  footer: GridTileBar(
                    backgroundColor: Colors.black45,
                    title: Text(artwork.title),
                    subtitle: Text(artwork.artistName),
                    // Add action icons for edit and delete
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            // Navigate to edit page or show edit dialog
                            _editArtwork(context, artwork);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            // Confirm deletion and delete artwork
                            _deleteArtwork(context, artwork.id);
                          },
                        ),
                      ],
                    ),
                  ),
                  child: Image.network(artwork.imageUrl, fit: BoxFit.cover),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddArtworkPage())).then((_) {
            setState(() {
              _futureBuilderKey = UniqueKey();
              _refreshArtworkList();
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
