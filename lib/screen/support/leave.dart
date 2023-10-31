import 'package:flutter/material.dart';
import 'package:flutter_app/services/api.dart';

class leave extends StatefulWidget{
  _leaveState createState()=>_leaveState();
}
class _leaveState extends State<leave>{
  int _index=0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios, size: 28,color: Colors.black87 ,),
        title: Text('Leave Feedback',style: TextStyle(color:Colors.black87),),
        centerTitle: true,
      ),
      body:Column(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(

                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
          ),
          SizedBox(height: 60),
          Container(
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: ListTile(
              title: Text('Happy',
                  style:TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  )),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){},
            ),),

          Container(
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: ListTile(
              title: Text('Confused',
                  style:TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  )),
              trailing :Icon(Icons.arrow_forward_ios),
              onTap: (){},
            ),),

          Container(
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),

            child:ListTile(
              title: Text('Unhappy',
                  style:TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  )),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){},
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (newIndex) => setState(() => _index = newIndex),
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        fixedColor: primarycolor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home",),
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline), label: "Inbox"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Explore",),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: "Notifications",),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "Others",),
        ],
      ),

    );
  }
}

