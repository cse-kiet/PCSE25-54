import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkwizflutter/widgets/custom_app_bar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';

Set<Circle> circles = {};

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3800), () {
      if (mounted) {
        setState(() {
          _showMapScreen = true;
        });
      }
    });
  }

  bool _showMapScreen = false;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 254, 251, 251),
        appBar: const CustomAppBar(
          customHeight: 62,
        ),
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: <Widget>[
            _buildHeader(screenHeight),
            _buildBody(screenHeight),
          ],
        ));
  }

  SliverToBoxAdapter _buildHeader(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 90,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '  \nView ',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 22,
                          color: Colors.black, // Customize the color
                        ),
                      ),
                    ),
                    TextSpan(
                      text: 'Parking Area',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontSize: 24,
                          color: Colors.red,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: ' Near You!',
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          fontSize: 22,
                          color: Colors.black, // Customize the color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Your other widgets here
                  if (_showMapScreen)
                    // ignore: prefer_const_constructors
                    MapScreen(),
                  // Other widgets
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildBody(double screenHeight) {
    return SliverToBoxAdapter(
        child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Background color
                      foregroundColor: Colors.black, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30.0), // Adjust the border radius
                        side: const BorderSide(
                            color: Color.fromARGB(255, 4, 49, 117),
                            width: 2.0), // Add border with a different color
                      ),
                      padding: const EdgeInsets.all(
                          16.0), // Padding around the button
                      minimumSize: const Size(double.infinity,
                          60.0), // Full width and increased height
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.search,
                          size: 29.0,
                        ), // Add your desired icon
                        const SizedBox(
                            width:
                                8.0), // Adjust the spacing between icon and text
                        Text(
                          "SEARCH DESTINATION",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18.0, // Adjust the font size
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: <Widget>[
                      Text(
                        'PARK YOUR VEHICLE NOW!',
                        style: GoogleFonts.kanit(
                          textStyle: const TextStyle(
                            color: Color.fromARGB(255, 10, 2, 119),
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 19),
                    ],
                  ),
                  const SizedBox(height: 19),
                  const SizedBox(
                    height: 250, // Set the desired height
                    width: 300, // Set the desired width
                    child: Scaffold(), // Wrap CardScreen in a Container
                  ),
                  const Row(children: <Widget>[]),
                  const Row(
                    children: <Widget>[],
                  )
                ])));
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
    ));
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  // ignore: unused_field
  late Position _userLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Query nearby facilities

      setState(() {
        _userLocation = position;
        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            15.0,
          ),
        );

        markers.add(
          Marker(
            markerId: const MarkerId("User Location"),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: InfoWindow(
              title: "Your Location",
              snippet: "Lat: ${position.latitude}, Lng: ${position.longitude}",
            ),
          ),
        );
      });
    } catch (e) {
      print("Error getting user location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Set the width of your container
      height: 230.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black
              .withOpacity(0.5), // Set the border color with opacity
          width: 2.0, // Set the border width
        ),
      ),
      child: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(0.0, 0.0), // Default to (0.0, 0.0)
          zoom: 7.0,
        ),
        markers: markers,
        circles: circles,
      ),
    );
  }
}
