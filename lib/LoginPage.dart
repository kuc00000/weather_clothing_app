import 'package:flutter/material.dart';
import 'mainColor.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
  //final _authentication = FirebaseAuth.instance;
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
            const SizedBox(
              height: 60,
            ),
            Image.asset(
              'appbar.png',
              height: 60,
            ),
            const SizedBox(
              height: 70,
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
            const SizedBox(
              height: 20,
            ),
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
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, '/closet');

                // onPressed:() async {
                //   setState(() {
                //    showSpinner=true;
                //   });
                //   try{
                //     final currentUser = await _authentication.signInWithEmailAndPassword(
                //         email: email, password: password);
                //     setState(() {
                //       showSpinner=false;
                //     });
                //     if (currentUser.user!=null){
                //       _formKey.currentState!.reset();
                //       if(!mounted) return;
                //       Navigator.pushNamed(context, '/closet');
                //     }
                //   }
                //   catch(e){
                //     showDialog(context: context,
                //         builder: (context) => SimpleDialog(
                //           title: Center(child: const Text('안내문')),
                //           contentPadding: const EdgeInsets.all(10),
                //           children: [
                //             Center(child: Text(e.toString())),
                //             TextButton(onPressed:
                //                 (){
                //               Navigator.of(context).pop();
                //             }, child: Text('확인'))
                //           ],
                //         )
                //     );
                //   }

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