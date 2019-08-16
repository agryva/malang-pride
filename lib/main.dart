import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:malang_pride/curtomicon.dart';
import 'package:malang_pride/detail.dart';
import 'package:malang_pride/model/budayadata.dart';
import 'package:malang_pride/model/datahome.dart';
import 'package:malang_pride/model/info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model/kulinerdata.dart';
import 'package:malang_pride/model/kulinerdata.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.transparent,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;
bool isOpen = false;

class _MyHomePageState extends State < MyHomePage > {

  var currentPage = dataHomeList.kulinerItems.length - 1.0;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    Future.delayed(Duration.zero, () {
      final _random = new Random();
      var randomNumber = 0 + _random.nextInt(3 - 0);
      showDialog(
        context: context, builder: (_) => AssetGiffyDialog(
          image: Image.asset(
            'assets/info-banner.png',
            fit: BoxFit.cover,
          ),
          title: Text('Informasi',
            style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.w700),
          ),
          description: Text(dataSlogan[randomNumber],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14
            ),
          ),
          onOkButtonPressed: () {
            Navigator.of(context).pop();
          },
          onlyOkButton: true,
          buttonOkColor: Color(0xFF05294A),
          cornerRadius: 50,
        ));
    });

  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }


  void _launchURL(String query) async {
    var url = "https://www.google.com/search?q=" + query;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {

    PageController controller = PageController(initialPage: dataHomeList.kulinerItems.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });


    return Scaffold(
      backgroundColor: Color(0xFF05294A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: < Widget > [
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: < Widget > [
                      IconButton(
                        icon: Icon(
                          MdiIcons.informationVariant,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          _onButtonPressed(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          MdiIcons.mapbox,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          _onButtonPressedMalang(context);
                        },
                      ),
                    ],
                  ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: < Widget > [
                    Text(
                      "Malang Pride",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontFamily: "Calibre-Semibold",
                        letterSpacing: 1
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: < Widget > [
                    iconBadge("Malang", 0xFFff6969, 20.0),
                    iconBadge("Pride", 0xFF8569ff, 5.0),
                    iconBadge("Hiburan", 0xFFf79b54, 5.0),
                    iconBadge("Pengetahuan", 0xFF0fab29, 5.0),
                  ],
                ),
              ),
              Stack(
                children: < Widget > [

                  CardScrollWidget(currentPage),

                  Positioned.fill(
                    child: PageView.builder(
                      itemCount: dataHomeList.kulinerItems.length,
                      controller: controller,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(kulinerData: dataHomeList.kulinerItems[index])));
                            },
                          )
                        );
                      },
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: < Widget > [
                    Text(
                      "Kuliner",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontFamily: "Calibre-Semibold",
                        letterSpacing: 1
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        CustomIcon.option,
                        color: Colors.white,
                        size: 10,
                      ),
                      onPressed: () {
                        _launchURL("Kuliner Khas Kota Malang");
                      },
                    )
                  ],
                ),
              ),

              for (var i = 0; i < kulinerList.kulinerItems.length; i++)
                ItemKulinerWidget(kulinerData: kulinerList.kulinerItems[i]),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: < Widget > [
                      Text(
                        "Kebudayaan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontFamily: "Calibre-Semibold",
                          letterSpacing: 1
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          CustomIcon.option,
                          color: Colors.white,
                          size: 10,
                        ),
                        onPressed: () {
                          _launchURL("Kebudayaan Kota Malang");
                        },
                      )
                    ],
                  ),
                ),

                for (var j = 0; j < kebudayaanList.kulinerItems.length; j++)
                  ItemKebudayaanWidget(kebudayaanData: kebudayaanList.kulinerItems[j]),

            ],
          ),
        ),
      ),
    );
  }

  Widget iconBadge(title, color, padding) {
    return Container(
      margin: EdgeInsets.only(left: padding),
      decoration: BoxDecoration(
        color: Color(color),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 6),
          child: Text(title,
            style: TextStyle(
              color: Colors.white
            )),
        ),
      ),
    );
  }
}

class ItemKulinerWidget extends StatelessWidget {

  final ItemKulinerData kulinerData;

  ItemKulinerWidget({
    @required this.kulinerData
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(kulinerData: kulinerData)));
      },
      child: Column(
        children: < Widget > [
          Container(
            padding: EdgeInsets.only(left: 45, right: 0),
            child: Column(children: < Widget > [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: kulinerData.urlImage,
                    placeholder: (context, url) => new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    fit: BoxFit.fill
                  ),
                ),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.only(left: 0, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: < Widget > [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: < Widget > [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            kulinerData.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.white
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: < Widget > [
                              Icon(
                                MdiIcons.mapMarker,
                                color: Colors.white,
                                size: 18,
                              ),
                              Expanded(
                                child: Text(
                                  kulinerData.address,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "SF-Pro-Text-Regular",
                                    fontSize: 15,
                                    color: Colors.white
                                  ),
                                ),
                              )
                            ],
                          )
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
            ], )
          )
        ]
      )
    );
  }
}

class ItemKebudayaanWidget extends StatelessWidget {

  final ItemKulinerData kebudayaanData;

