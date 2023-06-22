// todo: change this screen to be like new design
// todo: make this screen dynamic with contoller
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key, required this.tag});
  final String tag;
  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  FocusNode _node = FocusNode();
  /// this is [AnimatedList] key you
  /// you can use it to `insert` or `remove` items from [AnimatedList]
  /// there is key to every [Widget] in flutter and may uses for it
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  /// this is [AnimatedList] item count
  int counter = 1;

  /// this is [AnimatedList] items
  List<int> _items = [0];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _node.requestFocus();
    // _node.consumeKeyboardToken();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _node.dispose();
  }
  @override
  Widget build(BuildContext context) {
    /// this [Hero] tag for hero transition
    /// you can use hero transition for navigation only
    return Hero(
      /// tag have to be unique in every screen
      tag: widget.tag,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xffFF4100)),
          // leading: IconButton(onPressed: _addItemToList, icon: Icon(Icons.add), ),
          title: _searchField(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          
        ),

        /// [AnimatedList] for adding or removing animations
        body: AnimatedList(
          initialItemCount: _items.length,
          key: _key,
          itemBuilder: slideIt,
        ),
      ),
    );
  }

  /// [slideIt] is example [Widget] function to show [AnimatedList] example
  ///
  /// todo: change this widget to be search widget and move it to widgets folder
  /// [SizeTransition] is transition widget to change size of added widget
  Widget slideIt(BuildContext context, int index, animation) {
    int item = _items[index];

    return SizeTransition(
      sizeFactor: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(animation),
      child: SizedBox(
        // Actual widget to display
        // height: 128.0,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svgs/star.svg',
                  height: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('المنصور شارع الربيع', style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 18),),
                    Text('بغداد, المنصور, شارع الربيع',style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 10)),
                   
                   Container(height: 10,), Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.6,
                      color: Color(0xffFF4100),
                    )
                  ],
                ),
                SvgPicture.asset('assets/svgs/recent_black.svg')
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// this [Function] use to add items to List view
  /// todo: move this function to the controller
  _addItemToList() {
    for (var i = 0; i < 6; i++) {
        _key.currentState!
        .insertItem(0, duration: const Duration(milliseconds: 200));
    _items = []
      ..add(counter++)
      ..addAll(_items);
    }
  
  }
  Widget _searchField(){
    return Container(
      height: 50,
      child: TextField(
        focusNode: _node,
         cursorWidth: 2,
            cursorRadius: Radius.circular(1),
        cursorHeight: 30,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          prefixIcon: Icon(Icons.search),
          prefixIconColor: Colors.grey,
          hintText: widget.tag == 'start'? 'موقعك؟':'الوجهه؟',
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1)
          )
        ),
      ),
    );
  }
}

/// todo: create remove item function
