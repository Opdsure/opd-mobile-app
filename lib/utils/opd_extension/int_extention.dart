extension IntExtention on int{

  String getRelation(){
    switch(this){
      case 0:
        return 'Self';
      case 1:
        return 'Father';
      case 2:
        return 'Mother';
      case 3:
        return 'Sister';
      case 4:
        return 'Brother';
      case 5:
        return 'Son';
      case 6:
        return 'Daughter';
      case 7:
        return 'Wife';
      case 8:
        return 'Husband';
      case 9:
        return 'Father in law';
      case 10:
        return 'Mother in law';
      default:
        return 'Self';
    }
  }
}