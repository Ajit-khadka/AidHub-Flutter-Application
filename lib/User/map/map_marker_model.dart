import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';

import 'AppConstants.dart';

class MapMarker {
  final String? image;
  final String? title;
  final String? address;
  final LatLng? location;
  final int? rating;

  MapMarker({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
    required this.rating,
  });
}

final mapMarkers = [
  MapMarker(
      image: 'images/hospital_1.jpg',
      title: 'Medical Hospital',
      address: 'Gokarna, Kathmandu',
      location: LatLng(51.5382123, -0.1882464),
      rating: 4),
  MapMarker(
      image: 'images/hospital_1.jpg',
      title: 'Medical Hospital',
      address: 'Gokarna, Kathmandu',
      location: LatLng(51.5090229, -0.2886548),
      rating: 5),
  MapMarker(
      image: 'images/hospital_1.jpg',
      title: 'Medical Hospital',
      address: 'Gokarna, Kathmandu',
      location: LatLng(51.5090215, -0.1959988),
      rating: 2),
  MapMarker(
      image: 'images/hospital_1.jpg',
      title: 'Medical Hospital',
      address: 'Gokarna, Kathmandu',
      location: LatLng(51.5054563, -0.0798412),
      rating: 3),
  MapMarker(
    image: 'images/hospital_1.jpg',
    title: 'Medical Hospital',
    address: 'Gokarna, Kathmandu',
    location: LatLng(51.5077676, -0.2208447),
    rating: 4,
  ),
];
