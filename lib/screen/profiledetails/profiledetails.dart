import 'package:flutter/material.dart';
import 'package:flutter_app/screen/details/catdetail.dart';
import 'package:flutter_app/screen/inbox/inboxdetail.dart';
import 'package:flutter_app/screen/login/login.dart';
import 'package:flutter_app/screen/profiledetails/cart.dart';
import 'package:flutter_app/screen/profiledetails/contactus.dart';
import 'package:flutter_app/util/home.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/util/propusal.dart';
import 'package:flutter_app/services/api.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_app/screen/custom_expansion_tile.dart' as custom;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app/screen/mainscreen.dart';
class profiledetailpage extends StatefulWidget {
  final String links, sublink, title,pretitle,prelink; //if you have multiple values add here
  profiledetailpage(this.links, this.sublink, this.title,this.prelink,this.pretitle, {Key? key}) : super(key: key);

  @override
  _profiledetailpageState createState() => _profiledetailpageState();
}

class _profiledetailpageState extends State<profiledetailpage> {
  List<PDetail> listdata = [];
  List<Faq> listfaq = [];
  List<Review> listreview = [];
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> imageslist = [];
   VoidCallback? _showPersBottomSheetCallBack;
  bool isExpanded = false;
  var loading = false;
  String token = "";
  List<RView> listreviews = [];

  myBoxDecorationfirst() {
    return BoxDecoration(
        color: Colors.white,
        border: new Border.all(
            color: Colors.grey, width: 0.5, style: BorderStyle.solid),
        borderRadius: new BorderRadius.all(new Radius.circular(10.0)));
  }

