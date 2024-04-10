import 'package:flutter/material.dart';
import 'package:artfolio/utils/db_helper.dart';
import 'package:artfolio/models/artwork.dart';
import 'package:artfolio/utils/strings.dart';
import 'package:artfolio/utils/theme.dart';
import 'package:artfolio/artwork_detail_page.dart';
import 'package:artfolio/edit_artwork_page.dart';
import 'package:artfolio/add_artwork_page.dart';

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
      title: AppStrings.appTitle,
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
  final _formKey = GlobalKey<FormState>();
  bool _isLoggedIn = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
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

  void _toggleLoginState() {
    setState(() {
      _isLoggedIn = !_isLoggedIn;
    });
  }

  void _login() {
    if (_usernameController.text == AppStrings.username &&
        _passwordController.text == AppStrings.password) {
      _toggleLoginState();
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid username or password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.homePageTitle),
        actions: [
          IconButton(
            icon: Icon(_isLoggedIn ? Icons.logout : Icons.login),
            onPressed: () {
              if (_isLoggedIn) {
                _toggleLoginState();
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Login'),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(labelText: 'Username'),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(labelText: 'Password'),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _login();
                          }
                        },
                        child: Text('Login'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Artwork>>(
        key: _futureBuilderKey,
        future: _artworkListFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              Artwork artwork = snapshot.data![index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ArtworkDetailPage(artwork: artwork)),
                ),
                child: GridTile(
                  footer: GridTileBar(
                    backgroundColor: Colors.black45,
                    title: Text(artwork.title),
                    subtitle: Text(artwork.artistName),
                    trailing: _isLoggedIn
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.white),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditArtworkPage(artwork: artwork)),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.white),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete Artwork'),
                                      content: Text(
                                          'Are you sure you want to delete ${artwork.title}?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            DatabaseHelper.instance
                                                .deleteArtwork(artwork.id!);
                                            _refreshArtworkList();
                                            _futureBuilderKey = UniqueKey();
                                            Navigator.pop(context);
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        : null,
                  ),
                  child: Image.network(artwork.imageUrl, fit: BoxFit.cover),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: _isLoggedIn
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddArtworkPage()),
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
