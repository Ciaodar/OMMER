import 'package:flutter/material.dart';
import 'package:ommer/Providers/ShoppingCartProvider.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget{
  @override
  State<Cart> createState() => CartState();
}

class CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;
    final ors = context.watch<ShoppingCartProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: Container(
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "My Cart",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.8,
              height: MediaQuery.of(context).size.height*0.65,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                itemCount: ors.cartList.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal:15),
                          width: devicesize.width*0.1,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              Container(
                                child: Text(ors.cartList[index].name),
                              ),
                              Container(
                                child: Text("\$${ors.cartList[index].price}",style: const TextStyle(color: Colors.grey),),
                              ),
                            ],
                          ) ,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => setState(() => ors.removeProduct(index)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(50)
                            ),
                            child: const Icon(Icons.close),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 60),
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                          child: const Text("Total Price",style: TextStyle(color: Colors.white54),),
                        ),
                        Container(
                          child: Text("\$${ors.totalprice().toStringAsFixed(2)}",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: (){
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          title: const Text('Placing Order'),
                          content: Text('You will be paying at the door.'),
                          actions: [
                            ElevatedButton(
                              child: Text('Confirm'),
                              onPressed: (){
                                /*



                                      There will be a sql insertion soon



                                 */
                              },
                            ),
                          ],
                        );
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Row(
                          children: const [
                            Text("Place Order ",style: TextStyle(color: Colors.white),),
                            Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}