import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'dart:convert' show utf8;
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '../providers/record_attendance.dart';

class NFC extends StatelessWidget {
  static const routeName = '/nfc';
  bool isNfcAvailable = false;

  Future<void> pageMain() async {
    WidgetsFlutterBinding.ensureInitialized(); // Required for the line below
    isNfcAvailable = await NfcManager.instance.isAvailable();
    print('first ${isNfcAvailable}');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: pageMain(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('progress indicator');
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            print('second ${isNfcAvailable}');
            return WillPopScope(
                onWillPop: () async {
                  //print('session stoped');
                  if (isNfcAvailable == true) {
                    NfcManager.instance.stopSession();
                  }

                  return true;
                },
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('NFC'),
                  ),
                  body: isNfcAvailable
                      ? ChangeNotifierProvider.value(
                          value: RecordAttendance(), child: const NfcTest())
                      : Center(
                          child: Container(
                              padding: const EdgeInsets.all(25),
                              height: 200,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: const FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "*You don't have NFC available on your phone.*",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 20),
                                ),
                              )),
                        ),
                ));
          }
        });
  }
}

class NfcTest extends StatelessWidget {
  const NfcTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool tagValid = false;
    NfcManager.instance.startSession(onDiscovered: (tag) async {
      //  Ndef? ndef = Ndef.from(tag);

      try {
        Uint8List identifier =
            Uint8List.fromList(tag.data['mifareclassic']['identifier']);
        final String serialNo = identifier
            .map((e) => e.toRadixString(16).padLeft(2, '0'))
            .join(':');

        /* if (ndef?.cachedMessage != null) {
          var ndefMessage = ndef?.cachedMessage!;
          //ndefMessage.records is a list
          print(ndefMessage!.records);
          if (ndefMessage.records.isNotEmpty &&
              ndefMessage.records.first.typeNameFormat ==
                  NdefTypeNameFormat.nfcWellknown) {
            final wellKnownRecord = ndefMessage.records.first;
            print(wellKnownRecord);

            final languageCodeAndContentBytes =
                wellKnownRecord.payload.skip(1).toList();
            print(languageCodeAndContentBytes);

            final languageCodeAndContentText =
                utf8.decode(languageCodeAndContentBytes);
            // ignore: avoid_print
            print(languageCodeAndContentText);
            final payload = languageCodeAndContentText.substring(11);

            final storedCounters = int.tryParse(payload);


            */
        final payload = serialNo.substring(3);
        print(payload);
        tagValid = true;

        final Map<String, dynamic> loadedData =
            await Provider.of<RecordAttendance>(context, listen: false)
                .recordAttendance(payload);

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 3),
            backgroundColor: const Color.fromRGBO(55, 157, 0, 100),
            content: loadedData['EMP_ID'] != 0 &&
                    loadedData['NAME'] != null &&
                    loadedData['Time'] != null
                ? Column(
                    children: [
                      Text(
                        '${loadedData['NAME']! + ' ' + loadedData['Time']!} ',
                        style: const TextStyle(fontSize: 15),
                      ),
                      Text(loadedData['Message']!,
                          style: const TextStyle(fontSize: 15))
                    ],
                  )
                : Text(loadedData['Message']!,
                    style: const TextStyle(fontSize: 15))));
        //  }
        //  }
      } catch (error) {
        String msg = error.toString();
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Opps something went wrong'),
                  content: Text(tagValid == true ? msg : 'Tag isn\'t valid'),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Okay'))
                  ],
                ));
      }
    });
    return Center(
        child: Image.asset(fit: BoxFit.cover, 'assets/images/nfc.jpg'));
  }
}
