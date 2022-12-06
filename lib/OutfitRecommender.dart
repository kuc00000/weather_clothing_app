//*****Example Code*****
//outfitOutput = outfitRecommendation(userConstitution, degree, outers , tops,bottoms)
//userConstitution = adjustConstitution(feedback,userConstitution,todayOutfit,degree);


// [lowerBound, upperBound, clothID]
import 'package:flutter/foundation.dart';

final outers =[
  [12,14,0],//바람막이
  [18,20,1],//청자켓
  [19,21,2],//야상
  [16,18,3],//트러커자켓
  [19,21,4],//가디건/후드집업
  [20,22,5],//폴리스
  [21,23,6],//야구잠바
  [21,22,7],//항공잠바
  [19,21,8],//가죽자켓
  [22,24,9],//환절기코트
  [21,23,10],//조끼패딩
  [23,25,11],//무스탕
  [24,26,12],//숏패딩
  [26,28,13],//겨울코트
  [27,30,14],//돕바
  [28,30,15],// 롱패딩
];
final tops =[
  [0,2,100],//민소매티셔츠
  [0,3,101],//반소매티셔츠
  [4,6,102],//긴소매티셔츠
  [3,5,103],//셔츠
  [12,14,104],//맨투맨
  [13,15,105],//후드티셔츠
  [14,16,106],//목폴라
  [18,20,107],// 니트/스웨터
  [0,3,108],//여름블라우스
  [1,4,109],//봄가을블라우스
];
final bottoms =[ //maximum 10
  [0,2,200],//숏팬츠
  [5,7,201],//트레이닝팬츠
  [3,5,202],//슬랙스
  [7,9,203],//데님팬츠
  [8,10,204],// 코튼팬츠
  [0,3,205],//여름스커트
  [3,6,206],//봄가을스커트
  [3,5,207],//레깅스
  [6,9,208],// 겨울스커트
];
//
List<List<int>> outfitRecommendation(List<int> userConstitution,int degree,
    List<dynamic> userOuters,List<dynamic> userTops, List<dynamic> userBottoms) {
  // final womanBoth =[
  //   [0,8,0],//여름원피스
  //   [9,15,1],// 봄가을원피스
  //   [18,24,2],// 겨울원피스
  // ];
  final banList=[ //해당 값은 ban 됌 [outer,top,bottom]
    //1000: 모든 옷 포함, -1 : 무시.
    [1000,0,-1],//하의는 상관없이, 민소매는 모든 아우터와 입지 않는다.
    [1000,-1,0], //상의와 상관없이, 숏팬츠는 모든 아우터와 입지 않는다.
    [1000,8,-1], //하의와 상관없이, 여름 블라우스는 모든 아우터와 입지 않는다.
    [1000,-1,5], //상의와 상관없이, 여름 스커트 는 모든 아우터와 입지 않는다.
    [-1,0,8],//아우터와 상관없이, 민소매와 겨울스커트
    [-1,1,8],//아우터와 상관없이, 반소매와 겨울스커트
  ];
  int minC = 30;
  userConstitution[0]+=minC;
  userConstitution[1]+=minC;
  List<int> aim = [userConstitution[0]-degree<0?0:userConstitution[0]-degree,userConstitution[1]-degree<0?0:userConstitution[1]-degree];
  List<List<dynamic>> idRecommend= [];
  List<List<int>> indexRecommend= [];
  List<List<int>> existOuter = [];
  List<List<int>> existTop = [];
  List<List<int>> existBottom = [];
  List<int> adequateRecommendation =[5,8];
  double lowerCriteria = 0.0;
  double upperCriteria=100.0;
  double curCriteria=0.0;
  double spareCriteria = 0.0;
  int tryFindCriteria = 0;

  //Will care about one piece at the end
  //organize the clothes existence
  List<int>.generate(userOuters.length, (i) => i).where((i)=>userOuters[i]).forEach((e) {existOuter.add(outers[e]);});
  List<int>.generate(userTops.length, (i) => i).where((i)=>userTops[i]).forEach((e) {existTop.add(tops[e]);});
  List<int>.generate(userBottoms.length, (i) => i).where((i)=>userBottoms[i]).forEach((e) {existBottom.add(bottoms[e]);});

  //If there can't be any combination
  if (existTop.isEmpty || existBottom.isEmpty){
    userConstitution[0]-=minC;
    userConstitution[1]-=minC;
    return [[-1,-1,-1]];
  }

  if (degree<=15){ //Must wear outer
    idRecommend+=outerBruteForce(aim, existOuter,existTop, existBottom );
  }else if (degree<=27){ //Can wear outer or not
    idRecommend+=bruteForce(aim, existTop, existBottom);
    idRecommend+=outerBruteForce(aim, existOuter,existTop, existBottom );
  }else{ //Cannot wear outer
    idRecommend+=bruteForce(aim, existTop, existBottom);
  }
  //It there is no clothes recommendation found.
  int lenIDR = idRecommend.length;
  if (lenIDR==0){
    userConstitution[0]-=minC;
    userConstitution[1]-=minC;
    return [[-1,-1,-1]];
  }


  List<bool> havetoBanList = List.generate(lenIDR, (i) => false).toList();
  //먼저 ban list 에 있는거 없나 점검
  for (var banIndex=0;banIndex<banList.length;banIndex++){
    for (var idRIndex=0;idRIndex<lenIDR;idRIndex++){
      bool haveToBan = true;
      for (var oub = 0 ; oub<3 ; oub++){
        if (banList[banIndex][oub]==-1){}
        else if(banList[banIndex][oub]==1000){if(idRecommend[idRIndex][oub] ==-1) {haveToBan = haveToBan&false;} }
        else{if(banList[banIndex][oub]!=idRecommend[idRIndex][oub]){haveToBan=haveToBan&false;}}
        // if (idRecommend[idRIndex][2]==5){print(haveToBan);}
      }
      // if (idRecommend[idRIndex][2]==5){print("end");}
      if (haveToBan){
        havetoBanList[idRIndex]=true;
      }
    }
  }
  lenIDR = idRecommend.length;
  for (var i=0;i<lenIDR;i++){
    if(havetoBanList[i]){
      idRecommend[i]=[-1,-1,-1,-1];
    }
  }
  for (var i=0;i<idRecommend.length;i++){
    lenIDR= idRecommend.length;
    if (lenIDR>=i){break;}
    if (idRecommend[i]==[-1,-1,-1,-1]){idRecommend.removeAt(i);}
  }
  lenIDR = idRecommend.length;
  //binary search
  while(tryFindCriteria<=100){
    //set Criteria
    curCriteria = (lowerCriteria+upperCriteria)/2;
    int count=0;
    for (var idRIndex=0;idRIndex<lenIDR;idRIndex++){
      if (idRecommend[idRIndex][3]>=curCriteria){
        count+=1;
      }
    }
    if (count>=adequateRecommendation[0] && count<=adequateRecommendation[1]){
      break; //find adequate curCriteria!
    }else{
      tryFindCriteria+=1;
      if (count>adequateRecommendation[1]){ //too many.. have to search larger criteria
        lowerCriteria=curCriteria;
      }else{ //too less.. have to search smaller criteria
        upperCriteria=curCriteria;
      }
    }
    if (count>adequateRecommendation[1]){
      spareCriteria=curCriteria;
    }
    // print('$lowerCriteria, $upperCriteria, $curCriteria, $count');
  }
  //너무 작으면 그나마 컸던 걸로 선택
  if (indexRecommend.length<adequateRecommendation[0]){
    curCriteria=spareCriteria;
  }
  print('$tryFindCriteria 회 탐색, 유사도: $curCriteria%');
  //Translate ID to index
  int indexRecommendSize = -1;
  for (var t =0; t<idRecommend.length;t++){
    if(idRecommend[t][3]>=curCriteria){
      indexRecommend.add([-1,-1,-1]);
      indexRecommendSize+=1;
      List<int> id = [
        idRecommend[t][0]==-1?-1:existOuter[idRecommend[t][0]][2],
        idRecommend[t][1]=existTop[idRecommend[t][1]][2],
        idRecommend[t][2]=existBottom[idRecommend[t][2]][2]];
      for(var idIndex=0;idIndex<3;idIndex++) {
        if (id[idIndex] != -1) {
          indexRecommend[indexRecommendSize][id[idIndex] ~/ 100] = id[idIndex] % 100;
        }else{indexRecommend[indexRecommendSize][idIndex]=-1;}
      }
    }
  }
  indexRecommend.shuffle();
  if (indexRecommend.length>adequateRecommendation[1]){ indexRecommend=indexRecommend.sublist(0,adequateRecommendation[1]);print(indexRecommend); }
  userConstitution[0]-=minC;
  userConstitution[1]-=minC;
  if(indexRecommend.isEmpty){return [[-1,-1,-1]];}

  return indexRecommend;
}

