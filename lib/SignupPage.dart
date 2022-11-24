import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'UserInfomation.dart';
import 'mainColor.dart';


class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const SizedBox(
              height: 20,
            ),
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
              validator: (value){
                if (value!.length < 6){
                  return '비밀번호가 너무 짧습니다.';
                }
                return null;
              },
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
              validator: (value){
                if (value!=password1){
                  return '비밀번호가 일치하지 않습니다.';
                }
                return null;
              },
              onChanged: (value){
                password2 = value;
              },
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed:() async {
                String notice='';
                if (password1 == password2){
                  password = password1;
                  notice = '회원가입이 완료되었습니다.';
                  var newUser = context.read<Users>().trySignup(email,password);
                  if (newUser !=null){
                    _formKey.currentState!.reset();
                    if (!mounted) return ;
                  }
                }
                else{
                  notice = '비밀번호가 일치하지 않습니다.';
                  if(_formKey.currentState!.validate()){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('히히')));
                  }
                }
                showDialog(context: context,
                    builder: (context) => SimpleDialog(
                      title: const Center(child: Text('안내문')),
                      contentPadding: const EdgeInsets.all(10),
                      children: [
                        Center(child: Text(notice)),
                        TextButton(onPressed:
                            (){
                          if (password1 == password2){
                            Navigator.popUntil(context, (route) => route.isFirst);
                          }
                          else{
                            Navigator.of(context).pop();
                          }
                        }, child: Text('확인'))
                      ],
                    )
                );
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

