
import 'Product.dart';

class Order {
  String oid;
  String username;
  String roomnumber;
  String orderstate;
  List<Product> orderPrds;

  double totalPrice(){
    double tot=0;
    for(Product prd in orderPrds){
      tot+=prd.price;
    }
    return tot;
  }

  Order({required this.oid, required this.username, required this.roomnumber,required this.orderstate,required this.orderPrds});
}