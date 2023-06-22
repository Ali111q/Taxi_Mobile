import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jayak/location_service.dart';
import 'package:jayak/pop.dart';
import 'package:jayak/view/widgets/point_widget.dart';
import 'package:jayak/view/widgets/recent_text.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  ///  this icon used as marker icon
  BitmapDescriptor icon = BitmapDescriptor.defaultMarker;

  /// this is current user location
  LatLng? userLocation;

  /// this controller use with [GoogleMap] to full control it
  /// you can set this controller by make it = onCreate[Function] value
  late GoogleMapController _googleMapController;

  /// checking if the user moving the map for animate courser
  bool isMoving = false;
  //set of markers to put location of user
  //this class is built in dart class works like array
  Set<Marker> _markers = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final channel = WebSocketChannel.connect(
        Uri.parse(
            'ws://192.168.0.114:6001/user-socket/osamah?lat=00.000000&lng=00.000000&token=3|MViIwTndJJglkEd1L3Y2vnrGhBL1gotgws8Pc4RA'),
        protocols: []);
    channel.ready.then((value) {
      print('object');
    });
    // Listen for incoming messages.
    channel.stream.listen((message) {
      print(message);
    });
    channel.sink.add('send test');
    print('${channel.closeCode} connection code');

    // Send a message to the server.
    channel.sink.add('Hello, world!');
    _getUserLocation();

    /// set the asset image as marker icon
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
            'assets/images/crosshair.png')
        .then((d) {
      setState(() {
        icon = d;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        ///this google map widget
        ///this widget won't render until you add google map api key in AndroidManifest file
        GoogleMap(
          /// this is required parameter to pass initial position of map
          /// todo: make this parameter = current user location
          initialCameraPosition:
              CameraPosition(target: userLocation ?? LatLng(44, 33), zoom: 5),

          /// disable zoom control buttons
          zoomControlsEnabled: false,

          /// Enable user location courser
          myLocationEnabled: true,

          /// disable go to my location button
          /// in our case I disabled it for creating a custom button with custom ui
          myLocationButtonEnabled: false,

          onCameraIdle: () {
            /// when camera stop moving
            /// set [isMoving] false to animate courser to Idle setuation
            setState(() {
              isMoving = false;
            });
          },
          onCameraMoveStarted: () {
            /// when camera is moving
            /// set [isMoving] true to animate courser to moving setuation
            setState(() {
              isMoving = true;
            });
          },

          /// setting [GoogleMapContoller]
          onMapCreated: (controller) => _googleMapController = controller,

          /// here I used [_markers] Set to declare the markers
          markers: _markers,
        ),

        /// I used this position for pin widgets like app bar position
        Positioned(
            top: 30,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [PopWidget(), HomeWidget()],
              ),
            )),

        /// I used this position for pin widgets Floating widgets at the bottom of screen position
        Positioned(bottom: 0, child: _floatingWidget()),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: isMoving ? 20 : 40,
                  height: isMoving ? 20 : 40,
                  decoration: BoxDecoration(
                      color: isMoving
                          ? Color(0xffFF4100).withOpacity(0.1)
                          : Colors.transparent,
                      shape: BoxShape.circle),
                  child: isMoving
                      ? Center(
                          child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: Color(0xffFF4100),
                                  shape: BoxShape.circle)),
                        )
                      : SvgPicture.asset('assets/svgs/pin.svg')),
              if (!isMoving)
                Container(
                  height: 34,
                )
            ],
          ),
        )
      ]),
    );
  }

  /// this function for changing marker position
  void _changeMarker(LatLng position) async {
    /// this is marker id to create unique id for every marker
    final MarkerId _markerId = MarkerId(position.toString());

    /// marker decleration
    final Marker _marker = Marker(
        markerId: _markerId,

        /// [position] passed as function param
        position: position,

        /// todo: fix marker costum icon error in init state
        // icon: icon,
        infoWindow: InfoWindow(
          /// [title] and [snippet] show when marker been tapped
          title: 'your location',
        ));
    setState(() {
      _markers = {_marker};
    });
  }

  Widget _floatingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: _getUserLocation,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Center(
                  child: Image.asset('assets/images/crosshair.png'),
                ),
              ),
            ),
          ),
        ),
        PointWidget(
          context: context,
          selected: false,
          tag: 'start',
        ),
        PointWidget(
          context: context,
          selected: false,
          tag: 'end',
        ),
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [RecentText()],
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(25, 12, 25, 12),
          child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: BorderSide(color: Colors.red)))),
              onPressed: () {},
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: EdgeInsets.all(15),
                  child: Center(
                      child: Text(
                    'تأكيد نقطة الانطلاق',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  )))),
        )
      ],
    );
  }

  Future<void> _getUserLocation() async {
    final value = await LocationService.determinePosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(
        value.latitude, value.longitude,
        localeIdentifier: 'ar');
    // print(placemarks);
    CameraUpdate _update = CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(value.latitude, value.longitude), zoom: 18));

    setState(() {
      userLocation = LatLng(value.latitude, value.longitude);
      _googleMapController.animateCamera(_update);
    });
  }
}
