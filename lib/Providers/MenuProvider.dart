import 'package:flutter/cupertino.dart';
import 'package:ommer/Objects/Product.dart';
import 'package:provider/provider.dart';

class MenuProvider with ChangeNotifier{
  List<Product> menu=[];
  List<PCat> categories=[];
  void initCats(List<Product> menu){
    categories = menu.map((product) => product.category).toSet().toList().map((category) => PCat(category)).toList();
  }

  void addProduct(Product product){
    menu.add(product);
    notifyListeners();
  }
  List<Product> getProducts(String category){
    return menu.where((element) {
      if (category==element.category){
        return true;
      }
      else {
        return false;
      }
    }).toList();
  }
}
class PCat {
  String catname;
  bool isextended=false;
  PCat(this.catname);
}