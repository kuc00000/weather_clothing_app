import 'package:flutter/material.dart';
import 'mainColor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'UserInfomation.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: LoginForm(),
    );
  }
}
class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email='';
  String password = '';
  bool showSpinner = false;
  bool autoLogin = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(height: 60,),
            Image.asset(
              'appbar.png',
              height: 60,
            ),
            const SizedBox(height: 70,),
            TextFormField(
              decoration: const InputDecoration(
                labelStyle: TextStyle(
                    color: AppColor.mainColor,
                    fontWeight: FontWeight.bold
                ),
                labelText: 'Email',
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.mainColor)
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.mainColor),
                ),
              ),
              onChanged: (value){
                email = value;
              },
            ),
            const SizedBox(height: 20,),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelStyle: TextStyle(
                    color: AppColor.mainColor,
                    fontWeight: FontWeight.bold
                ),
                labelText: 'Password',
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.mainColor)
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.mainColor),

                ),
              ),
              onChanged: (value){
                password = value;
              },
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed:() async {
                  setState(() {
                   showSpinner=true;
                  });
                  try{
                    final currentUser = await _authentication.signInWithEmailAndPassword(
                        email: email, password: password);
                    setState(() {
                      showSpinner=false;
                    });
                    if (currentUser.user!=null){
                      _formKey.currentState!.reset();
                      if(!mounted) return;
                      Navigator.pushNamed(context, '/closet');
                    }
                  }
                  /* 로그인 에러메세지 번역 */
                  catch(e){
                    String error = e.toString();
                    if (error == '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.'){
                      error = '등록된 회원정보가 없습니다.';
                    } else if(error == '[firebase_auth/invalid-email] The email address is badly formatted.'){
                      error = '이메일 형식이 잘못되었습니다.';
                    } else if (error=='[firebase_auth/unknown] Given String is empty or null'){
                      error = '값을 입력해주세요.';
                    } else if (error == '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.'){
                      error = '비밀번호가 틀렸습니다.';
                    } else if (error =='[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.'){
                      error = '요청이 너무 많습니다. 잠시후 다시 시도해주세요.';
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content:Text(error))
                    );
                  }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.mainColor
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('로그인',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15
                  ),),
              ),
            ),
            Row(
              children: [
                Checkbox(
                    activeColor: AppColor.mainColor,
                    value: autoLogin,
                    onChanged: (value){
                      setState(() {
                        autoLogin = value!;
                      });
                    }),
                const Text('자동로그인'),
                const SizedBox(width: 170,),
                TextButton(onPressed: (){
                  Navigator.pushNamed(context, '/signup');
                }, child: const Text('회원가입',
                  style: TextStyle(
                      color: AppColor.mainColor
                  ),))
              ],
            )
          ],
        ),
      ),
    );
  }
}