List<List<dynamic>> bruteForce(aim,List<List<int>> topField, List<List<int>> bottomField){
  List<List<dynamic>> recommend = [];
  double getSimilarity;
  for (var topIndex=0;topIndex<topField.length;topIndex++){
    for(var bottomIndex=0;bottomIndex<bottomField.length;bottomIndex++){
      getSimilarity = suitable(aim, x: topField[topIndex], y: bottomField[bottomIndex]);
      if (getSimilarity!=0) {
        recommend.add([-1,topIndex, bottomIndex,getSimilarity]);
      }
    }
  }

  return recommend;
}

List<List<dynamic>> outerBruteForce(List<int> aim,List<List<int>> outerField,List<List<int>> topField,List<List<int>> bottomField ){
  List<List<dynamic>> recommend = [];
  double getSimilarity;
  for (var topIndex=0;topIndex<topField.length;topIndex++){
    for(var bottomIndex=0;bottomIndex<bottomField.length;bottomIndex++){
      for(var outerIndex=0;outerIndex<outerField.length;outerIndex++) {
        if(topField[topIndex][2] !=100 &&topField[topIndex][2] !=101 && bottomField[bottomIndex][2] !=200){ //민소매 : 100, 숏팬츠 : 101,반소매: 200
          getSimilarity = suitable(aim, x: topField[topIndex], y: bottomField[bottomIndex],z:outerField[outerIndex]);
          if (getSimilarity!=0) {
            recommend.add([outerIndex,topIndex, bottomIndex,getSimilarity]);
          }
        }
      }
    }
  }
  return recommend;
}


