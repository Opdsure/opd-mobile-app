void main(){
 List<Test> list = [Test(1, 1), Test(0, 0), Test(0, 0), Test(0, 0), Test(0, 0), Test(1, 1),];

 final t = list.skip(1).every((test) => test.age != 0 || test.cash != 0);
 print(list.toString());
 print(_isFamily(list.skip(1).toList()));
}


bool _isFamily(List<Test> options){
  for(var option in options){
    if(option.age == 0 || option.cash == 0){
      continue;
    }else{
      return true;
    }
  }

  return false;
}


class Test{
  int age;
  int cash;
  Test(this.age, this.cash);

  @override
  String toString() {
    return 'Test($age, $cash)';
  }
}
