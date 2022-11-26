import 'package:flutter/material.dart';
import 'mainColor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  //
  String? UserInfo='';
  String? autoCheck='';

  /* 자동 로그인 코드 */
  static final storage = FlutterSecureStorage();
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _asyncMethod();
    });
  }
  _asyncMethod() async {
    autoCheck = (await storage.read(key: "autologin"));
    if (autoCheck=='true'){
      UserInfo = (await storage.read(key: "login"));
      if (UserInfo != null){
        final currentUser = await _authentication.signInWithEmailAndPassword(
            email: UserInfo!.split(' ')[0], password: UserInfo!.split(' ')[1]);
        if (currentUser.user!=null){
          if(!mounted) return;
          Navigator.pop(context);
          Navigator.pushNamed(context, '/closet');
        }
      }
    }
  }

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
                  /* 정상적으로 로그인 되었을때 */
                  try{
                    final currentUser = await _authentication.signInWithEmailAndPassword(
                        email: email, password: password);
                    setState(() {
                      showSpinner=false;
                    });
                    if (currentUser.user!=null){
                      _formKey.currentState!.reset();
                      await storage.write(key: "login", value: email+' '+password);
                      if(!mounted) return;
                      Navigator.pop(context);
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
                        SnackBar(content:Text(error,textAlign: TextAlign.center,))
                    );
                    storage.delete(key: 'login');
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                        activeColor: AppColor.mainColor,
                        value: autoLogin,
                        onChanged: (value) async {
                          setState(() {
                            autoLogin = value!;
                          });
                          print(autoLogin);
                          await storage.write(key: "autologin", value: autoLogin.toString());
                        }),
                    const Text('자동로그인',style: TextStyle(fontSize: 17),),
                  ],
                ),
                TextButton(onPressed: (){
                  _formKey.currentState!.reset();
                  Navigator.pushNamed(context, '/signup');
                }, child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: const Text('회원가입',
                    style: TextStyle(
                      fontSize: 20,
                        color: AppColor.mainColor
                    ),),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}