double suitable( List<int> aim,{List<int>? x,List<int>? y,List<int>? z}){ //cloth이 aim에 포함되는지 출력
  List<int> clothes = [0,0];
  int overlapRange=0;
  //Criteria 는 옷의 전체 range
  //if it is not one piece
  if (x !=null){clothes[0]+=x[0];clothes[1]+=x[1];}
  if (y !=null){clothes[0]+=y[0];clothes[1]+=y[1];}
  if (z !=null){clothes[0]+=z[0];clothes[1]+=z[1];}
  if (clothes[1]>=aim[0] && clothes[0]<=aim[1]){
    overlapRange = ((clothes[1]<aim[1]?clothes[1]:aim[1])-(clothes[0]>aim[0]?clothes[0]:aim[0])+1);
    return (200*overlapRange/(clothes[1]-clothes[0]+aim[1]-aim[0]+2)-
        0.01*( ((clothes[1]+clothes[0])/2)-((aim[1]+aim[0])/2)>0?
        ((clothes[1]+clothes[0])/2)-((aim[1]+aim[0])/2):
        -(((clothes[1]+clothes[0])/2)-((aim[1]+aim[0])/2))
        )) ; //suitable
  }
  return 0; //not suitable
}

List<int> adjustHere(int mode, List<int> beforeConstitution, int index, int change,int minC, int maxC,int minSize, int maxSize ){
  List<int> afterConstitution=[0,0];
  if (mode==0){ //index 의 위치를 change 위치로 바꾸고 max 창크기로 리셋을 원함
    if (index==1){ // 더울 때

      if(minC+minSize<=change){
        afterConstitution[1] = change;
        if(afterConstitution[1]-maxSize>=minC){ //범위 초과 안됌
          afterConstitution[0] = afterConstitution[1]-maxSize;
        }else{ //범위 초과시
          if(afterConstitution[1]-minC>=minSize){ //그냥 0 index 가 minC가 되면 될 때
            afterConstitution[0] = minC;
          }else{ //0 index 가 minC가 될 때 minimum 창 크기보다 작아질 때, 0을 기준으로 리셋
            afterConstitution[0] = minC;
            afterConstitution[1] = minC+maxSize;
          }
        }
      }else{
        afterConstitution[0]=minC;
        afterConstitution[1]=minC+maxSize;
      }
    }else{ // 추울 때
      if(maxC-minSize>=change){ //일단 요구된 값이 존재가능한 최고값은 maxC-minSize임
        afterConstitution[0] = change;
        if(afterConstitution[0]+maxSize<=maxC){ //범위 초과 안됌
          afterConstitution[1] = afterConstitution[0]+maxSize;
        }else{ //범위 초과시
          if(maxC-afterConstitution[1]>=minSize){ //그냥 1 index 가 maxC가 되면 될 때
            afterConstitution[1] = maxC;
          }else{ //1 index 가 maxC가 될 때 minimum 창 크기보다 작아질 때, 1을 기준으로 리셋
            afterConstitution[1] = maxC;
            afterConstitution[0] = maxC-maxSize;
          }
        }
      }else{ //애초에 요구자체가 불가능한 값이였을 때, 리셋
        afterConstitution[1]=maxC;
        afterConstitution[0]=maxC-maxSize;
      }
    }
  }else{ //index의 위치를 change 위치로 바꾸기만 원함
    if (index==1){ // 더울 때
      if(minC+minSize<=change){//일단 요구된 값이 존재가능한 최저값은 minC+minSize임
        afterConstitution[1]=change;
        if(afterConstitution[1]-beforeConstitution[0]<minSize){ //그냥 0index 도 그대로 따라가면 안될 때
          afterConstitution[0]=((afterConstitution[1]-maxSize)>minC?(afterConstitution[1]-maxSize):minC);
        }else{ //그대로 따라가도 될때
          afterConstitution[0]=beforeConstitution[0];
        }
      }
      else{ //애초에 요구자체가 불가능한 값이였을 때, 리셋
        afterConstitution[0]=minC;
        afterConstitution[1]=minC+maxSize;
      }

    }else{ // 추울 때
      if(maxC-minSize>=change){ //일단 요구된 값이 존재가능한 최고값은 maxC-minSize임
        afterConstitution[0]=change;
        if(beforeConstitution[1]-afterConstitution[0]<minSize){ //그냥 1 index 도 그대로 따라가면 안될 때
          afterConstitution[1]=((afterConstitution[0]+maxSize)<maxC?(afterConstitution[0]+maxSize):maxC);
        }else{ //그대로 따라가도 될때
          afterConstitution[1]=beforeConstitution[1];
        }
      }else{ //애초에 요구자체가 불가능한 값이였을 때, 리셋
        afterConstitution[1]=maxC;
        afterConstitution[0]=maxC-maxSize;
      }
    }
  }
  return afterConstitution;
}


