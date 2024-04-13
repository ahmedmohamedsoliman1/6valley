import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/location/controllers/location_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/location/widgets/location_search_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SelectLocationScreen extends StatefulWidget {
  final GoogleMapController? googleMapController;
  const SelectLocationScreen({super.key, required this.googleMapController});
  @override
  SelectLocationScreenState createState() => SelectLocationScreenState();
}

class SelectLocationScreenState extends State<SelectLocationScreen> {
  GoogleMapController? _controller;
  final TextEditingController _locationController = TextEditingController();
  CameraPosition? _cameraPosition;

  @override
  void initState() {
    super.initState();
    Provider.of<LocationController>(context, listen: false).setPickData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  void _openSearchDialog(BuildContext context, GoogleMapController? mapController) async {
    showDialog(context: context, builder: (context) => LocationSearchDialogWidget(mapController: mapController));
  }

  @override
  Widget build(BuildContext context) {
    _locationController.text = '${Provider.of<LocationController>(context).address.name ?? ''}, '
        '${Provider.of<LocationController>(context).address.subAdministrativeArea ?? ''}, '
        '${Provider.of<LocationController>(context).address.isoCountryCode ?? ''}';

    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('select_delivery_address', context)),
      body: Consumer<LocationController>(
          builder: (context, locationController, child) => Provider.of<SplashController>(context, listen: false).configModel!.mapApiStatus == 1 ? Stack(clipBehavior: Clip.none, children: [
              GoogleMap(mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(locationController.position.latitude, locationController.position.longitude), zoom: 16),
                zoomControlsEnabled: false,
                compassEnabled: false,
                indoorViewEnabled: true,
                mapToolbarEnabled: true,
                onCameraIdle: () => locationController.updateMapPosition(_cameraPosition, false, null, context),
                onCameraMove: ((position) => _cameraPosition = position),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },),

              locationController.pickAddress != null ?
              InkWell(onTap: () => _openSearchDialog(context, _controller),
                child: Container(width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: 18.0),
                  margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: 23.0),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                  child: Row(children: [
                    Expanded(child: Text(locationController.pickAddress!.name != null ?
                    '${locationController.pickAddress?.name ?? ''} ${locationController.pickAddress?.subAdministrativeArea ?? ''} '
                        '${locationController.pickAddress?.isoCountryCode ?? ''}'
                        : '', maxLines: 1, overflow: TextOverflow.ellipsis)),
                    const Icon(Icons.search, size: 20)]))) : const SizedBox.shrink(),


              Positioned(bottom: 0, right: 0, left: 0,
                child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    InkWell(onTap: () => locationController.getCurrentLocation(context, false, mapController: _controller),
                      child: Container(width: 50, height: 50,
                        margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          color: ColorResources.getChatIcon(context)),
                        child: Icon(Icons.my_location, color: Theme.of(context).primaryColor, size: 35))),


                    SizedBox(width: double.infinity,
                      child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        child: CustomButton(buttonText: getTranslated('select_location', context),
                          onTap: () {
                            if(widget.googleMapController != null) {
                              widget.googleMapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                                locationController.pickPosition.latitude, locationController.pickPosition.longitude), zoom: 16)));
                              locationController.setAddAddressData();
                            }
                            Navigator.of(context).pop();
                          })))])),
              Center(child: Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 50)),
              locationController.loading ?
              Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))) :
              const SizedBox(),
            ],
          ) : const SizedBox(),
        ),
    );
  }
}
