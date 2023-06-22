import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RecentText extends StatelessWidget {
  const RecentText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('شارع فلسطين', style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 18),),
          Container(
            width: 5,
          ),
          SvgPicture.asset('assets/svgs/recent.svg'),
          Container(
            width: 10,
          ),
        ],
      ),
    );
  }
}