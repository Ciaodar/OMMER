import 'package:flutter/material.dart';
import 'package:ommer/DatabaseConnection.dart';
import 'package:provider/provider.dart';

import '../Objects/User.dart';

class AddReservationPanel extends StatefulWidget {
  const AddReservationPanel({super.key});

  @override
  State<AddReservationPanel> createState() => _AddReservationPanelState();
}

class _AddReservationPanelState extends State<AddReservationPanel> {
  DateTime _checkinTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(days: 1));
  final TextEditingController _uidController = TextEditingController();
  final TextEditingController _roomidController = TextEditingController();
  final TextEditingController _checkinController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    if (context.read<User>().qrUid!=null) {
      _uidController.text = context.watch<User>().qrUid!;
    }
    _checkinController.text = _checkinTime.toLocal().toString().split(' ')[0];
    _endTimeController.text =  _endTime.toLocal().toString().split(' ')[0];
    var deviceSize=MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey.shade300
              ),

              child: Column(
                children: [
                  AppBar(
                    title: const Text("Add Reservation"),
                    backgroundColor: Colors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: deviceSize.width-100,
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'User ID'),
                          controller: _uidController,
                        ),
                      ),
                      InkWell(
                        onTap:() {
                          Navigator.of(context).pushNamed('/liveqr');
                        },
                        child: const Icon(Icons.qr_code_scanner_outlined)
                      )
                    ],
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Room ID'),
                    controller: _roomidController,
                  ),

                  // Use a TextFormField widget to allow the user to select a check-in date and time.
                  TextFormField(
                    onChanged: (value) => setState(() {}),
                    controller: _checkinController,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: _checkinTime,
                        firstDate: DateTime.now(),
                        lastDate: _checkinTime.add( const Duration(days: 30))
                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            _checkinTime = date.subtract(Duration(hours: DateTime.now().hour));
                            _endTime = date.subtract(Duration(hours: DateTime.now().hour)).add(const Duration(days: 1));
                          });
                        }
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Check-in Date'),
                  ),
                  // Use a TextFormField widget to allow the user to select an end date and time.
                  TextFormField(
                    onChanged: (value) => setState(() {}),
                    controller: _endTimeController,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: _endTime.add(Duration(seconds: 1)),
                        firstDate: _checkinTime.add(Duration(days: 1)),
                        lastDate: _checkinTime.add(const Duration(days: 30))
                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            _endTime = date.subtract(Duration(hours: DateTime.now().hour));
                          });
                        }
                      });
                    },
                    decoration: const InputDecoration(labelText: 'End Date'),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        insertRez(_uidController.text, _roomidController.text, _checkinTime, _endTime);
                      },
                      child: const Text('Add Reservation'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void insertRez(String uid,String roomid,DateTime checkinTime,DateTime endTime)async{
  final conn = await DatabaseConnection().connect();
  try{
    final results = await conn.query(
        'INSERT INTO reservations(uid, rezid, roomid, checkinTime, endTime) '
            'VALUES (?,uuid(),?,?,?)',
        [uid,roomid,checkinTime.toUtc().add(Duration(hours: 3)),endTime.toUtc().add(Duration(hours: 3))]
    );
  }
  catch(e){
    print('.\n\n\n\n$e\n\n\n\n\n');
  }
}


