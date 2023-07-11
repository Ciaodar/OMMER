import 'package:flutter/material.dart';
import 'package:ommer/DatabaseConnection.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../Objects/User.dart';
import '../Widgets/LogoutIcon.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

void isCheckedIn(BuildContext context) async {
  final conn = await DatabaseConnection().connect();
  try {
    final results = await conn.query(
        'SELECT * FROM reservations WHERE uid = ?',
        [context.read<User>().uid],
    );

    if (results.isNotEmpty) {
      context.read<User>().updateUserInfo(checkedIn: true,roomid: results.elementAt(0).elementAt(2));
      Navigator.of(context).pushReplacementNamed('/categories');
    }
  }
  catch(e){
    print(e);
  }
}


class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    isCheckedIn(context);
    return WillPopScope(
      onWillPop: (){
        showLogoutDialog(context);
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            leading: const LogoutIcon(),
            backgroundColor: const Color.fromRGBO(2, 108, 174, 1),
            title: const Text('Scan QR'),
          ),
          body: Consumer<User>(builder: (context, userProvided, _) {
            final deviceSize=MediaQuery.of(context).size;
            return InkWell(
              splashColor: Colors.orange,
              splashFactory: NoSplash.splashFactory,
              onTap: () => isCheckedIn(context),
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hello ${userProvided.name}'),
                    const Text('Please make reception scan this QR to start using the app'),
                    const SizedBox(height: 16.0),
                    QrImage(
                      data: userProvided.uid.toString(),
                      version: QrVersions.auto,
                      size: deviceSize.height-400,
                    ),
                  ],
                ),
              ),
            );
          })
      ),
    );
  }
}
