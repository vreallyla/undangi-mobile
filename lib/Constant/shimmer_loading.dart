import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    Key key,
    this.loading,
    this.child,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  final bool loading;
  final Widget child;
  final Colors baseColor;
  final Colors highlightColor;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Shimmer.fromColors(
            baseColor: baseColor != null ? baseColor : Colors.grey[400],
            highlightColor:
                highlightColor != null ? highlightColor : Colors.grey[300],
            child: child,
          )
        : SizedBox(
           
            child: child,
          );
  }
}
