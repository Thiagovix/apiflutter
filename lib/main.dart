import 'package:flutter/material.dart';
import 'package:apiflutter/user_list.dart';
import 'package:apiflutter/users_cad.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CadPeople',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(foregroundColor: Colors.white),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Widget> _tabs = [
    const UserList(),
    const UserForm(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs,
            ),
          ),
          Container(
            color: Colors.black87, // Cor de fundo da TabBarDemo
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const <Tab>[
                Tab(
                  icon: Icon(Icons.receipt_long_rounded, color: Colors.white),
                ),
                Tab(
                  icon: Icon(
                    Icons.add_reaction_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:apiflutter/user_list.dart';
// import 'package:apiflutter/users_cad.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter User API Demo',
//       theme: ThemeData(
//         appBarTheme: AppBarTheme(foregroundColor: Colors.white),
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   Widget _getBodyWidget() {
//     switch (_selectedIndex) {
//       case 0:
//         return UserList();
//       case 1:
//         return UserForm();
//       default:
//         return UserList();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SizedBox(
//           width: 450,
//           child: _getBodyWidget(),
//         ),
//       ),
//       backgroundColor: Color.fromARGB(255, 27, 76, 119),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor:Color.fromARGB(255, 51, 142, 221),
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.receipt_long_rounded),
//             label: 'Lista',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add_reaction_outlined),
//             label: 'Cadastro',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.white,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
