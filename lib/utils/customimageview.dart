import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomImageView extends StatelessWidget {
  final String? url;
  final double? height, width;
  final double? radius;
  CustomImageView({this.url, this.height, this.width, this.radius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius != null
          ? BorderRadius.all(Radius.circular(radius!))
          : BorderRadius.all(Radius.circular(8)),
      child: CachedNetworkImage(
        imageUrl: url!,
        placeholder: (context, url) => Container(
          child: Center(child: CircularProgressIndicator()),
          width: 50,
          height: 50,
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        height: height,
        width: width,
        fit: BoxFit.cover,
      ),
    );
  }
}
