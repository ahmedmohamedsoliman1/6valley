import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/location/domain/models/place_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/location/domain/models/prediction_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/location/domain/services/location_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController with ChangeNotifier {
  final LocationServiceInterface locationServiceInterface;
  LocationController({required this.locationServiceInterface});



  Position _position = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1,
    altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1, );
  Position _pickPosition = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(),
      accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1);
  bool _loading = false;
  bool get loading => _loading;
  bool _isBilling = true;
  bool get isBilling =>_isBilling;
  final TextEditingController _locationController = TextEditingController();

  Position get position => _position;
  Position get pickPosition => _pickPosition;
  Placemark _address = Placemark();
  Placemark? _pickAddress = Placemark();

  Placemark get address => _address;
  Placemark? get pickAddress => _pickAddress;

  TextEditingController get locationController => _locationController;


  bool _buttonDisabled = true;
  bool _changeAddress = true;
  GoogleMapController? _mapController;
  List<PredictionModel> _predictionList = [];
  bool _updateAddAddressData = true;

  bool get buttonDisabled => _buttonDisabled;
  GoogleMapController? get mapController => _mapController;

  void setLocationController(String text) {
    _locationController.text = text;
  }



  void getCurrentLocation(BuildContext context, bool fromAddress, {GoogleMapController? mapController}) async {
    _loading = true;
    notifyListeners();
    Position myPosition;
    try {
      Position newLocalData = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      myPosition = newLocalData;
    }catch(e) {
      myPosition = Position(
        latitude: double.parse('0'),
        longitude: double.parse('0'),
        timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1,
      );
    }
    if(fromAddress) {
      _position = myPosition;
    }else {
      _pickPosition = myPosition;
    }
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(myPosition.latitude, myPosition.longitude), zoom: 17),
      ));
    }
    Placemark myPlaceMark;
    try {
        String address = await getAddressFromGeocode(LatLng(myPosition.latitude, myPosition.longitude), Get.context!);
        myPlaceMark = Placemark(name: address, locality: '', postalCode: '', country: '');

    }catch (e) {
      String address = await getAddressFromGeocode(LatLng(myPosition.latitude, myPosition.longitude),  Get.context!);
      myPlaceMark = Placemark(name: address, locality: '', postalCode: '', country: '');
    }
    fromAddress ? _address = myPlaceMark : _pickAddress = myPlaceMark;
    if(fromAddress) {
      _locationController.text = placeMarkToAddress(_address);
    }
    _loading = false;
    notifyListeners();
  }

  void updateMapPosition(CameraPosition? position, bool fromAddress, String? address, BuildContext context) async {
    if(_updateAddAddressData) {
      _loading = true;
      // notifyListeners();
      try {
        if (fromAddress) {
          _position = Position(
            latitude: position!.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,altitudeAccuracy: 1, headingAccuracy: 1);
        } else {
          _pickPosition = Position(
            latitude: position!.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,altitudeAccuracy: 1, headingAccuracy: 1);
        }
        if (_changeAddress) {
            String? addresss = await getAddressFromGeocode(LatLng(position.target.latitude, position.target.longitude), context);
            fromAddress ? _address = Placemark(name: addresss) : _pickAddress = Placemark(name: addresss);

          if(address != null) {
            _locationController.text = address;
          }else if(fromAddress) {
            _locationController.text = placeMarkToAddress(_address);
          }
        } else {
          _changeAddress = true;
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
      _loading = false;
      notifyListeners();
    }else {
      _updateAddAddressData = true;
    }
  }


  void setLocation(String? placeID, String? address, GoogleMapController? mapController) async {
    _loading = true;
    notifyListeners();
    PlaceDetailsModel detail;
    ApiResponse response = await locationServiceInterface.getPlaceDetails(placeID);
    detail = PlaceDetailsModel.fromJson(response.response!.data);

    _pickPosition = Position(
      longitude: detail.result?.geometry?.location?.lat??0, latitude: detail.result?.geometry?.location?.lng??0,
      timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1,
        speedAccuracy: 1,altitudeAccuracy: 1, headingAccuracy: 1);

    _pickAddress = Placemark(name: address);
    _changeAddress = false;

    if(mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
        detail.result?.geometry?.location?.lat??0, detail.result?.geometry?.location?.lng??0), zoom: 16)));
    }
    _loading = false;
    notifyListeners();
  }

  void disableButton() {
    _buttonDisabled = true;
    notifyListeners();
  }

  void setAddAddressData() {
    _position = _pickPosition;
    _address = _pickAddress!;
    _locationController.text = placeMarkToAddress(_address);
    _updateAddAddressData = false;
    notifyListeners();
  }

  void setPickData() {
    _pickPosition = _position;
    _pickAddress = _address;
    _locationController.text = placeMarkToAddress(_address);
  }

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  Future<String> getAddressFromGeocode(LatLng latLng, BuildContext context) async {
    ApiResponse response = await locationServiceInterface.getAddressFromGeocode(latLng);
    String address = '';
    if(response.response!.statusCode == 200 && response.response!.data['status'] == 'OK') {
      address = response.response!.data['results'][0]['formatted_address'].toString();
    }
    return address;
  }

  Future<List<PredictionModel>> searchLocation(BuildContext context, String text) async {
    if(text.isNotEmpty) {
      ApiResponse response = await locationServiceInterface.searchLocation(text);
      if (response.response!.statusCode == 200 && response.response!.data['status'] == 'OK') {
        _predictionList = [];
        response.response!.data['predictions'].forEach((prediction) => _predictionList.add(PredictionModel.fromJson(prediction)));
      } else {
        ApiChecker.checkApi( response);
      }
    }
    return _predictionList;
  }

  String placeMarkToAddress(Placemark placeMark) {
    return '${placeMark.name ?? ''} ${placeMark.subAdministrativeArea ?? ''} ${placeMark.isoCountryCode ?? ''}';
  }

  void isBillingChanged(bool change) {
    _isBilling = change;
    if (change) {
      change = !_isBilling;
    }
    notifyListeners();
  }


}
