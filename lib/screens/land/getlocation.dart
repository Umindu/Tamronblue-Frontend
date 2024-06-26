import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({super.key});

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  //get map controller to access map
  Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  late LatLng _defaultLatLng;
  late LatLng _draggedLatlng;
  // String _draggedAddress = "";

  bool _isMapPointloading = false;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    _defaultLatLng = const LatLng(11, 104);
    _draggedLatlng = _defaultLatLng;
    _cameraPosition = CameraPosition(target: _defaultLatLng, zoom: 17.5);
   
   _gotoUserCurrentPosition();
  }

  @override
  void dispose() {
    _googleMapController = Completer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        actions: [
          _isMapPointloading
              ? IconButton(
                  onPressed: () {
                    Navigator.pop(context, _draggedLatlng);
                  },
                  icon: const Icon(Icons.done))
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      )),
                )
        ],
      ),
      body: Stack(children: [
        _showMap(),
        _showCustomPin(),
        _showDraggedAddress(),
      ]),
    );
  }

  Widget _showDraggedAddress() {
    return SafeArea(
      child: Container(
        padding:
            const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 70),
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: const Center(
            //     child: Text(
            //   _draggedAddress,
            // )
            ),
      ),
    );
  }

  Widget _showMap() {
    return GoogleMap(
      initialCameraPosition: _cameraPosition!,
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onCameraIdle: () {
        // _getAddress(_draggedLatlng);
        setState(() {
          _isMapPointloading = true;
        });
      },
      onCameraMove: (cameraPosition) {
        setState(() {
          _isMapPointloading = false;
        });
        _draggedLatlng = cameraPosition.target;
      },
      onMapCreated: (GoogleMapController controller) {
        if (!_googleMapController.isCompleted) {
          _googleMapController.complete(controller);
        }
      },
    );
  }

  Widget _showCustomPin() {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(bottom: 40),
        width: 150,
        child: const Icon(Icons.location_on,
            size: 50, color: Color.fromARGB(255, 255, 17, 0)),
      ),
    );
  }

  //get address from dragged pin
  // Future _getAddress(LatLng position) async {
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);
  //   Placemark address = placemarks[0];
  //   String addresStr =
  //       "${address.street}, ${address.locality}, ${address.administrativeArea}, ${address.country}";
  //   setState(() {
  //     _draggedAddress = addresStr;
  //   });
  // }

  Future _gotoUserCurrentPosition() async {
    Position currentPosition = await _determineUserCurrentPosition();
    _gotoSpecificPosition(
        LatLng(currentPosition.latitude, currentPosition.longitude));
  }

  Future _gotoSpecificPosition(LatLng position) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 13)));

    // await _getAddress(position);
  }

  Future _determineUserCurrentPosition() async {
    LocationPermission locationPermission;
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      print("user don't enable location permission");
    }

    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        print("user denied location permission");
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      print("user denied permission forever");
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }
}
