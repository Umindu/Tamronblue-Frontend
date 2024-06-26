import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tamronblue_frontend/shimmer/shimmerpalseholder.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          ShimmerPlaceholder(height: 60, width: double.infinity,),
          SizedBox(height: 10),
          ShimmerPlaceholder(height: 20, width: 100,),
          SizedBox(height: 10),
          ShimmerPlaceholder(height: 20, width: double.infinity,),
          SizedBox(height: 10),
          ShimmerPlaceholder(height: 20, width: double.infinity,),
        ],
      ),
    );
  }
}