abstract class NotificationServiceInterface{

  Future<dynamic> getList({int? offset = 1});
  Future<dynamic>  seenNotification(int id);

}