import 'package:bottom_navigation/model/auditDetailModel.dart';
import 'package:http/http.dart' as http;
import 'package:get/state_manager.dart';
import '../user.dart';

class WeeklyAuditController extends GetxController {
  static var _client = http.Client();
  var isLoading = true.obs;
  RxList<AuditDetailModel> dataList = <AuditDetailModel>[].obs;

  Future fetchData() async {
    isLoading(true);
    try {
      var response = await _fetchResponse();

      if (response != null) {
        dataList.assignAll(response);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<List<AuditDetailModel>> _fetchResponse() async {
    var _urlExtension = "getData.php";
    var response = await _client.get(urlAPI + _urlExtension);

    if (response.statusCode == 200) {
      var jsonString = response.body;

      print(jsonString);

      return auditDetailModelFromJson(jsonString);
    } else {
      print('error message');
      return null;
    }
  }
}
