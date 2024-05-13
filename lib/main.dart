import 'package:flutter/material.dart';
import 'user.dart';
import 'user_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CadPeople',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TabBarDemo(),
    );
  }
}

class TabBarDemo extends StatelessWidget {
  const TabBarDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Plataforma CadPeople',
            style: TextStyle(),
          ),
          centerTitle: true, // Centraliza o título
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Usuário Cadastrado'),
              Tab(text: 'Cadastrar Usuário'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UserListScreen(),
            AddUserScreen(),
          ],
        ),
      ),
    );
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> futureUsers;
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    futureUsers = userService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.picture),
                      ),
                      title: Text('${user.firstName} ${user.lastName}'),
                      subtitle: Text(user.email),
                      trailing: Wrap(
                        spacing: 12,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showEditDialog(user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteUser(user.id),
                          ),
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
    );
  }

  void _showEditDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar usuário"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                initialValue: user.title,
                decoration: const InputDecoration(labelText: 'Titulo'),
              ),
              TextFormField(
                initialValue: user.firstName,
                decoration: const InputDecoration(labelText: 'Primeiro nome'),
              ),
              TextFormField(
                initialValue: user.lastName,
                decoration: const InputDecoration(labelText: 'Sobrenome'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Salvar"),
            onPressed: () {
              _updateUser(user);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _updateUser(User user) {
    // implementar a atualização do usuário
  }

  void _deleteUser(String id) {
    userService.deleteUser(id).then((_) {
      _showSnackbar('Usuário deletado com sucesso!');
      _refreshUserList();
    }).catchError((error) {
      _showSnackbar('Falha ao deletar o usuário.');
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _refreshUserList() {
    setState(() {
      futureUsers = userService.getUsers();
    });
  }
}

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: tituloController,
            decoration: const InputDecoration(labelText: 'Primeiro Nome'),
          ),
          TextFormField(
            controller: firstnameController,
            decoration: const InputDecoration(labelText: 'Sobrenome'),
          ),
          TextFormField(
            controller: lastnameController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 20), // Adiciona um espaço
          ElevatedButton(
            onPressed: () {
              _addUser(
                tituloController.text,
                firstnameController.text,
                lastnameController.text,
              );
            },
            child: const Text('Cadastrar'),
          ),
        ],
      ),
    );
  }

  void _addUser(
    String titulo,
    String firstName,
    String lastName,
  ) {
    final UserService userService = UserService();

    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      userService
          .createUser(User(
        id: '',
        title: titulo,
        firstName: firstName,
        lastName: lastName,
        email: '',
        picture: '',
      ))
          .then((newUser) {
        _showSnackbar('Usuário cadastrado com sucesso!');
        Navigator.pop(
            context); // Fecha a tela de cadastro após adicionar o usuário
      }).catchError((error) {
        _showSnackbar('Falha ao cadastrar o usuário: $error');
      });
    } else {
      _showSnackbar('Por favor, preencha todos os campos.');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}


// import 'package:flutter/material.dart';
// import 'user.dart';
// import 'user_service.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'CadPeople',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const TabBarDemo(),
//     );
//   }
// }

// class TabBarDemo extends StatelessWidget {
//   const TabBarDemo({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Plataforma CadPeople',
//             style: TextStyle(),
//           ),
//           centerTitle: true, // Centraliza o título
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'Usuário Cadastrado'),
//               Tab(text: 'Cadastrar Usuário'),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             UserListScreen(),
//             AddUserScreen(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class UserListScreen extends StatefulWidget {
//   const UserListScreen({Key? key}) : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _UserListScreenState createState() => _UserListScreenState();
// }

// class _UserListScreenState extends State<UserListScreen> {
//   late Future<List<User>> futureUsers;
//   final UserService userService = UserService();

//   final TextEditingController tituloController = TextEditingController();
//   final TextEditingController firstnameController = TextEditingController();
//   final TextEditingController lastnameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController pictureController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     futureUsers = userService.getUsers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: FutureBuilder<List<User>>(
//             future: futureUsers,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 if (snapshot.hasError) {
//                   return Center(child: Text("Error: ${snapshot.error}"));
//                 }
//                 return ListView.builder(
//                   itemCount: snapshot.data?.length ?? 0,
//                   itemBuilder: (context, index) {
//                     User user = snapshot.data![index];
//                     return ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: NetworkImage(user.picture),
//                       ),
//                       title: Text('${user.firstName} ${user.lastName}'),
//                       subtitle: Text(user.email),
//                       trailing: Wrap(
//                         spacing: 12,
//                         children: <Widget>[
//                           IconButton(
//                             icon: const Icon(Icons.edit),
//                             onPressed: () => _showEditDialog(user),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete),
//                             onPressed: () => _deleteUser(user.id),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               } else {
//                 return const Center(child: CircularProgressIndicator());
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   // ignore: unused_element
//   Widget _buildEditAndDeleteButtons(User user) {
//     return Wrap(
//       spacing: 12,
//       children: <Widget>[
//         IconButton(
//           icon: const Icon(Icons.edit),
//           onPressed: () => _showEditDialog(user),
//         ),
//         IconButton(
//           icon: const Icon(Icons.delete),
//           onPressed: () => _deleteUser(user.id),
//         ),
//       ],
//     );
//   }

