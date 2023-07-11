import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ommer/AdminPages/PanelPage.dart';
import 'package:ommer/AuthPages/LoginPage.dart';
import 'package:ommer/AuthPages/RegisterPage.dart';
import 'package:ommer/CustomerPages/CartPage.dart';
import 'package:ommer/DatabaseConnection.dart';
import 'package:ommer/Objects/Product.dart';
import 'package:ommer/Objects/User.dart';
import 'package:provider/provider.dart';
import 'AdminPages/addRezPage.dart';
import 'AdminPages/qrScan.dart';
import 'CustomerPages/CategoryPage.dart';
import 'CustomerPages/homePage.dart';
import 'Providers/MenuProvider.dart';
import 'Providers/ShoppingCartProvider.dart';
void main() {
  /*
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  */
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => User()), //User Provider
        ChangeNotifierProvider(create: (_) => ShoppingCartProvider()), //Shopping Cart Provider
        ChangeNotifierProvider(create: (_) => MenuProvider()), //Menu Provider
      ],
      child: const LoginApp()),);
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    updateData(context);
    return MaterialApp(
      title: 'OMMER Login',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => Homepage(),
        '/panel': (context) => PanelPage(),
        '/panel/rez': (context) => AddReservationPanel(),
        '/panel/rez/liveqr': (context)=> LiveDecodePage(),
        '/categories': (context)=> CategoryPage(),
        '/categories/cart': (context)=> Cart(),
      },
    );
  }
}

 void updateData(BuildContext context) async{
  final conn = await DatabaseConnection().connect();
  final results = await conn.query('select * from menu');
  List<Product> menulist=[];
  for ( var rows in results.toList()){
    menulist.add(Product(pid: rows[0], name: rows[1], category: rows[2], price: rows[3]));
  }
  context.read<MenuProvider>().menu=menulist;
  context.read<MenuProvider>().initCats(menulist);
 }