  ItemKebudayaanWidget({
    @required this.kebudayaanData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(kulinerData: kebudayaanData)));
      },
      child: Column(
        children: < Widget > [
          Container(
            padding: EdgeInsets.only(left: 45, right: 0),
            child: Column(children: < Widget > [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: kebudayaanData.urlImage,
                    placeholder: (context, url) => new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    fit: BoxFit.fill
                  )
                ),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.only(left: 0, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: < Widget > [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: < Widget > [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            kebudayaanData.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.white
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: < Widget > [
                              Icon(
                                MdiIcons.mapMarker,
                                color: Colors.white,
                                size: 18,
                              ),
                              Expanded(
                                child: Text(
                                  "Budaya dan Kesenian Kota Malang",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "SF-Pro-Text-Regular",
                                    fontSize: 15,
                                    color: Colors.white
                                  ),
                                ),
                              )
                            ],
                          )
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
            ], )
          )
        ]
      )
    );
  }
}


class CardScrollWidget extends StatelessWidget {

  var currentPage;
  var padding = 15.0;

  CardScrollWidget(this.currentPage);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(
        builder: (context, contraints) {
          var width = contraints.maxWidth;
          var height = contraints.maxHeight;

          var safeWidth = width - 2 * padding;
          var safeHeight = height - 2 * padding;

          var heightOfPrimaryCard = safeHeight;
          var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

          var primaryCardLeft = safeWidth - widthOfPrimaryCard;
          var horizontalInset = primaryCardLeft / 2;

          List < Widget > cardList = new List();

          for (var i = 0; i < dataHomeList.kulinerItems.length; i++) {
            var delta = i - currentPage;
            bool isOnRight = delta > 0;

            var start = padding + max(
              primaryCardLeft - horizontalInset * -delta * (isOnRight ? 40 : 1),
              0.0
            );

            var cardItem = Positioned.directional(
              top: padding + 30.0 * max(-delta, 0.0),
              bottom: padding + 25.0 * max(-delta, 0),
              start: start,
              textDirection: TextDirection.rtl,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF092e4f),
                      blurRadius: 10.0, // has the effect of softening the shadow
                      spreadRadius: 1, // has the effect of extending the shadow
                    )
                  ]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    child: AspectRatio(
                      aspectRatio: cardAspectRatio,
                      child: Stack(
                        fit: StackFit.expand,
                        children: < Widget > [
                          Image.asset(dataHomeList.kulinerItems[i].urlImage,
                            fit: BoxFit.cover),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: < Widget > [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                  child: Text(dataHomeList.kulinerItems[i].title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontFamily: "SF-Pro-Text-Regular"
                                    )),
                                ),
                                SizedBox(height: 10, ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12, bottom: 12),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Text("Lihat Detail",
                                        style: TextStyle(color: Colors.white), )

                                    ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )

            );
            cardList.add(cardItem);
          }
          return Stack(
            children: cardList,
          );
        },
      ),
    );
  }
}
void _onButtonPressedMalang(context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        color: Colors.transparent,
        height: 350,
        child: Container(
          child: _buildBottomNavigationMenuMalang(),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
            ),
          ),
        )
      );
    }
  );
}



void _onButtonPressed(context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        color: Colors.transparent,
        height: 280,
        child: Container(
          child: _buildBottomNavigationMenu(),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
            ),
          ),
        )
      );
    }
  );
}

Column _buildBottomNavigationMenu() {
  return Column(
    children: < Widget > [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: < Widget > [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Image.asset(
              'assets/icon/icon.png',
              fit: BoxFit.fill,
              width: 100,
              height: 100,
            ),
          )
        ],
      ),
      Text(
        "Malang Pride",
        style: TextStyle(
          color: Color(0xFF05294A),
          fontSize: 30,
          fontFamily: "Calibre-Semibold",
          letterSpacing: 0
        ),
      ),

      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8),
          child: Text(
            "Malang Pride dibuat untuk memperkenalkan keindahan dan kebudayaan kota malang yang indah",
            style: TextStyle(
              fontSize: 17,
              letterSpacing: 0
            ),
            textAlign: TextAlign.center,
          ),
      ),



      Text(
        "Version 1.0",
        style: TextStyle(
          color: Color(0xFF05294A),
          fontSize: 10,
          letterSpacing: 1
        ),
      ),
    ],
  );
}

Column _buildBottomNavigationMenuMalang() {
  return Column(
    children: < Widget > [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: < Widget > [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Image.asset(
              'assets/malang.png',
              fit: BoxFit.fill,
              width: 100,
              height: 100,
            ),
          )
        ],
      ),
      Text(
        "Kota Malang",
        style: TextStyle(
          color: Color(0xFF05294A),
          fontSize: 30,
          fontFamily: "Calibre-Semibold",
          letterSpacing: 0
        ),
      ),

      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8),
          child: Text(
            "Kota Malang adalah sebuah kota yang terletak di Provinsi Jawa Timur, Indonesia, kota terbesar kedua di Jawa Timur setelah Surabaya, dan kota terbesar ke-12 di Indonesia. Kota ini didirikan pada masa Kerajaan Kanjuruhan dan terletak di dataran tinggi seluas 145,28 km² yang terletak di tengah-tengah Kabupaten Malang.",
            style: TextStyle(
              fontSize: 17,
              letterSpacing: 0
            ),
            textAlign: TextAlign.center,
          ),
      ),



      Text(
        "© Wikipedia",
        style: TextStyle(
          color: Color(0xFF05294A),
          fontSize: 10,
          letterSpacing: 1
        ),
      ),
    ],
  );
}