  addcart(String package, String product, String quenty) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token").toString();
    });
    setState(() {
      loading = true;
    });
  final uri = Uri.parse(baseurl + version + addcartpage);

    final response = await http.post(uri, body: {
      "proposal_id": package,
      "package_id": product,
      "proposal_qty": quenty
    }, headers: {
      'Auth': token
    });

    final data = jsonDecode(response.body);
    String value = data['status'];
    String message = data['message'];
    if (value == '1') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return cart();
          },
        ),
      );
    } else {
      setState(() {
        loading = false;
      });
      loginToast(message);
    }
  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: primarycolor,
        textColor: Colors.white);
  }

  Future<Null> reviewgetData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token").toString();
    });
    setState(() {
      loading = true;
    });


    if (token == null) {

    } else {
  final uri = Uri.parse(baseurl + version + url);

      final responseData =
          await http.get(uri, headers: {'Auth': token});
      if (responseData.statusCode == 200) {
        final data = responseData.body;
        var recents = jsonDecode(data)['content']['rViews'] as List;
        setState(() {
          for (var i in recents) {
            listreviews.add(RView.fromMap(i));
          }

          loading = false;
        });
      }
    }
  }

  Future<Null> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token").toString();
    });
    setState(() {
      loading = true;
    });


    if (token != null) {
      final linkdata = '/' + widget.links;

  final uri = Uri.parse(baseurl + version + linkdata);

      final responseData = await http.get(
          uri , headers: {'Auth': token});
      if (responseData.statusCode == 200) {
        final data = responseData.body;
        var listsCArr = jsonDecode(data)['content']['pDetails'] as List;
        //var listfaqs = jsonDecode(data)['content']['pDetails']['faqs'] as List;

        setState(() {
          for (var i in listsCArr) {
            listdata.add(PDetail.fromMap(i));
          }

          loading = false;
        });
      }
    }else{
      final linkdata = '/' + widget.links;
  final uri = Uri.parse(baseurl + version + linkdata);

      final responseData = await http.get(
          uri);
      if (responseData.statusCode == 200) {
        final data = responseData.body;
        var listsCArr = jsonDecode(data)['content']['pDetails'] as List;
        //var listfaqs = jsonDecode(data)['content']['pDetails']['faqs'] as List;

        setState(() {
          for (var i in listsCArr) {
            listdata.add(PDetail.fromMap(i));
          }

          loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    reviewgetData();
    _showPersBottomSheetCallBack = _showBottomSheet;
    getData();
  }

  void _showBottomSheet() {
    setState(() {
      _showPersBottomSheetCallBack = null;
    });

    _scaffoldKey.currentState!
        .showBottomSheet((context) {
          return new Container(
            height: MediaQuery.of(context).size.height / 1.3,
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment(-1.0, -1.0),
                  padding: EdgeInsets.only(
                      left: 10.00, right: 10.00, top: 10.00, bottom: 5.00),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: new NetworkImage(
                                              listdata[0].seller!.sellerImage!))),
                                  child: new Stack(
                                    children: <Widget>[
                                      if (listdata[0].seller!.onlineStatus ==
                                          'online')
                                        new Positioned(
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: new Icon(
                                            Icons.fiber_manual_record,
                                            size: 15.0,
                                            color: primarycolor,
                                          ),
                                        ),
                                      if (listdata[0].seller!.onlineStatus ==
                                          'offline')
                                        new Positioned(
                                          right: 0.0,
                                          bottom: 0.0,
                                          child: new Icon(
                                            Icons.fiber_manual_record,
                                            size: 15.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                    ],
                                  )),
                              new Container(
                                width: MediaQuery.of(context).size.width / 1.3,
                                padding: EdgeInsets.only(left: 10.00),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                padding:
                                                    EdgeInsets.only(left: 0),
                                                child: new Text(
                                                  listdata[0].seller!.sellerName.toString(),
                                                  style: TextStyle(),
                                                  textAlign: TextAlign.left,
                                                )),
                                            Container(
                                                width: 100.0,
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.orange,
                                                      size: 16.0,
                                                    ),
                                                    new Text(
                                                      listdata[0]
                                                          .rating!
                                                          .averageRatting.toString(),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.orange,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    new Text(
                                                      " (" +
                                                          listdata[0]
                                                              .rating!
                                                              .totalReviews.toString() +
                                                          ")",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 1,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Text("User Information"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.account_circle,
                              color: Colors.grey,
                              size: 30.0,
                            ),
                          ),
                          new Container(
                            padding: EdgeInsets.only(left: 10.00),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.only(left: 0),
                                            child: new Text(
                                              "Seller Level",
                                              style: TextStyle(),
                                              textAlign: TextAlign.left,
                                            )),
                                        Container(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Row(
                                              children: <Widget>[
                                                new Text(
                                                  listdata[0]
                                                      .seller!
                                                      .sellerLevel.toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.grey,
                              size: 30.0,
                            ),
                          ),
                          new Container(
                            padding: EdgeInsets.only(left: 10.00),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.only(left: 0),
                                            child: new Text(
                                              "Location",
                                              style: TextStyle(),
                                              textAlign: TextAlign.left,
                                            )),
                                        Container(
                                            width: 100.0,
                                            padding: EdgeInsets.only(top: 5),
                                            child: Row(
                                              children: <Widget>[
                                                new Text(
                                                  listdata[0]
                                                      .seller!
                                                      .sellerCountry.toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.folder_open,
                              color: Colors.grey,
                              size: 30.0,
                            ),
                          ),
                          new Container(
                            padding: EdgeInsets.only(left: 10.00),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.only(left: 0),
                                            child: new Text(
                                              "Recent Delivery",
                                              style: TextStyle(),
                                              textAlign: TextAlign.left,
                                            )),
                                        Container(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Row(
                                              children: <Widget>[
                                                new Text(
                                                  listdata[0]
                                                      .seller!
                                                      .recentDelivery.toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.date_range,
                              color: Colors.grey,
                              size: 30.0,
                            ),
                          ),
                          new Container(
                            padding: EdgeInsets.only(left: 10.00),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.only(left: 0),
                                            child: new Text(
                                              "Seller Since",
                                              style: TextStyle(),
                                              textAlign: TextAlign.left,
                                            )),
                                        Container(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Row(
                                              children: <Widget>[
                                                new Text(
                                                  listdata[0]
                                                      .seller!
                                                      .sellerSince.toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.grey,
                              size: 30.0,
                            ),
                          ),
                          new Container(
                            padding: EdgeInsets.only(left: 10.00),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.only(left: 0),
                                            child: new Text(
                                              "Seller Last Activity",
                                              style: TextStyle(),
                                              textAlign: TextAlign.left,
                                            )),
                                        Container(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Row(
                                              children: <Widget>[
                                                new Text(
                                                  listdata[0]
                                                      .seller!
                                                      .sellerLastActivity.toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 1,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    new Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                              left: 15.00,
                              right: 10.00,
                              top: 0.00,
                              bottom: 10.00),
                          child: Text(
                            "Description",
                            style: new TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                              left: 15.00,
                              right: 10.00,
                              top: 0.00,
                              bottom: 10.00),
                          child:
                              listdata[0].seller!.sellerDescription!.length >= 200
                                  ? Text(
                                      listdata[0]
                                          .seller!
                                          .sellerDescription!
                                          .substring(0, 200),
                                    )
                                  : Text(
                                      listdata[0].seller!.sellerDescription.toString(),
                                    ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showPersBottomSheetCallBack = _showBottomSheet;
            });
          }
        });
  }

  Widget expendableList() {
    return new ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: listfaq.length,
      itemBuilder: (context, i) {
        final datapass = listdata[i];
        return new custom.ExpansionTile(
          headerBackgroundColor: Colors.white,
          iconColor: isExpanded ? primarycolor : Colors.black,
          title: new Text(
            "Frequently Asked Questions",
            style: new TextStyle(
              color: isExpanded ? primarycolor : Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: <Widget>[
            new Column(
              children: <Widget>[
                new ListTile(
                  title: Text(datapass.faqs![i].question.toString()),
                  subtitle: Text(datapass.faqs![i].answer.toString()),
                )
              ],
            ),
          ],
          onExpansionChanged: (bool expanding) =>
              setState(() => this.isExpanded = expanding),
        );
      },
    );
  }

  Widget reviewexpendableList() {
    
    return listdata[0].reviews!.length == 0
        ? Container()
        : new custom.ExpansionTile(
            headerBackgroundColor: Colors.white,
            iconColor: isExpanded ? primarycolor : Colors.black,
            title: new Text(
              "Reviews",
              style: new TextStyle(
                color: isExpanded ? primarycolor : Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: listdata[0].reviews!.length,
                      itemBuilder: (context, index) {
                        final datapass = listdata[0].reviews![index];

                        return Container(
                          alignment: Alignment(-1.0, -1.0),
                          padding: EdgeInsets.only(
                              left: 10.00,
                              right: 10.00,
                              top: 10.00,
                              bottom: 5.00),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                          width: 40.0,
                                          height: 40.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new NetworkImage(
                                                      datapass.buyerImage!)))),
                                      new Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.3,
                                        padding: EdgeInsets.only(left: 10.00),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        left: 0),
                                                    child: new Text(
                                                      datapass.buyerName.toString(),
                                                      style: TextStyle(),
                                                      textAlign: TextAlign.left,
                                                    )),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.orange,
                                                      size: 16.0,
                                                    ),
                                                    Container(
                                                      child: new Text(
                                                          datapass.buyerRating.toString(),
                                                          style: TextStyle(
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                          textAlign:
                                                              TextAlign.right),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 0),
                                                ),
                                                Container(
                                                  child: new Text(
                                                      datapass.reviewDate.toString(),
                                                      textAlign:
                                                          TextAlign.right),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 25.00),
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: new Text(datapass.buyerReview.toString(),
                                    textAlign: TextAlign.left),
                              ),
                            ],
                          ),
                        );
                      })
                ],
              ),
            ],
            onExpansionChanged: (bool expanding) =>
                setState(() => this.isExpanded = expanding),
          );
  }

  Widget review(context) {
    if (token == null) {
      return SizedBox(height: 3.0);
    } else {
      return Column(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 0.00),
              child: Text('Recently Viewes & more',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'SophiaNubian',
                  )),
            ),
          ]),
          Column(children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 5, top: 5),
              // alignment: FractionalOffset(1.0, 1.0),
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: loading
                  ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primarycolor)))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      primary: false,
                      itemCount: listreviews.length,
                      itemBuilder: (context, i) {
                        final nplacesList = listreviews[i];
                        return GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 5.00, top: 5.00, right: 5.00),
                            width: 250,
                            decoration: myBoxDecorationfirst(),
                            child: Column(children: <Widget>[
                              Container(
                                height: 150,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      //height: 150,
                                      width: double.infinity,
                                      child: Image.network(
                                        nplacesList.postImage!,
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 10.00,
                                    right: 10.00,
                                    top: 10.00,
                                    bottom: 5.00),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        new Container(
                                            width: 50.0,
                                            height: 50.0,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: new NetworkImage(
                                                        nplacesList
                                                            .sellerImage!)))),
                                        new Container(
                                          padding: EdgeInsets.only(left: 5.00),
                                          child:
                                              new Text(nplacesList.sellerName.toString()),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.only(right: 10.00, left: 10.00),
                                child: Column(children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, top: 5),
                                          child: Text(nplacesList.sellerLevel.toString()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    right: 10.00, left: 10.00, top: 10.00),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        new Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Row(children: <Widget>[
                                              Text(
                                                "From ",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: primarycolor,
                                                ),
                                                maxLines: 2,
                                                textAlign: TextAlign.left,
                                              ),
                                              Text(
                                                "${nplacesList.price}",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: primarycolor,
                                                ),
                                                maxLines: 2,
                                                textAlign: TextAlign.left,
                                              ),
                                            ])),
                                      ],
                                    ),
                                    Row(children: <Widget>[
                                      new Container(
                                          child: Row(children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          size: 14,
                                          color: Colors.orangeAccent,
                                        ),
                                        Text(
                                          "${nplacesList.rating!.averageRatting.toString()}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.orangeAccent,
                                          ),
                                          maxLines: 2,
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          "(${nplacesList.rating!.totalReviews.toString()})",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black38,
                                          ),
                                          maxLines: 2,
                                          textAlign: TextAlign.left,
                                        ),
                                      ])),
                                    ]),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                          onTap: () {},
                        );
                      },
                    ),
            )
          ]),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    
    return Scaffold(
      key: _scaffoldKey,
      body: loading
          ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primarycolor)))
          : listdata.length != 0
              ? ListView(
                  children: [
                    Column(
                      children: <Widget>[
                        Container(

                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 1.8,
                          color: Colors.white,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            primary: false,
                            itemCount: listdata.length,
                            itemBuilder: (context, i) {

                              final datapass = listdata[i];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Stack(
                              children: <Widget>[
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 0.0, vertical: 0.0),
                                      color: Colors.white,
                                      height: 200,
                                      child: datapass.images!.length != 1 ? CarouselSlider.builder(

                                        itemCount: datapass.images!.length,
                                        itemBuilder: (context, index, realIndex) {
                                             return Container(
                                              child: Image.network(
                                                datapass.images![index],
                                                fit: BoxFit.cover,
                                                width: 350,
                                                height: 260,
                                              ));
                                        },
                                          options: CarouselOptions(
                                            height: 400,
                                            //aspectRatio: 16/9,
                                            viewportFraction: 0.8,
                                            initialPage: 0,
                                            enableInfiniteScroll: true,
                                            reverse: false,
                                            autoPlay: true,
                                            autoPlayInterval: Duration(seconds: 5),
                                            autoPlayAnimationDuration: Duration(milliseconds: 800),
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            enlargeCenterPage: false,
                                            scrollDirection: Axis.horizontal,
                                          )
                                      ):Container(

                                          child: Image.network(
                                            datapass.images![0],
                                            fit: BoxFit.fill,
                                            width: 350,
                                            height: 260,
                                          )),
                                  ),

                                Container(
                                  decoration: BoxDecoration(
    shape: BoxShape.circle, // BoxShape.circle or BoxShape.retangle
    color: primarycolor,
    boxShadow: [BoxShadow(
      color: wavesecond!,
      blurRadius: 15.0,
    ),]
  ),
                                 // padding: EdgeInsets.only(left: 10),
                                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),

                                  child: widget.sublink == "home" ? IconButton(
                                    icon: Icon(Icons.arrow_back,color: Colors.white,),
                                    onPressed: () {

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context){
                                            return MyHomePage(0);
                                          },
                                        ),
                                      );
                                    },
                                  ) : widget.sublink == "search" ? IconButton(
                                    icon: Icon(Icons.arrow_back,color: Colors.white,),
                                    onPressed: () {

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context){
                                            return MyHomePage(2);
                                          },
                                        ),
                                      );
                                    },
                                  ): IconButton(
                                    icon: Icon(Icons.arrow_back,color: Colors.white,),
                                    onPressed: () {

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context){
                                            return catdetail(widget.sublink,widget.title,widget.pretitle,widget.prelink);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ]
                              ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1,
                                    alignment: Alignment(-1.0, -1.0),
                                    padding: EdgeInsets.only(
                                        left: 10.00,
                                        right: 10.00,
                                        top: 10.00,
                                        bottom: 5.00),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            new Container(
                                                width: 50.0,
                                                height: 50.0,
                                                decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: new DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: new NetworkImage(
                                                            datapass.seller!
                                                                .sellerImage!))),
                                                child: new Stack(
                                                  children: <Widget>[
                                                    if (datapass.seller!
                                                            .onlineStatus ==
                                                        'online')
                                                      new Positioned(
                                                        right: 0.0,
                                                        bottom: 0.0,
                                                        child: new Icon(
                                                          Icons
                                                              .fiber_manual_record,
                                                          size: 15.0,
                                                          color: primarycolor,
                                                        ),
                                                      ),
                                                    if (datapass.seller!
                                                            .onlineStatus ==
                                                        'offline')
                                                      new Positioned(
                                                        right: 0.0,
                                                        bottom: 0.0,
                                                        child: new Icon(
                                                          Icons
                                                              .fiber_manual_record,
                                                          size: 15.0,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                  ],
                                                )),
                                            new Container(
                                              padding:
                                                  EdgeInsets.only(left: 10.00),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          left: 0),
                                                      child: new Text(
                                                        datapass
                                                            .seller!.sellerName.toString(),
                                                        style: TextStyle(),
                                                        textAlign:
                                                            TextAlign.left,
                                                      )),
                                                  Container(
                                                      child: new Text(datapass
                                                          .seller!.sellerLevel.toString())),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.keyboard_arrow_down),
                                          onPressed:
                                              _showPersBottomSheetCallBack,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment(-1.0, -1.0),
                                    padding: EdgeInsets.only(
                                        left: 10.00,
                                        right: 10.00,
                                        top: 10.00,
                                        bottom: 5.00),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            new Container(
                                              padding:
                                                  EdgeInsets.only(left: 10.00),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width/1.5,
                                                      padding: EdgeInsets.only(
                                                          left: 0),
                                                      child: datapass.title!
                                                          .length >=
                                                          30
                                                          ? Text(
                                                        datapass.title!
                                                            .substring(
                                                            0, 30)+"...",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ):Text(
                                                        datapass.title.toString(),
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight.w700,
                                                        ),
                                                        textAlign:
                                                        TextAlign.left,
                                                      )),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width/1.5,
                                                    child: datapass.description!
                                                                .length >=
                                                            62
                                                        ? Text(
                                                            datapass.description!
                                                                .substring(
                                                                    0, 62)+"...",
                                                          )
                                                        : Text(
                                                            datapass
                                                                .description.toString(),
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        DefaultTabController(

                          length: 3,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width / 1.25,
                            child: Column(
                              children: <Widget>[
                                TabBar(

                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.red,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0),
                                      color: Colors.red),
                                  tabs: <Widget>[
                                    Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(listdata[0]
                                  .pPackages![0]
                                  .packageName
                                  .toString()),
                            ),
                          ),
                                    Tab(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(listdata[0]
                                            .pPackages![1]
                                            .packageName
                                            .toString()),
                                      ),
                                    ),
                                    Tab(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(listdata[0]
                                            .pPackages![2]
                                            .packageName
                                            .toString()),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.1,
                                              padding: EdgeInsets.all(5),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    listdata[0]
                                                        .pPackages![0]
                                                        .packageName.toString(),
                                                    textAlign: TextAlign.left,
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.1,
                                              padding: EdgeInsets.all(5),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(listdata[0]
                                                      .pPackages![0]
                                                      .description!.length >48 ? listdata[0]
                                                      .pPackages![0]
                                                      .description!.substring(0,48)+'...': listdata[0]
                                                      .pPackages![0]
                                                      .description!)
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("Revisions"),
                                                  Text(listdata[0]
                                                      .pPackages![0]
                                                      .revisions.toString())
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("Delivery Time"),
                                                  Text(listdata[0]
                                                      .pPackages![0]
                                                      .deliveryTime.toString())
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("price"),
                                                  Text(listdata[0]
                                                      .pPackages![0]
                                                      .price.toString())
                                                ],
                                              ),
                                            ),
                                            token == null
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    margin: EdgeInsets.all(20),
                                                    child: TextButton(
                                                      child: Text('Log In '),
                                                      // color: primarycolor,
                                                      // textColor: Colors.white,
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                Login(
                                                                    "loginfull"),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    margin: EdgeInsets.all(20),
                                                    child: TextButton(
                                                      child: Text(
                                                          'Add To Cart ' +
                                                              listdata[0]
                                                                  .pPackages![1]
                                                                  .price.toString()),
                                                      // color: primarycolor,
                                                      // textColor: Colors.white,
                                                      onPressed: () {
                                                        setState(() {
                                                          addcart(
                                                              listdata[0]
                                                                  .proposalId!,
                                                              listdata[0]
                                                                  .pPackages![0]
                                                                  .packageId!,
                                                              "1");
                                                        });
                                                      },
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.1,
                                              padding: EdgeInsets.all(5),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(listdata[0]
                                                      .pPackages![1]
                                                      .packageName.toString())
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.1,
                                              padding: EdgeInsets.all(5),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(listdata[0]
                                                      .pPackages![1]
                                                      .description!.length >48 ? listdata[0]
                                                      .pPackages![1]
                                                      .description!.substring(0,48)+'...': listdata[0]
                                                      .pPackages![1]
                                                      .description.toString())
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("Revisions"),
                                                  listdata[0]
                                                              .pPackages![1]
                                                              .revisions!
                                                              .length ==
                                                          0
                                                      ? Text("--")
                                                      : Text(listdata[0]
                                                          .pPackages![1]
                                                          .revisions.toString())
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("Delivery Time"),
                                                  Text(listdata[0]
                                                      .pPackages![1]
                                                      .deliveryTime.toString())
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("price"),
                                                  Text(listdata[0]
                                                      .pPackages![1]
                                                      .price.toString())
                                                ],
                                              ),
                                            ),
                                            token == null
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    margin: EdgeInsets.all(20),
                                                    child: TextButton(
                                                      child: Text('Log In '),
                                                      // color: primarycolor,
                                                      // textColor: Colors.white,
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                Login(
                                                                    "loginfull"),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    margin: EdgeInsets.all(20),
                                                    child: TextButton(
                                                      child: Text(
                                                          'Add To Cart ' +
                                                              listdata[0]
                                                                  .pPackages![1]
                                                                  .price.toString()),
                                                      // color: primarycolor,
                                                      // textColor: Colors.white,
                                                      onPressed: () {
                                                        setState(() {
                                                          addcart(
                                                              listdata[0]
                                                                  .proposalId!,
                                                              listdata[0]
                                                                  .pPackages![1]
                                                                  .packageId.toString(),
                                                              "1");
                                                        });
                                                      },
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.1,
                                              padding: EdgeInsets.all(5),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(listdata[0]
                                                      .pPackages![2]
                                                      .packageName.toString())
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.1,
                                              padding: EdgeInsets.all(5),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(listdata[0]
                                                      .pPackages![2]
                                                      .description!.length >48 ? listdata[0]
                                                      .pPackages![2]
                                                      .description!.substring(0,48)+'...': listdata[0]
                                                      .pPackages![2]
                                                      .description.toString())
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("Revisions"),
                                                  Text(listdata[0]
                                                      .pPackages![2]
                                                      .revisions.toString())
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("Delivery Time"),
                                                  Text(listdata[0]
                                                      .pPackages![2]
                                                      .deliveryTime.toString())
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("price"),
                                                  Text(listdata[0]
                                                      .pPackages![2]
                                                      .price.toString())
                                                ],
                                              ),
                                            ),
                                            token == null
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    margin: EdgeInsets.all(20),
                                                    child: TextButton(
                                                      child: Text('Log In '),
                                                      // color: primarycolor,
                                                      // textColor: Colors.white,
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                Login(
                                                                    "loginfull"),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                    margin: EdgeInsets.all(20),
                                                    child: TextButton(
                                                      child: Text(
                                                          'Add To Cart ' +
                                                              listdata[0]
                                                                  .pPackages![2]
                                                                  .price.toString()),
                                                      // color: primarycolor,
                                                      // textColor: Colors.white,
                                                      onPressed: () {
                                                        setState(() {
                                                          addcart(
                                                              listdata[0]
                                                                  .proposalId!,
                                                              listdata[0]
                                                                  .pPackages![2]
                                                                  .packageId!,
                                                              "1");
                                                        });
                                                      },
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    loading
                        ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primarycolor)))
                        : Container(
                            child: expendableList(),
                          ),
                    loading
                        ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primarycolor)))
                        : Container(
                            child: reviewexpendableList(),
                          ),
                    loading
                        ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primarycolor)))
                        : listdata[0].reviews!.length != 0
                            ? SizedBox(
                                height: 20,
                              )
                            : SizedBox(
                                height: 0,
                              ),
                    review(context),
                  ],
                )
              : Center(
                  child: Text(
                  "404 Page Not found",
                  style: TextStyle(fontSize: 20, color: primarycolor),
                )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          listdata[0].seller!.messagegroupid!.length != 0 ?  Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return Inboxdetailpage(listdata[0].seller!.messagegroupid!,
                    listdata[0].seller!.sellerName!);
              },
            ),
          ): listdata[0].seller!.messagegroupid!.length == 0
              ? Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return contactdetailpage(listdata[0].seller!.sellerId!,
                          listdata[0].seller!.sellerName!);
                    },
                  ),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login("loginfull"),
                  ),
                );
        },
        label:  loading
            ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primarycolor)))
            : listdata[0].seller!.sellerImage != 0
            ? Container(
                // color: primarycolor,
                padding: EdgeInsets.all(0.00),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(right: 15),
                        width: 30.0,
                        height: 30.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    listdata[0].seller!.sellerImage!))),
                        child: new Stack(
                          children: <Widget>[
                            if (listdata[0].seller!.onlineStatus == 'online')
                              new Positioned(
                                right: 0.0,
                                bottom: 0.0,
                                child: new Icon(
                                  Icons.fiber_manual_record,
                                  size: 15.0,
                                  color: primarycolor,
                                ),
                              ),
                            if (listdata[0].seller!.onlineStatus == 'offline')
                              new Positioned(
                                right: 0.0,
                                bottom: 0.0,
                                child: new Icon(
                                  Icons.fiber_manual_record,
                                  size: 15.0,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          'Chat',
                          style: TextStyle(
                            color: primarycolor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                  ],
                ))
            : Text("Log in"),
        backgroundColor: Colors.white,
      ),
    );
  }
}
