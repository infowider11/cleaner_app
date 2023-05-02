// import 'dart:io';
// import 'dart:math';
//
// import 'package:audio_waveforms/audio_waveforms.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
//
//  playOrPlausePlayer(PlayerController controller,) async {
//   print('the player state is ${controller.playerState} ');
//   // if(prepare && controller.playerState == PlayerState.stopped){
//   //  await controller
//   //      .preparePlayer(path!);
//   // }
//   controller.playerState == PlayerState.playing
//       ? await controller.pausePlayer()
//       : await controller.startPlayer(finishMode: FinishMode.loop);
//   // setState(() {});
// }
//
//
// Future<File> urlToFile(Uri Url) async {
// // generate random number.
//  var rng = new Random();
// // get temporary directory of device.
//  Directory tempDir = await getTemporaryDirectory();
// // get temporary path from temporary directory.
//  String tempPath = tempDir.path;
// // create a new file in temporary path with random file name.
//  File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.mp3');
// // call http.get method and pass imageUrl into it to get response.
//  http.Response response = await http.get(Url);
// // write bodyBytes received in response to file.
//  await file.writeAsBytes(response.bodyBytes);
// // now return the file which is created with random name in
// // temporary directory and image bytes from response is written to // that file.
//  return file;
// }