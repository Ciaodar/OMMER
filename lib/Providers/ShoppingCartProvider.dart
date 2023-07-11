import 'package:flutter/cupertino.dart';
import 'package:ommer/Objects/Product.dart';
import 'package:provider/provider.dart';

class ShoppingCartProvider with ChangeNotifier{
  var cartList = [];
  ShoppingCartProvider();
  void addProduct(Product product){
    cartList.add(product);
    notifyListeners();
  }
  double totalprice(){
    double total=0;
    for (Product product in cartList){
      total= total + product.price;
    }
    return total;
  }


  void resetCart(){
    cartList=[];
    notifyListeners();
  }


  void removeProduct(int index){
    cartList.removeAt(index);
    notifyListeners();
  }

/*
  Iterable<List<Object?>> toQuery(String oid){
    Iterable<List<Object?>> ret=[[]];
    int c=0;
    for (Product prd in cartList){
      ret.elementAt(c).addAll([oid,prd.pid]);
      c++;
    }
    return ret;
  }

 */
}