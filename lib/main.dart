import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class ItemTab {
  String title;
  Icon icon;
  ItemTab({required this.title, required this.icon});
}

List<ItemTab> _tabBar = [
  ItemTab(title: 'Photo', icon: Icon(Icons.home)),
  ItemTab(title: 'Chat', icon: Icon(Icons.chat)),
  ItemTab(title: 'Albums', icon: Icon(Icons.rounded_corner)),
];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Домашка №5'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabBarController;
  int _currentTabIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? _botSheController;

  void toggleBottomSheet() {
    if (_botSheController == null) {
      _botSheController = scaffoldKey.currentState!.showBottomSheet(
        (context) => Container(
          height: 230,
          color: Colors.blue[100],
          child: Center(child: Text('Hello I\'m Bottom Sheet')),
        ),
      );
    } else {
      _botSheController!.close();
      _botSheController = null;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabBarController = TabController(length: _tabBar.length, vsync: this);
    _tabBarController!.addListener(() {
      setState(() {
        _currentTabIndex = _tabBarController!.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              scaffoldKey.currentState!.openEndDrawer();
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      drawer: Drawer(
        elevation: 10,
        child: SafeArea(
            child: Column(
          children: [
            DrawerHeader(
              child: CircleAvatar(
                radius: 64,
                backgroundColor: Colors.black38,
                backgroundImage: NetworkImage('https://picsum.photos/500/500'),
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  ListTile(
                    leading: Icon(Icons.image),
                    title: const Text('Images'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Выход'),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Регистрация'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
      endDrawer: Drawer(
        elevation: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.black38,
              backgroundImage: NetworkImage('https://picsum.photos/500/500'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Svjatoslav Torn',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(controller: _tabBarController, children: [
        Container(
          child: Center(
            child: Text('Photo screen'),
          ),
        ),
        Container(
          child: Center(
            child: Text('Chat screen'),
          ),
        ),
        Container(
          child: Center(
            child: Text('Album screen'),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        onPressed: toggleBottomSheet,
        tooltip: 'Open Sheet',
        child: const Icon(Icons.open_in_new),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _tabBarController!.index = index;
            _currentTabIndex = index;
          });
        },
        currentIndex: _currentTabIndex,
        items: [
          for (final item in _tabBar)
            BottomNavigationBarItem(icon: item.icon, label: item.title),
        ],
      ),
    );
  }
}
