import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/MenuProvider.dart';
import '../Providers/ShoppingCartProvider.dart';
import '../Widgets/LogoutIcon.dart';


class CategoryPage extends StatefulWidget{
  const CategoryPage({super.key});
  @override
  State<StatefulWidget> createState() => CategoryPageState();
}

class CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    String backimage='asst/drinksback.png';
    // Get the MenuProvider from the context
    var prov = context.watch<MenuProvider>();
    var deviceSize=MediaQuery.of(context).size;
    var categories=prov.categories;
    var cart = context.watch<ShoppingCartProvider>();

    // Create a list of categories


    // Create a ListView of categories
    return WillPopScope(
      onWillPop: (){
        showLogoutDialog(context);
        return Future.value(false);
      },
      child: Scaffold(
        floatingActionButton: Container(
          child: FittedBox(
            child: Stack(
              alignment: const Alignment(1.4, -1.5),
              children: [
                FloatingActionButton(
                  // Your actual Fab
                  onPressed: (){
                    Navigator.of(context).pushNamed('/categories/cart');
                  },
                  backgroundColor: Colors.black,//_goToCart,
                  child: const Icon(Icons.shopping_bag),
                ),
                cart.cartList.length>0 ?
                Container(
                  // This is your Badge
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
                  decoration: BoxDecoration(
                    // This controls the shadow
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 1,
                          blurRadius: 5,
                          color: Colors.black.withAlpha(50))
                    ],
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.blue, // This would be color of the Badge
                  ),
                  // This is your Badge
                  child: Center(
                    child: Text("${cart.cartList.length}", style: const TextStyle(color: Colors.white)),
                  ),
                ):
                Container(),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          leading: const LogoutIcon(),
          title: const Text('Menu'),
          backgroundColor: const Color.fromRGBO(57, 31, 15, 1),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 40),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('asst/drinksback.png'),fit: BoxFit.fitHeight,)
          ),
          child: Container(
            width: deviceSize.width,
            height: deviceSize.height-40,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              //shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                // Get the category at the current index
                String category = categories[index].catname;
                return Container(
                  child: Column(
                      children: [
                        InkWell(

                          splashColor: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            setState(() {
                              for (PCat cat in categories){
                                if(cat.catname!=categories[index].catname){
                                  cat.isextended=false;
                                }
                              }
                              if(categories[index].isextended) {
                                categories[index].isextended=false;
                              }
                              else{
                                categories[index].isextended=true;
                              }
                            });
                          },
                          child: Container(
                            //height: deviceSize.height/11,
                            width: deviceSize.width/1.2,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blue
                                ),
                                child: Row(

                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(categories[index].isextended? Icons.arrow_upward:Icons.arrow_forward),
                                    Text(
                                      category,
                                      style: TextStyle(
                                        color: Colors.blue.shade900,
                                        fontWeight: FontWeight.bold,

                                      ),
                                    ),
                                    const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        categories[index].isextended?
                        Container(
                          margin: const EdgeInsets.only(bottom: 20,top: 1),
                          child: Column(
                            children: [
                              Container(
                                width: deviceSize.width/1.25,
                                child: const Image(
                                  image: AssetImage('asst/menustart.png'),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              Column(
                              children: prov.getProducts(category).map((product){
                                return InkWell(
                                  onTap: (){
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Add to Cart: ${product.name}"),
                                          content: Text("Do you want to add ${product.name} to your cart?"),
                                          actions: [
                                            ElevatedButton(
                                              child: const Text("Cancel"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ElevatedButton(
                                              child: const Text("Add"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                // Do something when user adds to cart
                                                context.read<ShoppingCartProvider>().addProduct(product);
                                                //print(context.read<ShoppingCartProvider>().cartList);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 30),
                                    width: deviceSize.width/1.25,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(image: AssetImage('asst/menueach.png'),fit: BoxFit.fitWidth)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'MarkScript',
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          '\$${product.price}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'MarkScript',
                                            fontSize: 15,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              ),
                              Container(
                                width: deviceSize.width/1.25,
                                child: const Image(
                                  image: AssetImage('asst/menuend.png'),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ],
                          ),
                        ):const SizedBox(width: 10,height: 10,),
                        const SizedBox(width: 10,height: 10,),
                      ]
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}