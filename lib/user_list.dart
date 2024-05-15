import 'package:apiflutter/user.dart';
import 'package:apiflutter/user_service.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  late Future<List<User>> futureUsers;
  final UserService userService = UserService();

  final TextEditingController tituloController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController =
      TextEditingController(); // Added for email
  final TextEditingController pictureController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureUsers = userService.getUsers();
  }

  Widget _buildEditAndDeleteButtons(User user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Wrap(
        spacing: 50,
        children: <Widget>[
          TextButton.icon(
            label: const Text("Edit"),
            icon: const Icon(Icons.edit),
            onPressed: () => {
              _showEditDialog(user),
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 78, 79, 78)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                fixedSize: MaterialStateProperty.all(const Size(100, 10))),
          ),
          TextButton.icon(
            label: const Text("Delete"),
            icon: const Icon(Icons.delete),
            onPressed: () => {
              _deleteUser(user.id!),
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color.fromARGB(255, 78, 79, 78)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                fixedSize: MaterialStateProperty.all(const Size(100, 10))),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(User user) {
    tituloController.text = user.title!;
    firstnameController.text = user.firstName;
    lastnameController.text = user.lastName;
    emailController.text =
        user.email; // Assuming email cannot be updated, disable this field
    pictureController.text = user.picture!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit User"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                  controller: tituloController,
                  decoration: const InputDecoration(labelText: 'Title')),
              TextFormField(
                  controller: firstnameController,
                  decoration: const InputDecoration(labelText: 'First Name')),
              TextFormField(
                  controller: lastnameController,
                  decoration: const InputDecoration(labelText: 'Last Name')),
              TextFormField(
                  controller: pictureController,
                  decoration: const InputDecoration(labelText: 'Picture URL')),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Update"),
            onPressed: () {
              Navigator.of(context).pop();
              _updateUser(user);
            },
          ),
        ],
      ),
    );
  }

  void _updateUser(User user) {
    // Inicializa um Map para armazenar apenas os campos permitidos para atualização
    Map<String, dynamic> dataToUpdate = {
      'firstName': firstnameController.text,
      'lastName': lastnameController.text,
      'picture': pictureController.text,
      // Não inclua 'email' pois é proibido atualizar
    };

    if (tituloController.text.isNotEmpty &&
        firstnameController.text.isNotEmpty &&
        lastnameController.text.isNotEmpty &&
        pictureController.text.isNotEmpty) {
      userService.updateUser(user.id!, dataToUpdate).then((updatedUser) {
        _showSnackbar('User updated successfully!');
        _refreshUserList();
      }).catchError((error) {
        _showSnackbar('Failed to update user: $error');
      });
    }
  }

  void _deleteUser(String id) {
    userService.deleteUser(id).then((_) {
      _showSnackbar('User deleted successfully!');
      _refreshUserList();
    }).catchError((error) {
      _showSnackbar('Failed to delete user.');
    });
  }

  void _refreshUserList() {
    setState(() {
      futureUsers = userService.getUsers();
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 118, 119, 120),
      appBar: AppBar(
        title: const Text("List of Users"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 122, 122, 123),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<User>>(
              future: futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      User user = snapshot.data![index];
                      return Card(
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.picture!),
                          ),
                          title: Text("${user.firstName} ${user.lastName}"),
                          subtitle:
                              Text(user.email), // Changed to display email
                          children: [
                            _buildEditAndDeleteButtons(user),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
