import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

AppOpenAd? openAd;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  loadAd(); // Call loadAd() once during app initialization
  runApp(MyApp());
}

Future<void> loadAd() async {
  await AppOpenAd.load(
      adUnitId: 'ca-app-pub-1811829791035081/4314687869',
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print('ad is loaded');
          openAd = ad;
          openAd!.show();
        },
        onAdFailedToLoad: (error) {
          print('ad failed to load $error');
        },
      ),
      orientation: AppOpenAd.orientationPortrait);
}

void showAd() {
  if (openAd == null) {
    print('trying to show before loading');
    loadAd();
    return;
  }

  openAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdDismissedFullScreenContent: (ad) {
      print('onAdShowedFullScreenContent');
    },
    onAdFailedToShowFullScreenContent: (ad, error) {
      ad.dispose();
      print('failed to load: $error');
      openAd = null;
      loadAd();
    },
    onAdWillDismissFullScreenContent: (ad) {
      ad.dispose();
      print('dismissed');
      openAd = null;
      loadAd();
    },
  );

  openAd!.show();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ad Example',
      home: Home2(),
    );
  }
}

class Home2 extends StatefulWidget {
  const Home2({Key? key}) : super(key: key);

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home2'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAd();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
