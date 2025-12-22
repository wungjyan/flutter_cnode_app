import 'package:flutter/material.dart';

class ToLoginBtn extends StatefulWidget {
  final VoidCallback? loginSuccess;
  const ToLoginBtn({super.key, this.loginSuccess});

  @override
  State<ToLoginBtn> createState() => _ToLoginBtnState();
}

class _ToLoginBtnState extends State<ToLoginBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: () async {
            final result = await Navigator.pushNamed(context, '/login');
            if (result == true) {
              widget.loginSuccess?.call();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: const Text(
              "点击登录",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
  }
}