// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../map/AppConstants.dart';
import '../../map/map_marker_model.dart';

class NearestHospital extends StatefulWidget {
  const NearestHospital({super.key});

  @override
  State<NearestHospital> createState() => _NearestHospitalState();
}

class _NearestHospitalState extends State<NearestHospital>
    with TickerProviderStateMixin {
  final pageController = PageController();
  int selectedIndex = 0;
  var currentLocation = AppConstants.myLocation;
  var meLocation = AppConstants.myLocation;

  late final MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  void _moveToTargetLocation() {
    _animatedMapMove(meLocation, 17);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
          title: const Text(
            'Nearest Bloodpoints',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                minZoom: 5,
                maxZoom: 18,
                zoom: 11,
                center: currentLocation,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/ajit-khadka/clh8usimy00xx01p6b93ub51r/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWppdC1raGFka2EiLCJhIjoiY2xoOHVkajA2MDE1bzNjcDBlOGppOTVvYyJ9.A-STTr4xQ3yt7zS4NsbRAw",
                  additionalOptions: const {
                    'mapStyleId': AppConstants.mapBoxStyleId,
                    'accessToken': AppConstants.mapBoxAccessToken,
                  },
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 50.0,
                      height: 50.0,
                      point: meLocation,
                      builder: (ctx) => Container(
                        child: const Icon(
                          Icons.my_location_rounded,
                          color: Color.fromARGB(255, 68, 68, 130),
                        ),
                      ),
                    )
                  ],
                ),
                MarkerLayer(
                  markers: [
                    for (int i = 0; i < mapMarkers.length; i++)
                      Marker(
                        height: 40,
                        width: 40,
                        point:
                            mapMarkers[i].location ?? AppConstants.myLocation,
                        builder: (_) {
                          //page animation
                          return GestureDetector(
                            onTap: () {
                              pageController.animateToPage(
                                i,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                              selectedIndex = i;
                              //changing location according to page
                              currentLocation = mapMarkers[i].location ??
                                  AppConstants.myLocation;
                              _animatedMapMove(currentLocation, 17);
                              setState(() {});
                            },
                            //unselected makers scale and opacity
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 500),
                              scale: selectedIndex == i ? 1 : 0.7,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: selectedIndex == i ? 1 : 0.5,
                                child: SvgPicture.asset(
                                  'images/map_marker.svg',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
            //my location button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: ElevatedButton(
                onPressed: _moveToTargetLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(245, 243, 241, 1),
                ),
                child: const Icon(LineAwesomeIcons.search_location,
                    color: Color.fromARGB(255, 68, 68, 130)),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 2,
              height: MediaQuery.of(context).size.height * 0.3,
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (value) {
                  selectedIndex = value;
                  currentLocation =
                      mapMarkers[value].location ?? AppConstants.myLocation;
                  _animatedMapMove(currentLocation, 17);
                  setState(() {});
                },
                itemCount: mapMarkers.length,
                itemBuilder: (_, index) {
                  final item = mapMarkers[index];
                  //location pages
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: const Color.fromRGBO(245, 243, 241, 1),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: item.rating,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return const Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title ?? '',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        item.address ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  item.image ?? '',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

//Zoomin animation
  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    // fastOutSlowIn.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
