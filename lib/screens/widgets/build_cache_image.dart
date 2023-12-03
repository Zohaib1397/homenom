import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget generateCachedImage(
    {required String url, required double clip, double? height, BoxFit? fit}) {
  if(height!=null){
    return SizedBox(
      width: double.infinity,
      height: height,
      child: clipRRect(clip, url),
    );
  }else{
    return clipRRect(clip, url);
  }
}

ClipRRect clipRRect(double clip, String url) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(clip),
    child: CachedNetworkImage(
      key: UniqueKey(),
      imageUrl: url,
      // height: height?? 100,
      // fit: fit!,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Padding(
        padding:  EdgeInsets.all(8.0),
        child:  CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.black,
        child: const Icon(Icons.error, color: Colors.red,),
      ),
    ),
  );
}
