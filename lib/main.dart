import 'package:artfolio/artwork_detail_page.dart';
import 'package:artfolio/add_artwork_page.dart';
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'artwork.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await DatabaseHelper.instance.clearDatabase();
  runApp(const ArtfolioApp());
}

class ArtfolioApp extends StatelessWidget {
  const ArtfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Artfolio',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Artwork>>? _artworkListFuture;

  @override
  void initState() {
    super.initState();
    _refreshArtworkList();
  }

  void _refreshArtworkList() {
    _artworkListFuture = DatabaseHelper.instance.getArtworks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artfolio Showcase'),
      ),
      body: FutureBuilder<List<Artwork>>(
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
                  child: Image.network(artwork.imageUrl, fit: BoxFit.cover),
                  footer: GridTileBar(
                    backgroundColor: Colors.black45,
                    title: Text(artwork.title),
                    subtitle: Text(artwork.artistName),
                  ),
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
            MaterialPageRoute(builder: (context) => const AddArtworkPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
