import 'package:apiflutter/user.dart';
import 'package:apiflutter/user_service.dart';
import 'package:flutter/material.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  late Future<List<User>> futureUsers;
  final UserService userService = UserService();

  final TextEditingController tituloController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pictureController = TextEditingController();

  void _addUser() {
    if (firstnameController.text.isNotEmpty &&
        lastnameController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      userService
          .createUser(User(
        id: '', // ID é gerado pela API, não precisa enviar
        title: tituloController.text, // Incluído, assumindo que você ainda quer enviar isso
        firstName: firstnameController.text,
        lastName: lastnameController.text,
        email: emailController.text,
        picture: pictureController.text, // Incluído, assumindo que é necessário
      ))
          .then((newUser) {
        _showSnackbar('User added!');
        _refreshUserList();
      }).catchError((error) {
        _showSnackbar('Failed to add user: $error');
      });
    } else {
      _showSnackbar('Fill in all fields.');
    }
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
        title: const Text("Register"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 199, 199, 199),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 500,
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFormField(
                      controller: firstnameController,
                      style: const TextStyle(color: Colors.white), // Cor do texto
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.white), // Cor do contorno
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: lastnameController,
                      style: const TextStyle(color: Colors.white), // Cor do texto
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.white), // Cor do contorno
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white), // Cor do texto
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.white), // Cor do contorno
                        ),
                      ),
                    ),
                    TextButton.icon(
                      label: const Text("Add User"),
                      icon: const Icon(Icons.add),
                      onPressed: _addUser, // Corrigido: removi os parênteses
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 78, 79, 78)),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          fixedSize: MaterialStateProperty.all(const Size(150, 10))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:apiflutter/user.dart';
// import 'package:apiflutter/user_service.dart';
// import 'package:flutter/material.dart';

// class UserForm extends StatefulWidget {
//   const UserForm({super.key});

//   @override
//   State<UserForm> createState() => _UserFormState();
// }

// class _UserFormState extends State<UserForm> {
//   late Future<List<User>> futureUsers;
//   final UserService userService = UserService();

//   final TextEditingController tituloController = TextEditingController();
//   final TextEditingController firstnameController = TextEditingController();
//   final TextEditingController lastnameController = TextEditingController();
//   final TextEditingController emailController =
//       TextEditingController(); // Added for email
//   final TextEditingController pictureController = TextEditingController();

//   void _addUser() {
//     if (firstnameController.text.isNotEmpty &&
//         lastnameController.text.isNotEmpty &&
//         emailController.text.isNotEmpty) {
//       userService
//           .createUser(User(
//         id: '', // ID é gerado pela API, não precisa enviar
//         title: tituloController
//             .text, // Incluído, assumindo que você ainda quer enviar isso
//         firstName: firstnameController.text,
//         lastName: lastnameController.text,
//         email: emailController.text,
//         picture: pictureController.text, // Incluído, assumindo que é necessário
//       ))
//           .then((newUser) {
//         _showSnackbar('User added!');
//         _refreshUserList();
//       }).catchError((error) {
//         _showSnackbar('Failed to add user: $error');
//       });
//     } else {
//       _showSnackbar('Fill in all fields.');
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 118, 119, 120),
//       appBar: AppBar(
//         title: const Text("Register"),
//         centerTitle: true,
//         backgroundColor: Color.fromARGB(255, 199, 199, 199),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(
//                 width: 500,
//                 height: 250,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     TextFormField(
//                       controller: firstnameController,
//                       decoration: const InputDecoration(
//                         labelText: 'Name',
//                         labelStyle: TextStyle(color: Colors.white),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                         ),
//                       ),
//                     ),
//                     TextFormField(
//                       controller: lastnameController,
//                       decoration: const InputDecoration(
//                         labelText: 'First Name',
//                         labelStyle: TextStyle(color: Colors.white),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                         ),
//                       ),
//                     ),
//                     TextFormField(
//                       controller: emailController, // Added email input field
//                       decoration: const InputDecoration(
//                         labelText: 'Email',
//                         labelStyle: TextStyle(color: Colors.white),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                         ),
//                       ),
//                     ),
//                     TextButton.icon(
//                       label: const Text("Add User"),
//                       icon: const Icon(Icons.add),
//                       onPressed: () => _addUser,
//                       style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all(
//                               const Color.fromARGB(255, 35, 172, 40)),
//                           foregroundColor:
//                               MaterialStateProperty.all(Colors.white),
//                           fixedSize: MaterialStateProperty.all(const Size(150, 10))),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
