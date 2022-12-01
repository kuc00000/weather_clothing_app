import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'mainColor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UserInfomation.dart';
import 'package:provider/provider.dart';

class MyClosetPage extends StatefulWidget {
  const MyClosetPage({Key? key}) : super(key: key);

  @override
  State<MyClosetPage> createState() => _MyClosetPageState();
}

class _MyClosetPageState extends State<MyClosetPage> {
  final _authentication = FirebaseAuth.instance;
  int _currentStep = 0;
  List<bool> steps = [true,false,false];
  List<int> outer = List.generate(16, (i) => i);
  List<int> manTop = List.generate(8, (i) => i);
  List<int> manBottom = List.generate(5, (i) => i);

  List<int> womanTop = List.generate(10, (i) => i);
  List<int> womanBottom = List.generate(9, (i) => i);

  var myOuter;
  var myTop;
  var myBottom;

  int userSex = 0;

  /* 성별가져오기 */
  static final storage = FlutterSecureStorage();
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _asyncMethod();
      context.read<Users>().readDB();
    });
  }
  _asyncMethod() async {
    final userInfo = await FirebaseFirestore.instance.collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid).get();
    userSex = userInfo.data()!['userSex'] ;
    myOuter = userInfo.data()!['outer'];
    // print(myOuter);
    myTop = userInfo.data()!['top'];
    myBottom = userInfo.data()!['bottom'];

    // if(isFirst=='true'){
      showDialog(context: context,
          builder: (context) => SimpleDialog(
        title: const Center(child: Text('안내문')),
        contentPadding: const EdgeInsets.all(10),
        children: [
          Center(child: Text('가지고 있는 옷을 선택해주세요.')),
          TextButton(
              onPressed: (){ Navigator.pop(context);},
              child: const Text('확인'))
        ],
      ));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset(
          'appbar.png',
          height: 45,
        ),
        actions: [
          /* 로그아웃 코드 -> 그냥 옷장 종료 */
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.clear,
            color: Colors.black54,size: 30,))
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Stepper(
          type: StepperType.horizontal,
          steps: [
            Step(
                title: Text('상의',style: TextStyle(fontSize: 20),),
                content: Container(
                  height: MediaQuery.of(context).size.height-280,
                  child : GridView.count(crossAxisCount: 3,
                    children:
                        userSex==0?
                          manTop.map((i)=>BTN2(imageName: i,pos: 'top',)).toList()
                          :womanTop.map((i)=>BTN2(imageName: i,pos: 'top',)).toList()
                    ,),
                ),
                isActive: steps[0],
                state: StepState.complete
            ),
            Step(
                title: Text('하의',style: TextStyle(fontSize: 20),),
                content: Container(
                  height: MediaQuery.of(context).size.height-280,
                  child : GridView.count(crossAxisCount: 3,
                    children:
                        userSex==0?
                          manBottom.map((i)=>BTN2(imageName: i,pos: 'bottom',)).toList()
                          :womanBottom.map((i)=>BTN2(imageName: i,pos: 'bottom',)).toList()
                    ,),
                ),
                isActive: steps[1],
                state: StepState.complete
            ),
            Step(
                title: Text('아우터',style: TextStyle(fontSize: 20),),
                content: Container(
                  height: MediaQuery.of(context).size.height-280,
                  child : GridView.count(crossAxisCount: 3,
                    children:
                    outer.map((i)=>BTN2(imageName: i,pos: 'outer',)).toList()
                    ,),
                ),
                isActive: steps[2],
                state: StepState.complete
            ),
          ],
          /* 스텝간 이동 로직 */
          onStepTapped: (newIndex){
            setState(() {
              _currentStep = newIndex;
              steps = [false,false,false];
              steps[_currentStep]=true;
            });
          },
          currentStep: _currentStep,
          onStepContinue: (){
            if (_currentStep!=2){
              setState(() {
                _currentStep +=1;
                steps = [false,false,false];
                steps[_currentStep]=true;
              });
            }
          },
          onStepCancel: (){
            if (_currentStep !=0){
              setState(() {
                _currentStep -=1;
                steps = [false,false,false];
                steps[_currentStep]=true;
              });
            }
          },
          /* 이전단계, 저장하기, 다음단계 버튼 */
          controlsBuilder:
              (BuildContext context, ControlsDetails details){
            return Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed:details.onStepCancel,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15,bottom: 15,right: 10,left: 15),
                        child: Text('이전단계',style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/20),),
                      )),
                  TextButton(
                      onPressed:()async {
                        await FirebaseFirestore.instance
                            .collection('user')
                            .doc(_authentication.currentUser!.uid)
                            .update({
                        'outer':context.read<Users>().myOuter,
                        'top':context.read<Users>().myTop,
                        'bottom':context.read<Users>().myBottom
                      });
                        if(!mounted) return;
                        context.read<Users>().setCloset('outer', myOuter);
                        context.read<Users>().setCloset('top', myTop);
                        context.read<Users>().setCloset('bottom', myBottom);

                        final userInfo = await FirebaseFirestore.instance.collection('user')
                            .doc(FirebaseAuth.instance.currentUser!.uid).get();
                        if(!mounted) return;
                        if (userInfo.data()!['isFirstVisit']==true){
                          await FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser?.uid).update({
                            'isFirstVisit':false
                          });
                          showDialog(context: context,
                              builder: (context) => SimpleDialog(
                                title: const Center(child: Text('안내문')),
                                contentPadding: const EdgeInsets.all(10),
                                children: [
                                  Center(child: Text('저장되었습니다.')),
                                  TextButton(
                                      onPressed: (){
                                        Navigator.popUntil(context, (route) => route.isFirst);
                                        // Navigator.pop(context);
                                        Navigator.pushNamed(context, '/main');
                                      },
                                      child: const Text('확인'))
                                ],
                              ));
                        }
                        else{
                          if(!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content:Text('저장되었습니다.',textAlign: TextAlign.center,),duration: Duration(milliseconds: 1000),));
                            Navigator.popUntil(context, (route) => route.isFirst);
                            // Navigator.pop(context);
                            Navigator.pushNamed(context, '/main');
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15,bottom: 15,right: 15,left: 15),
                        child: Text('저장하기',style: TextStyle(fontSize: MediaQuery.of(context).size.width/20),),
                      )),
                  TextButton(
                      onPressed:details.onStepContinue,
                      child: Padding(
                        padding:  const EdgeInsets.only(top: 15,bottom: 15,right: 15,left: 10),
                        child: Text('다음단계',style: TextStyle(fontSize: MediaQuery.of(context).size.width/20),),
                      )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class BTN2 extends StatefulWidget {
  BTN2({Key? key,this.imageName,this.pos}) : super(key: key);
  int? imageName;
  String? pos;
  @override
  State<BTN2> createState() => _BTN2State();
}

class _BTN2State extends State<BTN2> {
  Color curColor=AppColor.mainColor;
  bool checked = false;
  List<String> outers=['바람막이', '청자켓','야상','트러커자켓','가디건',
    '플리스','야구잠바','항공잠바','가죽자켓','환절기코트','조끼패딩',
    '무스탕','숏패딩','겨울코트','돕바','롱패딩'];
  List<String> tops=['민소매티','반소매티','긴소매티','셔츠','맨투맨','후드티셔츠','목폴라','니트'
    ,'여름블라우스','봄가을블라우스'];
  List<String> bottoms=['숏팬츠','트레이닝팬츠','슬랙스','데님팬츠','코튼팬츠'
  ,'여름스커트','봄가을스커트','레깅스','겨울스커트'];

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _asyncMethod();
    });
  }
  _asyncMethod() async {
    final userInfo = await FirebaseFirestore.instance.collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid).get();
    checked = userInfo.data()![widget.pos][widget.imageName];
    setState(() {
      if (checked){
        curColor == AppColor.mainColor;
      } else{
        curColor == Colors.white;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
      margin: EdgeInsets.all(15),

      child: GestureDetector(
        onTap: (){
          setState(() {
            checked?checked=false:checked=true;
            curColor == AppColor.mainColor?
              curColor = Colors.white
              :curColor = AppColor.mainColor;
          });
          context.read<Users>().addCloset(widget.pos, widget.imageName, checked);
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              // color: AppColor.mainColor,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: checked?AppColor.mainColor:Colors.white,
                      //   offset: Offset(4.0, 4.0),
                      blurRadius: 10.0,
                      //   spreadRadius: 1.0,
                    ),]
              ),
            ),
            Image.asset(
              '${widget.pos}${widget.imageName}.png',
              width: 90,
              height: 90,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Container(
                    width: 70,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // width: MediaQuery.of(context).size.width/10,
                    height: MediaQuery.of(context).size.height/45,
                    child: FittedBox(
                      child: Text(
                        widget.pos=='top'?tops[widget.imageName!]:
                      widget.pos=='bottom'?bottoms[widget.imageName!]:outers[widget.imageName!],
                      style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
