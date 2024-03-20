import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isBannerLoaded = false;
  late BannerAd bannerAd;

  @override
  void initState() {
    super.initState();
    inilizeBannerAd();
  }

  void inilizeBannerAd() async {
    bannerAd = BannerAd(
      size: AdSize.banner,
      // adUnitId: 'ca-app-pub-1811829791035081/4314687869', // Ganti dengan ID iklan Anda
      adUnitId: 'ca-app-pub-3940256099942544/9214589741', // Ganti dengan ID iklan Anda
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isBannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
            isBannerLoaded = false;
          
          print('Ad failed to load: $error');
        },
      ),
      request: const AdRequest(),
    );
    bannerAd.load();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
   
    bottomNavigationBar: isBannerLoaded == true ? AdWidget(ad: bannerAd): Container(),
    );
  }

  @override
  void dispose() {
    bannerAd.dispose();
    super.dispose();
  }
}
