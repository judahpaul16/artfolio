import 'package:flutter/material.dart';
import 'package:artfolio/utils/settings.dart';
import 'package:artfolio/utils/db_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController(text: AppStrings.fullname);
  final _usernameController = TextEditingController(text: AppStrings.username);
  final _passwordController = TextEditingController(text: AppStrings.password);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                // disabled
                enabled: false,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  AppStrings.fullname = _nameController.text;
                  AppStrings.username = _usernameController.text;
                  AppStrings.password = _passwordController.text;
                  // Update in the database
                  DatabaseHelper.instance.updateUser(
                    AppStrings.fullname,
                    AppStrings.username,
                    AppStrings.password,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: const Text('Profile updated'),
                        backgroundColor: Colors.green.withOpacity(0.8)),
                  );
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary),
                ),
                child: const Text('Save Changes',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
