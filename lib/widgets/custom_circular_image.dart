// import 'dart:io';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
//
//
// import 'customLoader.dart';
//
// enum CustomFileType { asset, network, file }
//
// class CustomCircularImage extends StatelessWidget {
//   final double height;
//   final double width;
//   final double? borderRadius;
//   final String imageUrl;
//   final CustomFileType fileType;
//   final File? image;
//   final BoxFit? fit;
//   final Color? bgColor;
//   final double padding;
//   final BoxBorder? border;
//   const CustomCircularImage(
//       {Key? key,
//         required this.imageUrl,
//         this.image,
//         this.height = 60,
//         this.width = 60,
//         this.padding = 0,
//         this.borderRadius,
//         this.fileType = CustomFileType.asset,
//         this.fit,
//         this.bgColor,
//         this.border})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(padding),
//       clipBehavior: Clip.hardEdge,
//       decoration: BoxDecoration(
//         color: bgColor,
//         border: border,
//         borderRadius: BorderRadius.circular(borderRadius ?? height),
//
//       ),
//       child: Container(
//         height: height,
//         width: width,
//         decoration: BoxDecoration(
//             image: fileType == CustomFileType.asset
//                 ? DecorationImage(
//               image: AssetImage(imageUrl),
//               fit: fit??BoxFit.cover,
//             )
//                 : fileType == CustomFileType.file
//                 ? DecorationImage(image: FileImage(image!),fit: fit??BoxFit.cover,)
//                 :
//             // DecorationImage(
//             //   image: NetworkImage(
//             //     imageUrl
//             //   ),
//             //
//             //   fit: fit??BoxFit.cover,
//             // ),
//             null),
//         child: fileType == CustomFileType.network
//             ? CachedNetworkImage(
//           imageUrl: imageUrl,
//           placeholder: (context, url) => Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: CustomLoader(),
//           ),
//           fit: fit??BoxFit.cover,
//           errorWidget: (context, url, error) => Icon(Icons.error),
//         )
//             : null,
//       ),
//     );
//   }
// }