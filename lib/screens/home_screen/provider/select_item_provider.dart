import 'package:flutter_riverpod/legacy.dart';

final selectItemProvider=StateNotifierProvider<SelectItem,int>((ref){
  return SelectItem();
});

class SelectItem extends StateNotifier<int>{
  SelectItem() : super(0);


  Future<void> changeItem(int index)async{
    state=index;
  }
}