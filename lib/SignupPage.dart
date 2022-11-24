import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
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
  // final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email='';
  String password1 = '';
  String password2 = '';
  String password = '';
  bool showSpinner = false;
  int _sex=0;
  String? city='서울시';
  Map<int,String> cityName = {0:'서울시',1:'경기도',2:'강원도',3:'충청도',4:'경상도'};
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            SizedBox(height: 35,),
            Image.asset(
              'appbar.png',
              height: 60,
            ),
            SizedBox(height: 35,),
            // CupertinoButton(
            //   color: Colors.indigo,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text('지역  :'),
            //         Text('$city'),
            //         Icon(Icons.search)
            //       ],
            //     ),
            //     onPressed: (){
            //       showCupertinoModalPopup(context: context,
            //           builder: (_)=>SizedBox(
            //             width: double.infinity,
            //             height: 250,
            //             child: CupertinoPicker(
            //               backgroundColor: Colors.white,
            //               itemExtent: 30,
            //               children: [
            //                 Text('서울시'),
            //                 Text('경기도'),
            //                 Text('강원도'),
            //                 Text('충청도'),
            //                 Text('경상도'),
            //               ],
            //               scrollController: FixedExtentScrollController(
            //                 initialItem: 1,
            //
            //               ),
            //               onSelectedItemChanged: (value){
            //                 setState(() {
            //                   city = cityName[value];
            //                 });
            //               },
            //             ),
            //           ));
            //     }),
            SizedBox(height: 20,),
            CupertinoSlidingSegmentedControl(
              padding: EdgeInsets.all(5),
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
                password1 = value;
              },
            ),
            SizedBox(
              height: 20,
            ),
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
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: (){},
              // onPressed:() async {
              //   final newUser;
              //   if (password1 == password2){
              //     password = password1;
              //     newUser = await _authentication.createUserWithEmailAndPassword(
              //         email: email, password: password);
              //     if (newUser.user !=null){
              //       _formKey.currentState!.reset();
              //       if (!mounted) return ;
              //       showDialog(context: context,
              //           builder: (context) => SimpleDialog(
              //             title: Center(child: const Text('안내문')),
              //             contentPadding: const EdgeInsets.all(10),
              //             children: [
              //               Center(child: Text('회원가입이 완료되었습니다.')),
              //               TextButton(onPressed:
              //                   (){
              //                 Navigator.popUntil(context, (route) => route.isFirst);
              //               }, child: Text('확인'))
              //             ],
              //           )
              //       );
              //     }
              //   }
              //   else{
              //     if(_formKey.currentState!.validate()){
              //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('히히')));
              //     }
              //     showDialog(context: context,
              //         builder: (context) => SimpleDialog(
              //           title: Center(child: const Text('안내문')),
              //           contentPadding: const EdgeInsets.all(10),
              //           children: [
              //             Center(child: Text('비밀번호가 일치하지 않습니다.')),
              //             TextButton(onPressed:
              //                 (){
              //               Navigator.of(context).pop();
              //             }, child: Text('확인'))
              //           ],
              //         )
              //     );
              //   }
              // },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('회원가입',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15
                  ),),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.mainColor
              ),
            )
          ],
        ),
      ),
    );
  }
}

