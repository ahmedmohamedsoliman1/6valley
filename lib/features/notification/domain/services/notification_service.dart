import 'package:flutter_sixvalley_ecommerce/features/notification/domain/repositories/notification_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/domain/services/notification_service_interface.dart';

class NotificationService implements NotificationServiceInterface{
  NotificationRepositoryInterface notificationRepositoryInterface;

  NotificationService({required this.notificationRepositoryInterface});

  @override
  Future getList({int? offset = 1}) {
    return notificationRepositoryInterface.getList(offset: offset);
  }

  @override
  Future seenNotification(int id) {
    return notificationRepositoryInterface.seenNotification(id);
  }

}