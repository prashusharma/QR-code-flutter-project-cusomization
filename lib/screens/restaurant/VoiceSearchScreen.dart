import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_menu_laravel_flutter/main.dart';
import 'package:qr_menu_laravel_flutter/utils/colors.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceSearchScreen extends StatefulWidget {
  const VoiceSearchScreen({Key? key}) : super(key: key);

  @override
  State<VoiceSearchScreen> createState() => _VoiceSearchScreenState();
}

class _VoiceSearchScreenState extends State<VoiceSearchScreen> {
  SpeechToText speech = SpeechToText();
  bool isListening = false;

  String text = language.lblListening;
  bool showButton = false;

  Future<void> listen() async {
    if (!isListening) {
      bool available = await speech.initialize();

      if (available) {
        showButton = false;
        isListening = true;
        setState(() {});

        speech.listen(onResult: (val) {
          text = val.recognizedWords;
          isListening = false;
          setState(() {});
        });

        await 5.seconds.delay;

        if (text == language.lblListening) {
          showButton = true;
          setState(() {});
        } else {
          finish(context, text);
        }
      }
    } else {
      isListening = false;
      setState(() {});
      speech.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    listen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: boldTextStyle(size: 24)).visible(!showButton),
          Image.asset(
            'images/microphone.png',
            height: 50,
            width: 50,
            color: primaryColor,
          ).onTap(() {
            isListening = false;
            setState(() {});
            listen();
          }).visible(showButton),
          30.height.visible(showButton),
          Image.asset(
            'images/gifs/animation.gif',
            height: 150,
            width: 150,
          ).visible(!showButton),
          Text(
            language.lblTapToSpeak,
            style: boldTextStyle(size: 20),
            textAlign: TextAlign.center,
          ).paddingSymmetric(horizontal: 40).visible(showButton)
        ],
      ).center(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Text(language.lblSearchYourRestaurant, style: primaryTextStyle(color: bodyColor), textAlign: TextAlign.center),
      ),
    );
  }
}