//   void _showEditDialog(User user) {
//     tituloController.text = user.title;
//     firstnameController.text = user.firstName;
//     lastnameController.text = user.lastName;
//     emailController.text = user.email;
//     pictureController.text = user.picture;

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Editar usuário"),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               TextFormField(
//                 controller: tituloController,
//                 decoration: const InputDecoration(labelText: 'Titulo'),
//               ),
//               TextFormField(
//                 controller: firstnameController,
//                 decoration: const InputDecoration(labelText: 'Primeiro nome'),
//               ),
//               TextFormField(
//                 controller: lastnameController,
//                 decoration: const InputDecoration(labelText: 'Sobrenome'),
//               ),
//               TextFormField(
//                 controller: pictureController,
//                 decoration: const InputDecoration(labelText: 'Picture URL'),
//               ),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: const Text("Salvar"),
//             onPressed: () {
//               _updateUser(user);
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void _updateUser(User user) {
//     Map<String, dynamic> dataToUpdate = {
//       'Primeiro nome': firstnameController.text,
//       'Sobrenome': lastnameController.text,
//       'Foto': pictureController.text,
//     };

//     if (tituloController.text.isNotEmpty &&
//         firstnameController.text.isNotEmpty &&
//         lastnameController.text.isNotEmpty &&
//         pictureController.text.isNotEmpty) {
//       userService.updateUser(user.id, dataToUpdate).then((updatedUser) {
//         _showSnackbar('Usuário salvo com sucesso!');
//         _refreshUserList();
//       }).catchError((error) {
//         _showSnackbar('Falha ao salvar o usuário: $error');
//       });
//     }
//   }

//   void _deleteUser(String id) {
//     userService.deleteUser(id).then((_) {
//       _showSnackbar('Usuário deletado com sucesso!');
//       _refreshUserList();
//     }).catchError((error) {
//       _showSnackbar('Falha ao deletar o usuário.');
//     });
//   }

//   // ignore: unused_element
//   Widget _buildAddUserForm() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: <Widget>[
//           TextFormField(
//             decoration: const InputDecoration(labelText: 'Primeiro nome'),
//           ),
//           TextFormField(
//             decoration: const InputDecoration(labelText: 'Sobrenome'),
//           ),
//           TextFormField(
//             decoration: const InputDecoration(labelText: 'Email'),
//           ),
//           const SizedBox(
//               height: 20), // Adiciona um espaço entre os campos e o botão
//           ElevatedButton(
//             onPressed: () {},
//             child: const Text('Cadastrar'),
//           ),
//         ],
//       ),
//     );
//   }

//   // ignore: unused_element
//   void _addUser() {
//     if (firstnameController.text.isNotEmpty &&
//         lastnameController.text.isNotEmpty &&
//         emailController.text.isNotEmpty) {
//       userService
//           .createUser(User(
//         id: '',
//         title: tituloController.text,
//         firstName: firstnameController.text,
//         lastName: lastnameController.text,
//         email: emailController.text,
//         picture: '',
//       ))
//           .then((newUser) {
//         _showSnackbar('Usuário Cadastrado com Sucesso!');
//         _refreshUserList();
//       }).catchError((error) {
//         _showSnackbar('Falha ao Adicionar o usuário: $error');
//       });
//     } else {
//       _showSnackbar('Por favor, preencha todos os campos.');
//     }
//   }

//   void _refreshUserList() {
//     setState(() {
//       futureUsers = userService.getUsers();
//     });
//   }

//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }
// }

// class AddUserScreen extends StatelessWidget {
//   const AddUserScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: <Widget>[
//           TextFormField(
//             decoration: const InputDecoration(labelText: 'Primeiro Nome'),
//           ),
//           TextFormField(
//             decoration: const InputDecoration(labelText: 'Sobrenome'),
//           ),
//           TextFormField(
//             decoration: const InputDecoration(labelText: 'Email'),
//           ),
//           const SizedBox(height: 20), // Adiciona um espaço
//           ElevatedButton(
//             onPressed: () {},
//             child: const Text('Cadastrar'),
//           ),
//         ],
//       ),
//     );
//   }
// }
