import 'package:flutter/material.dart';
import 'package:flutter_cnode_app/constants/index.dart';
import 'package:flutter_cnode_app/pages/main/views/home_view.dart';
import 'package:flutter_cnode_app/pages/main/views/collect_view.dart';
import 'package:flutter_cnode_app/pages/main/views/message_view.dart';
import 'package:flutter_cnode_app/pages/main/views/mine_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<BottomNavigationBarItem> barsList = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
    const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '收藏'),
    const BottomNavigationBarItem(icon: Icon(Icons.message), label: '消息'),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [HomeView(), CollectView(), MessageView(), MineView()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: barsList,
        currentIndex: _currentIndex,
        elevation: 0,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
        selectedItemColor: GlobalConstants.primaryColor,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
