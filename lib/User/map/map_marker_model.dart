import 'package:latlong2/latlong.dart';

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

// bloodpoint locations
final mapMarkers = [
  MapMarker(
      image: 'images/hospital_1.jpg',
      title: 'Himal Remit',
      address: 'Kamalpokhari, Kathmandu',
      location: LatLng(27.714699150288016, 85.33809352663313),
      rating: 0),
  MapMarker(
      image: 'images/Himal.jpg',
      title: 'Himal Hospital',
      address: 'Kamalpokhari, Kathmandu',
      location: LatLng(27.71059775955699, 85.32828251430738),
      rating: 0),
  MapMarker(
      image: 'images/KL.jpg',
      title: 'KL Residency',
      address: 'Kamalpokhari, Kathmandu',
      location: LatLng(27.711154520671474, 85.33232926097611),
      rating: 0),
  MapMarker(
      image: 'images/Gahana.jpg',
      title: 'Gahana Pokhari',
      address: 'Gahana Pokhari Marg, Kathmandu',
      location: LatLng(27.716918653687888, 85.33295200462106),
      rating: 0),
  MapMarker(
    image: 'images/Rai.jpg',
    title: 'Rai School',
    address: 'Balmandir compound, Kathmandu',
    location: LatLng(27.71471285387495, 85.33093671414055),
    rating: 0,
  ),
];
