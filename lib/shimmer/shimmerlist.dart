import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tamronblue_frontend/shimmer/shimmerpalseholder.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.only(left: 20, right: 20 ),
    child: Row(
      children: [
        ShimmerPlaceholder(height: 80, width: 80,),
        SizedBox(width: 10,),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerPlaceholder(height: 20, width: 100,),
            SizedBox(height: 10),
            ShimmerPlaceholder(height: 20, width: double.infinity,),
            SizedBox(height: 10),
            ShimmerPlaceholder(height: 20, width: double.infinity,),
          ],
        ),),
      ],
    )
   );
  }
}