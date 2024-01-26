// import 'package:flutter/material.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'dart:io';
// import 'dart:typed_data';

// class videoStream extends StatefulWidget {

//   videoStream({
//     super.key,
//   });

//   @override
//   State<videoStream> createState() => _videoStreamState();
// }

// class _videoStreamState extends State<videoStream> {
//   String wifiIPAddress = '';
//   VlcPlayerController? _vlcViewController;
//   late Uint8List  _imageData;
//   DatabaseReference database = FirebaseDatabase.instance.ref();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     customVideoFromFile();
//   }

//   void customVideoFromFile() {
//     setState(() {
//       // Create a new VlcPlayerController with the updated URL.
//       _vlcViewController = VlcPlayerController.network(
//         'https://media.w3.org/2010/05/sintel/trailer.mp4',
//         hwAcc: HwAcc.disabled,
//         autoPlay: true,
//         options: VlcPlayerOptions(),
//         onInit: () async {
//           //check data
//           _imageData = await _vlcViewController!.takeSnapshot();
//           //create file
//           File image = File('path/to/your/file.jpg');
//           //write data to the file
//           await image.writeAsBytes(_imageData);
//         },
//         // networkCachingDuration: 0,
//         // fileCaching: 0,
//         // hardwareAcceleration: false,
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           if (_vlcViewController != null)
//             VlcPlayer(
//               placeholder: Text('Video Stream'),
//               controller: _vlcViewController!,
//               aspectRatio: 4 / 3,

//               //placeholder: Text("Hello World"),
//             ),

//           // VlcPlayer(
//           //   controller: _vlcViewController!,
//           //   aspectRatio: 4 / 3,
//           //   placeholder: const Text("Hello World"),
//           // ),
//           const SizedBox(height: 20),
//           // ElevatedButton(
//           //   onPressed: () {},
//           //   child: const Text('Take picture'),
//           // ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'dart:typed_data';

class VideoStream extends StatefulWidget {
  VideoStream({super.key});

  @override
  State<VideoStream> createState() => _VideoStreamState();
}

class _VideoStreamState extends State<VideoStream> {
  VlcPlayerController? _vlcViewController;
  late Uint8List _imageData;
  DatabaseReference database = FirebaseDatabase.instance.ref('Camera');

  @override
  void initState() {
    super.initState();
    fetchStreamUrl();
  }

  void fetchStreamUrl() {
// Listening for changes in the 'IPAddressCamera' field in the Firebase database
    database.child('IPAddressCamera').onValue.listen((event) {
      final String url = event.snapshot.value as String;
      if (url.isNotEmpty) {
// If a valid URL is obtained, use it to set up the VLC player controller
        setupVlcPlayer(url);
      }
    });
  }

  void setupVlcPlayer(String streamUrl) {
    setState(() {
// Dispose the previous controller if there was one
      _vlcViewController?.dispose();
// Create a new VlcPlayerController with the fetched URL from Firebase
      _vlcViewController = VlcPlayerController.network(
        streamUrl,
        hwAcc: HwAcc.disabled,
        autoPlay: true,
        options: VlcPlayerOptions(),
        onInit: () async {
// Check data and take a snapshot
          _imageData = await _vlcViewController!.takeSnapshot();
// Create a file to store the image
          File image = File('path/to/your/file.jpg');
// Write the snapshot data to the file
          await image.writeAsBytes(_imageData);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
// Build method implementation
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          if (_vlcViewController != null)
            VlcPlayer(
              placeholder: const Text('Video Stream'),
              controller: _vlcViewController!,
              aspectRatio: 4 / 3,
            ),
          const SizedBox(height: 20),
        // Add additional UI components if needed
        ],
      ),
    );
  }

  @override
  void dispose() {
  // Dispose the controller when the widget is removed from the widget tree
    _vlcViewController?.dispose();
    super.dispose();
  }
}
