import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationServiceInterface{

  Future<dynamic> getAddressFromGeocode(LatLng latLng);

  Future<dynamic> searchLocation(String text);

  Future<dynamic> getPlaceDetails(String? placeID);


}