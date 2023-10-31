import 'package:flutter/material.dart';
import 'package:flutter_app/screen/category/category.dart';
import 'package:flutter_app/screen/details/catdetail.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/services/api.dart';
import 'package:flutter_app/util/subcat.dart';

class subcatDetails extends StatefulWidget {
  final String subcatlink, title;//if you have multiple values add here
  subcatDetails(this.subcatlink, this.title, {Key? key}): super(key: key);

  @override
  _subcatDetailsState createState() => _subcatDetailsState();
}

class _subcatDetailsState extends State<subcatDetails> {
  List<SCArr> listSCArr = [];
  var loading = false;
  String? topimage;
  Future<Null> getData() async {
    setState(() {
      loading = true;
    });
    final linkdata = '/'+ widget.subcatlink;
    print(baseurl + version  + linkdata);
    final responseData = await http.get( (baseurl + version  + linkdata) as Uri);
    if (responseData.statusCode == 200) {

      final data = responseData.body;
      var listsCArr = jsonDecode(data)['content']['sCArr'] as List;

      var bImage = jsonDecode(data)['content']['bImage'] ;
      setState(() {
        for (var i in listsCArr) {
          listSCArr.add(SCArr.fromMap(i));
        }
        topimage = jsonDecode(data)['content']['bImage'];
        loading = false;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    print(topimage);

    Widget? image(){
      if (topimage != null) {
        return
          Expanded(
            flex: 1,
            child: Container(
              height: 200.0,
              decoration: BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                  image: NetworkImage(
                    topimage!,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );

      }
      return null;

    }

    return new Scaffold(
        appBar: AppBar(

          elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () =>  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext context) => category())),
            ),
          title: Text(widget.title),
          centerTitle: true,

        ),
        body: loading
            ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primarycolor)))
            : ListView(
          children: [
            Column(
              children: <Widget>[
                loading
                    ? Center()
                    : Container(
                    height: 200,
                    child: Row(
                        children: <Widget>[image()!,]
                    )
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 5, top: 8.00,),
                  //alignment: FractionalOffset(1.0, 1.0),
                  width: MediaQuery.of(context).size.width,
                  height:500,
                  child: loading
                      ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primarycolor)))
                      : ListView.builder(

                    scrollDirection: Axis.vertical,
                    primary: false,
                    itemCount: listSCArr.length,
                    itemBuilder: (context, i) {
                      final nDataList = listSCArr[i];
                      return Container(
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
                          title: Text(nDataList.title.toString()),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context){
                                  return catdetail(nDataList.link!, nDataList.title!, widget.subcatlink,widget.title);
                                },
                              ),
                            );
                          },

                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        )

    );
  }



}
