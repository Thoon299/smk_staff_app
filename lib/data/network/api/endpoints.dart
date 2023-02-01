
class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://farmernet.org/api/v1/";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout[kwf]
  static const int connectionTimeout = 30000;

  //auth driver
  // static const String driverLogin = baseUrl + "driver/login";

  // auth admin
  static const String login = baseUrl + "login";

  // auth check
  static const String authcheck = baseUrl + "auth/check";

  //gap
  static const String gap = baseUrl+"gap";
  static const String gapPostForm4 = baseUrl+"gap-form4/post";

  static const String gapGetForm4 = baseUrl+"gap-form4";

  //form 3 edit
  static const String gapGetForm3Edit = baseUrl+"gap/edit/";



}