List<int> adjustConstitution(int feedback,List<int> userConstitution,List<int> userOutfit,int todayWeather) { //feedback : 0~4 int, userConstitution : [a,b] 알고리즘 수정필요******
  //feedback =>  [so cold, cold, normal, hot, so hot]
  //default [7,14] 0~20
  //30<=constitution<=50
  List<int> userOutfitSum=[0,0];
  int maxSize=8;
  int minSize=2;
  int minC = 30;
  int maxC = 50;

  userConstitution[0]+=minC;
  userConstitution[1]+=minC;
  if (userOutfit[0]!=-1){
    userOutfitSum[0]+=outers[userOutfit[0]][0];
    userOutfitSum[1]+=outers[userOutfit[0]][1];
  }
  userOutfitSum[0]+=tops[userOutfit[1]][0];
  userOutfitSum[1]+=tops[userOutfit[1]][1];
  userOutfitSum[0]+=bottoms[userOutfit[2]][0];
  userOutfitSum[1]+=bottoms[userOutfit[2]][1];

  if(feedback==2){ //nothing to change
    userConstitution[0]-=minC;
    userConstitution[1]-=minC;
    return userConstitution;
  }
  else { // hot or cold
    int extreme = 1;
    if (feedback==0 || feedback ==4){ //was TOO hot or cold?
      extreme=2;
    }
    //Ideal : outfit + weather = constitute
    userOutfitSum[0]+=todayWeather;
    userOutfitSum[1]+=todayWeather;

    if (feedback>2){ //더울 때
      if(userConstitution[1]<userOutfitSum[1]){ //best case 통과
        if(userConstitution[1]<userOutfitSum[0]) { //worst case 통과
        }else{ //worst case 미통과, worst case 제외
          userConstitution = adjustHere(1,userConstitution, 1, userConstitution[1]-extreme,minC,maxC,minSize,maxSize);
        }
      }else{ //best case 미통과, best case 로 리셋
        userConstitution = adjustHere(0,userConstitution, 1, userOutfitSum[1]-extreme,minC,maxC,minSize,maxSize);
      }
    }
    else{//추울 때
      if(userConstitution[0]>userOutfitSum[0]){ //best case 통과
        if(userConstitution[0]>userOutfitSum[1]){ //worst case 통과
        }else{ //worst case 미통과, worst case 제외
          userConstitution = adjustHere(1,userConstitution, 0, userConstitution[0]+extreme,minC,maxC,minSize,maxSize);
        }
      }else{ //best case 미통과, best case 로 리셋
        userConstitution = adjustHere(0,userConstitution, 0, userOutfitSum[0]+extreme,minC, maxC,minSize,maxSize);
      }
    }
  }

  userConstitution[0]-=minC;
  userConstitution[1]-=minC;
  return userConstitution; //return type: [a,b]
}



