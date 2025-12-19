import 'package:flutter/material.dart';
import 'package:flutter_cnode_app/api/user.dart';
import 'package:flutter_cnode_app/store/token_manage.dart';
import 'package:flutter_cnode_app/store/user_manage.dart';
import 'package:flutter_cnode_app/utils/loading.dart';
import 'package:flutter_cnode_app/utils/toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _tokenController = TextEditingController();

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  _handleLogin() async {
    if (_tokenController.text.isEmpty) {
      ToastUtils.showWarning(context, 'AccessToken不能为空');
    } else {
      LoadingUtils.show(context);
      final res = await handleLogin(_tokenController.text.trim());
      if (!mounted) return;
      LoadingUtils.hide(context);
      if (res is String) {
        ToastUtils.showError(context, res);
      } else {
        ToastUtils.showSuccess(context, '登录成功', 2);
        // 缓存 token
        await TokenManage.setToken(_tokenController.text.trim());
        // 缓存用户信息
        Map<String, dynamic> userInfo = {
          "id": res['id'],
          "loginname": res['loginname'],
          "avatar_url": res['avatar_url'],
        };
        await UserManage.setUserInfo(userInfo);
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pop(context, true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('登录')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _tokenController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: '输入 AccessToken 或者扫码识别',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: () {
                      ToastUtils.show(context, '扫码功能待实现');
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: GestureDetector(
                  onTap: () {
                    _handleLogin();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _tokenController.text.isEmpty
                          ? Colors.black26
                          : Colors.black87,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "登录",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
