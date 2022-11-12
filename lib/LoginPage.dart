import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: 380,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  '로그인',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '아이디',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '로그인에 실패하였습니다. 확인 후 다시 입력해주세요.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '비밀번호',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '로그인에 실패하였습니다. 확인 후 다시 입력해주세요.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ListTileTheme(
                        horizontalTitleGap: 0,
                        child: CheckboxListTile(
                          title: const Text('자동 로그인',
                            style: TextStyle(letterSpacing : 0, fontSize: 15),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value!;
                            });
                          },
                          checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    TextButton(style: TextButton.styleFrom(foregroundColor: Colors.black),
                        onPressed: () {
                          setState(() {
                            Navigator.pushNamed(context, '/signup');
                          });
                        }, child: const Text('회원가입', style: TextStyle(fontSize: 15),)),
                  ],
                ),
                ElevatedButton(onPressed: () {
                  setState(() {
                    Navigator.pushNamed(context, '/location');
                  });
                }, style: ElevatedButton.styleFrom(
                    minimumSize: const Size(380,45),
                    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    backgroundColor: Colors.grey),
                    child: const Text('로그인')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}