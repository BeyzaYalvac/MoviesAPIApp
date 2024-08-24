import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<String> imgList = [
    'https://prod-ripcut-delivery.disney-plus.net/v1/variant/disney/DDD02B809D3240532CA4CA1D8428986EBA7ABFFA703FFD61CE49C743D34FFD12/scale?width=506&amp;aspectRatio=2.00&amp;format=webp', // Bu URL'leri kendi resimlerinizle değiştirin
    'https://i.ytimg.com/vi/DvblKVHLU2A/maxresdefault.jpg?sqp=-oaymwEmCIAKENAF8quKqQMa8AEB-AH-CYAC0AWKAgwIABABGBwgXShyMA8=&rs=AOn4CLDTxoMcgOFqJk0oqsfMnHjkVxANJg',
    'https://www.hdwallpapers.in/download/joy_sadness_anger_fear_and_disgust_hd_inside_out_2-1600x900.jpg',
    'https://images7.alphacoders.com/131/1314905.jpeg',
    'https://movies.sterkinekor.co.za/CDN/media/entity/get/FilmTitleGraphic/HO00003111?referenceScheme=HeadOffice&allowPlaceHolder=true&usqp=CAU'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        body: Container(
            child: CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 1.5, //hız
        autoPlay: true,
        viewportFraction: 1.03,
        animateToClosest: true,
        height: MediaQuery.of(context).size.height * 0.35,
      ),
      items: imgList.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery.of(context).size.width * 2,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(color: Colors.black),
                child: Image.network(
                  item,
                  fit: BoxFit.cover,
                ));
          },
        );
      }).toList(),
    )));
  }
}
