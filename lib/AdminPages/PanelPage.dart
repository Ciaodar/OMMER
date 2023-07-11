import 'package:flutter/material.dart';
import 'package:ommer/DatabaseConnection.dart';
import 'package:ommer/Objects/Order.dart';
import 'package:ommer/Objects/Product.dart';
import 'package:provider/provider.dart';

import '../Widgets/LogoutIcon.dart';

class PanelPage extends StatefulWidget {
  const PanelPage({Key? key}) : super(key: key);

  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  List<Order> orders = [];
  void refreshPage() {
    updateOrders();
    setState(() {});
  }

  void updateOrders() async {
    final conn = await DatabaseConnection().connect();
    final results = await conn.query(
        "select o.oid, u.name, r.roomid, o.order_state from orders o, user u, reservations r where o.order_state != 'finished' and o.uid=u.uid and o.uid=r.uid");
    List<String> oids = [];
    for (Order ord in orders) {
      oids.add(ord.oid);
    }
    for (var row in results) {
      final results2 = await conn.query(
          "select m.pid,pname,category,price from order_products op, menu m where op.pid=m.pid and oid=?",
          [row[0]]);
      List<Product> prdlist = [];
      for (var row2 in results2) {
        prdlist.add(Product(
            pid: row2[0], name: row2[1], category: row2[2], price: row2[3]));
      }

      if (!oids.contains(row[0])) {
        orders.add(Order(
          oid: row[0],
          username: row[1],
          roomnumber: row[2],
          orderstate: row[3],
          orderPrds: prdlist,
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), refreshPage);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showLogoutDialog(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const LogoutIcon(),
          title: const Text('Orders'),
          actions: [
            InkWell(
              onTap: () => refreshPage(),
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Icon(Icons.refresh)),
            ),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed('/panel/rez'),
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Icon(Icons.person_add)),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            Order order = orders[index];

            return Container(
              margin: const EdgeInsets.all(3),
              child: InkWell(
                splashColor: Colors.orange,
                borderRadius: BorderRadius.circular(15),
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Change Status"),
                          content: const Text("Change Order's status to:"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  updateStatus("Preparing", order.oid);
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Preparing")),
                            ElevatedButton(
                                onPressed: () {
                                  updateStatus("On the Way", order.oid);
                                  Navigator.of(context).pop();
                                },
                                child: const Text("On the Way")),
                            ElevatedButton(
                                onPressed: () {
                                  updateStatus("finished", order.oid);
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Finished")),
                          ],
                        );
                      });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    color: Colors.blue,
                  ),
                  child: ExpansionTile(
                    collapsedIconColor: Colors.black,
                    iconColor: Colors.black,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${order.username} - ${order.roomnumber} - ${order.orderstate}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Text(
                              'Total Price: \$${order.totalPrice()}',
                              style: const TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    children: order.orderPrds.map((product) {
                      return Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black26,
                        ),
                        child: ListTile(
                          title: Text(product.name,
                              style: const TextStyle(
                              color: Colors.white,
                          ),
                        ),
                          subtitle: Text('${product.category} - \$${product.price}',
                            style: const TextStyle(
                                color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void updateStatus(String status, String oid) {}
