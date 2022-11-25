import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'mainColor.dart';


class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SignupForm(),
    );
  }
}
class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email='';
  String password1 = '';
  String password2 = '';
  String password = '';
  bool showSpinner = false;
  bool error = false;
  int _sex=0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(height: 35,),
            Image.asset(
              'appbar.png',
              height: 60,
            ),
            const SizedBox(height: 55,),

            /* 성별 */
            CupertinoSlidingSegmentedControl(
              padding: const EdgeInsets.all(5),
              children: const {
                0:Padding(padding: EdgeInsets.all(5),
                  child: Text('남성',style: TextStyle(fontSize: 18)),),
                1:Text('여성',style: TextStyle(fontSize: 18),),
              },
              groupValue: _sex,
              onValueChanged: (newValue){
                setState(() {
                  _sex=newValue!;
                });
              },
            ),
            const SizedBox(height: 20,),

            /* 이메일 */
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
            const SizedBox( height: 20,),

            /* 비밀번호 */
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
                password1 = value;
              },
            ),
            const SizedBox( height: 20,),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelStyle: TextStyle(
                    color: AppColor.mainColor,
                    fontWeight: FontWeight.bold
                ),
                labelText: 'Re-enter password',
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.mainColor)
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.mainColor),
                ),
              ),
              onChanged: (value){
                password2 = value;
              },
            ),
            const SizedBox(height: 20,),
            
            /* 회원가입 로직 */
            ElevatedButton(
              onPressed:() async {
                String notice='';
                if (password1 == password2 ){
                  password = password1;
                  try{
                    notice = '회원가입이 완료되었습니다.';
                    error = false;
                    final newUser = await _authentication.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser.user !=null){
                      _formKey.currentState!.reset();
                      if (!mounted) return ;
                    }
                  }
                  /* 회원가입 에러메세지 번역 */
                  catch(e){
                    error = true;
                    notice = e.toString();
                    if (notice=='[firebase_auth/weak-password] Password should be at least 6 characters'){
                      notice = '비밀번호를 최소 6자리 이상 입력해주세요';
                    }else if(notice=='[firebase_auth/invalid-email] The email address is badly formatted.'){
                      notice = '올바르지 않은 이메일 형식입니다.';
                    }else if(notice=='[firebase_auth/unknown] Given String is empty or null'){
                      notice = '값을 입력해주세요.';
                    }
                  }
                }
                else{
                  error = true;
                  notice = '비밀번호가 일치하지 않습니다.';
                }
                if (error){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(notice)));
                }
                else{
                  showDialog(context: context,
                      builder: (context) => SimpleDialog(
                        title: const Center(child: Text('안내문')),
                        contentPadding: const EdgeInsets.all(10),
                        children: [
                          Center(child: Text(notice)),
                          TextButton(
                              onPressed: (){ Navigator.popUntil(context, (route) => route.isFirst);},
                              child: const Text('확인'))
                        ],
                      )
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.mainColor
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('회원가입',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15
                  ),),
              ),
            )
          ],
        ),
      ),
    );
  }
}

