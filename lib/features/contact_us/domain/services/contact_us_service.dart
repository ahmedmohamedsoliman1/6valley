import 'package:flutter_sixvalley_ecommerce/features/contact_us/domain/models/contact_us_body.dart';
import 'package:flutter_sixvalley_ecommerce/features/contact_us/domain/repository/contact_us_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/contact_us/domain/services/contact_us_service_interface.dart';

class ContactUsService implements ContactUsServiceInterface{
  ContactUsRepositoryInterface contactUsRepositoryInterface;

  ContactUsService({required this.contactUsRepositoryInterface});

  @override
  Future add(ContactUsBody contactUsBody) async{
    return await contactUsRepositoryInterface.add(contactUsBody);
  }

}