import 'package:flutter/material.dart';
import 'package:flutter_cnode_app/components/TopicsList.dart';
import 'package:flutter_cnode_app/constants/index.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  // tabbar controller
  late TabController _tabController;

  List<Tab> tabs = [Tab(text: '全部'), Tab(text: '精华'), Tab(text: '分享')];
  final List<String> _tabCodes = ['all', 'good', 'share'];


  Widget _getTabBars() {
    return TabBar(
      controller: _tabController,
      overlayColor: WidgetStateProperty.resolveWith((states) => Colors.transparent),
      indicatorColor: GlobalConstants.primaryColor,
      labelColor: GlobalConstants.primaryColor,
      unselectedLabelColor: Colors.black,
      tabs: tabs,
    );
  }

  Widget _getTabBarViews() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: List.generate(_tabCodes.length, (index) => TopicsList(tab: _tabCodes[index])),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [_getTabBars(), _getTabBarViews()]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
