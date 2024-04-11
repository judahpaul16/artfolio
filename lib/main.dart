import 'package:flutter/material.dart';
import 'package:artfolio/utils/db_helper.dart';
import 'package:artfolio/models/artwork.dart';
import 'package:artfolio/utils/settings.dart';
import 'package:artfolio/utils/theme.dart';
import 'package:artfolio/artwork_detail_page.dart';
import 'package:artfolio/edit_artwork_page.dart';
import 'package:artfolio/add_artwork_page.dart';
import 'package:artfolio/profile_page.dart';
import 'package:artfolio/buy_coffee_page.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestStoragePermission();
  await AppStrings.init();
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
    setState(() {
      _futureBuilderKey = UniqueKey();
      _artworkListFuture = DatabaseHelper.instance.getArtworks();
    });
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
      // print all variables
      // print('username: ${_usernameController.text}');
      // print('password: ${_passwordController.text}');
      // print('AppStrings.username: ${AppStrings.username}');
      // print('AppStrings.password: ${AppStrings.password}');
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 200,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/profile.jpg'),
                        radius: 50,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppStrings.homePageTitle,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoggedIn)
              ListTile(
                title: const Text('Edit Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()));
                },
              ),
            ListTile(
              title: const Text('Buy me a coffee'),
              onTap: () {
                var url = AppStrings.buyCoffeeUrl;
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BuyCoffeePage(url: url)));
              },
            ),
            ListTile(
              title: Text(_isLoggedIn ? 'Logout' : 'Admin Login'),
              onTap: () {
                if (_isLoggedIn) {
                  _toggleLoginState();
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Admin Login'),
                      content: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              decoration:
                                  const InputDecoration(labelText: 'Username'),
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
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
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
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _login();
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
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
                                onPressed: () => _editArtwork(context, artwork),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.white),
                                onPressed: () =>
                                    _confirmDelete(context, artwork),
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
                _addArtwork(context);
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _confirmDelete(BuildContext context, Artwork artwork) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Artwork'),
        content: Text('Are you sure you want to delete ${artwork.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.instance.deleteArtwork(artwork.id!);
              Navigator.pop(context);
              _refreshArtworkList();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Artwork deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addArtwork(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddArtworkPage()),
    ).then((value) {
      if (value == true) {
        _refreshArtworkList();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Artwork added'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  void _editArtwork(BuildContext context, Artwork artwork) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditArtworkPage(artwork: artwork)),
    ).then((_) {
      _refreshArtworkList();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Artwork updated'),
          backgroundColor: Colors.blue,
        ),
      );
    });
  }
}
