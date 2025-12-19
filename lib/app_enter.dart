import 'package:flutter/material.dart';
import 'package:flutter_cnode_app/api/user.dart';
import 'package:flutter_cnode_app/pages/main/index.dart';
import 'package:flutter_cnode_app/pages/login.dart';
import 'package:flutter_cnode_app/pages/topic_detail.dart';
import 'package:flutter_cnode_app/store/token_manage.dart';
import 'package:flutter_cnode_app/store/user_manage.dart';

class AppEnter extends StatefulWidget {
  const AppEnter({super.key});

  @override
  State<AppEnter> createState() => _AppEnterState();
}

class _AppEnterState extends State<AppEnter> {
  @override
  void initState() {
    super.initState();
    _bootstrapAuth();
  }

  Future<void> _bootstrapAuth() async {
    final token = await TokenManage.getToken();
    if (token == null || token.isEmpty) return;
    final res = await handleLogin(token);
    if (res is String) {
      await TokenManage.removeToken();
      await UserManage.removeUserInfo();
      return;
    }
    final userInfo = {
      'id': res['id'],
      'loginname': res['loginname'],
      'avatar_url': res['avatar_url'],
    };
    await UserManage.setUserInfo(userInfo);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/login': (context) => LoginPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/topic_detail') {
          final id = settings.arguments as String?;
          return MaterialPageRoute(
            builder: (context) => TopicDetailPage(id: id ?? ''),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}
