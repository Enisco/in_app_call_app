// import 'package:flutter/material.dart';
// import 'package:in_app_call_app/ongoing%20call%20screens/call_models.dart';
// import 'package:in_app_call_app/widgets/spacers.dart';

// Widget toolbar(BuildContext context) {
//   return Container(
//     alignment: Alignment.bottomCenter,
//     padding: const EdgeInsets.symmetric(vertical: 48),
//     child: Row(
//       children: <Widget>[
//         RawMaterialButton(
//           onPressed: CallsModel.toggleMute,
//           shape: const CircleBorder(),
//           elevation: 2.0,
//           fillColor: CallsModel.muted ? Colors.blueAccent : Colors.white,
//           padding: const EdgeInsets.all(12.0),
//           child: Icon(
//             CallsModel.muted ? Icons.mic_off : Icons.mic,
//             color: CallsModel.muted ? Colors.white : Colors.blueAccent,
//             size: 20.0,
//           ),
//         ),
//         Hspacer(60),
//         RawMaterialButton(
//           onPressed: () => CallsModel.callEnd(context),
//           shape: const CircleBorder(),
//           elevation: 2.0,
//           fillColor: Colors.redAccent,
//           padding: const EdgeInsets.all(15.0),
//           child: const Icon(
//             Icons.call_end,
//             color: Colors.white,
//             size: 35.0,
//           ),
//         ),
//       ],
//     ),
//   );
// }
