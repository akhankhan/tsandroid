import 'package:flutter/material.dart';
import 'package:flutter_app/screen/login/login.dart';
import 'package:flutter_app/screen/managarequest/managarequest.dart';
import 'package:flutter_app/screen/manage/manage.dart';
import 'package:flutter_app/screen/onlistatus/onlinestatus.dart';
import 'package:flutter_app/screen/postarequest/postarequest.dart';
import 'package:flutter_app/screen/register/register.dart';
import 'package:flutter_app/screen/setting/privacy.dart';
import 'package:flutter_app/screen/setting/seting.dart';
import 'package:flutter_app/screen/setting/terms.dart';
import 'package:flutter_app/screen/support/support.dart';
import 'package:flutter_app/util/appinfo.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/services/api.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/util/profile.dart';
class Others extends StatefulWidget {
  @override
  _OthersState createState() => _OthersState();
}

class _OthersState extends State<Others> {
  String token = "";
  var loading = false;
  List<MProfile> listService = [];
  String listservicesstus = '';
  List<AppInfo> apiinforlist = [];
  Future<Null> getDatalist() async {
      final uri = Uri.parse(baseurl + version + sitedetails);

    final responseDataappinfo = await http.get( uri);
    if (responseDataappinfo.statusCode == 200) {
      final dataapinfo = responseDataappinfo.body;
      var datalist = jsonDecode(dataapinfo)['content']['app_info']  as List;
      setState(() {
        for (var i in datalist) {
          apiinforlist.add(AppInfo.fromMap(i));
        }
      });
    }
  }
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token").toString();
    });
    print(token);
    setState(() {
      loading = true;
    });
    print(token);
    if (token == null) {
      print("not");

    }else{
        final uri = Uri.parse(baseurl + version + profile);

      final responseData = await http.get( uri, headers: {'Auth': token});
      if (responseData.statusCode == 200) {
        final data = responseData.body;
        var listservices = jsonDecode(data)['content']['mProfile'] as List;

        print(listservices);
        setState(() {
          for (var i in listservices) {
            listService.add(MProfile.fromMap(i));
          }
          loading = false;
        });
      }

    }

  }

  getstatus() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token").toString();
    });
    print(token);
  final uri = Uri.parse(baseurl + version + statuscheck);

    final responseDatastatus = await http.get( uri, headers: {'Auth': token});
    if (responseDatastatus.statusCode == 200) {
      final data = responseDatastatus.body;
      var listservicesstus = jsonDecode(data)['content']['seller_status'] as String;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              onlinestatus(listservicesstus),
        ),
      );
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    getDatalist();
  }

  Widget othersec(context) {
   print(listService.length);
    if (token == null) {
      return ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                  width: double.maxFinite,
                  height: 250,
                  decoration: new BoxDecoration(
                    color: primarycolor,
                  ),
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Icon(
                                    Icons.person,
                                    size: 100,
                                    color: Colors.white,
                                  ),)),
                          ],
                        ),
                        Center(
                          child: Text(
                            "Guest",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ])),
            ],
          ),
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
            child: ListTile(
              leading: Icon(
                Icons.vpn_key,
              ),
              title:  apiinforlist.length != 0 ? Text('Join '+ apiinforlist[0].appName.toString()):Text(""),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Register(),
                  ),
                );
              },
            ),
          ),
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
            child: ListTile(
              leading: Icon(
                Icons.account_circle,
              ),
              title: Text('Sign In'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login("loginfull"),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: Text(
              "General",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
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
            child: ListTile(
              leading: Icon(
                Icons.format_indent_decrease,
              ),
              title: Text('Terms of services '),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => terms()),
                );
              },
            ),
          ),
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
            child: ListTile(
              leading: Icon(
                Icons.lock,
              ),
              title: Text('Privacy Policy'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => privacy()),
                );
              },
            ),
          ),

        ],
      );
    } else {
      return ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                  width: double.maxFinite,
                  height: 200,
                  decoration: new BoxDecoration(
                    color: primarycolor,
                  ),
                  padding: EdgeInsets.all(20.0),
                  child:loading
                      ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primarycolor)))
                      : ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: listService.length,
                      itemBuilder: (context, i) {
                        final datacard = listService[i];
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  GestureDetector(
                                    child: Icon(
                                      Icons.settings,
                                      size: 30.0,
                                      color: Colors.white,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              seting(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                Container (
                                  padding: const EdgeInsets.only(top:35.0),
                                  child: CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage: NetworkImage(datacard.sellerImage!),
                                  ),
                                )
                                ],
                              ),
                              Center(
                                child: Text(
                                  datacard.sellerName.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),

                            ]
                        );
                      })
              ),
            ],
          ),

          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: Text(
              "Buying",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
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
            child: ListTile(
              leading: Icon(
                Icons.reorder,
              ),
              title: Text('Manage Orders'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: ()
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        manageorder(),
                  ),
                );
              },


            ),
          ),
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
            child: ListTile(
              leading: Icon(
                Icons.list,
              ),
              title: Text('Manage Requests'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        manageeq(),
                  ),
                );
              },
            ),
          ),
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
            child: listService.length == 0 ? Text(""): ListTile(
              leading: Icon(
                Icons.open_in_new,
              ),
              title: Text('Post a Request '),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        postarequest(listService[0].sellerVerificationStatus!),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
            decoration: new BoxDecoration(
              color: Colors.white10,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: Text(
              "General",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
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
            child: ListTile(
              leading: Icon(
                Icons.cached,
              ),
              title: Text('Online Status'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                getstatus();
                print(listservicesstus);

              },
            ),
          ),

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
            child: ListTile(
              leading: Icon(
                Icons.rotate_left,
              ),
              title: Text('Invite Friends'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: ()    {
                final RenderBox box = context.findRenderObject();
                Share.share("https://play.google.com/store/apps/details?id=gigtodo.teamtweaks.com.gigtodo",
                    sharePositionOrigin:
                    box.localToGlobal(Offset.zero) &
                    box.size);
              },
            ),
          ),
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
            child: ListTile(
              leading: Icon(
                Icons.call,
              ),
              title: Text('Support'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => support(0)),
                );
              },
            ),
          ),
        ],
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(body: othersec(context));
  }
}
