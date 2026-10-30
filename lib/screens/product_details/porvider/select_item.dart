 import 'package:flutter_riverpod/legacy.dart';

final selectItem = StateNotifierProvider<SelectItem,int>((ref){
  return SelectItem();
});

class SelectItem extends StateNotifier<int>{
  SelectItem() : super(0);

  Future<void> getItem(int index)async{
    state=index;
  }
}