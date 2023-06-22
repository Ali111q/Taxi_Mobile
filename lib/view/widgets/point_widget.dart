import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jayak/view/location_search.dart';

class PointWidget extends StatelessWidget {
   PointWidget({
    super.key,
    required this.context,
    required this.selected, required this.tag,
  });
  bool selected = false;
  final BuildContext context;
  final String tag;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,

      padding: EdgeInsets.all(10),
   
      child: Container(
           decoration: selected? BoxDecoration(
        border: Border.all(color: Color(0xffFF4100), width: 2),
          borderRadius: BorderRadius.circular(8),

      ): null,
        child: Hero(
          tag: tag,
          child: GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (contetx)=> LocationSearchScreen(tag: tag)));
            },
            child: Material(
              
              elevation: 3,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 25,
                    ),
                    Expanded(
                        flex: 3,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: tag=='start'? 'الانطلاق: ':'الوجهه: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24)),
                                TextSpan(
                                    text: 'حي الجامعه',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18 ,fontWeight: FontWeight.w200)),
                              ]),
                            ))),
                    Container(
                      width: 10,
                    ),
                    SvgPicture.asset(tag=='start'?'assets/svgs/location.svg':'assets/svgs/square_location.svg'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}