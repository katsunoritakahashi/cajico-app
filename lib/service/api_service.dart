import 'dart:convert';
import 'package:get/get.dart';
import '../model/my_page.dart';
import '../model/pagination_response.dart';
import '../model/point_history.dart';
import '../model/house_works.dart';
import 'package:http/http.dart' as http;
import '../model/notice.dart';
import '../model/family_reward.dart';
import '../model/reward_history.dart';

class ApiService extends GetConnect {
  String? token;
  static const _commonHeaders = {
    'content-type': 'application/json',
  };

  Uri _makeUri(String path, {Map<String, String?>? queryParams}) {
    final apiPath = "/api$path";
    return Uri.https('cajico.herokuapp.com', apiPath, queryParams);
  }

  bool _checkStatusCode(http.Response response) {
    final statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 300) {
      return true;
    } else if (statusCode == 404) {
      throw ApiException('データがありません');
    } else if (statusCode == 401) {
      final body = json.decode(response.body);
      throw ApiException(body['errorMessage'] ?? '認証できませんでした');
    } else if (statusCode == 422) {
      final body = json.decode(response.body);
      throw ApiException(body['errorMessage'] ?? 'エラーが発生しました');
    } else {
      throw ApiException('エラーが発生しました');
    }
  }

  Future<Map<String, String>> makeAuthorizationBearerHeader() async {
    const token = '1|ggekvMjZ7BqOHmhVjbLf9itGvniZw94fXIgRmaJt';
    return {
      'Authorization': "Bearer $token",
    };
  }

  // // SharedPreferencesからトークンを取得
  // _setToken() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   String? localToken = localStorage.getString('token');
  //
  //   // なぜかlocalStorageから取得した値の前後に"が入るので仕方なくここで置換する
  //   if (localToken != null) {
  //     token = localToken.replaceAll('"', '');
  //   }
  // }

  Map<String, dynamic> _decodeResponse<T>(http.Response response) {
    _checkStatusCode(response);
    return json.decode(response.body);
  }

  Future<Map<String, String>> _makeAuthenticatedHeader() async {
    return {}
      ..addAll(_commonHeaders)
      ..addAll(await makeAuthorizationBearerHeader());
  }

  // ログインAPI
  Future<String?> login({required String email, required String password}) async {
    final res = await http.post(
      _makeUri('/login'),
      headers: _commonHeaders,
      body: jsonEncode({'email': email, 'password': password}),
    );
    final String? token = _decodeResponse(res)['data']['accessToken'];
    return token;
  }

  // マイページ取得API
  Future<MyPage> getMyPage() async {
    final res = await http.get(
      _makeUri('/me'),
      headers: await _makeAuthenticatedHeader(),
    );
    final dynamic data = _decodeResponse(res)['data'];
    return MyPage.fromJson(data);
  }

  // 最近の家事取得API
  Future<List<HouseWork>> getRecentHouseWorksList() async {
    final res = await http.get(
      _makeUri('/house-works-recently'),
      headers: await _makeAuthenticatedHeader(),
    );
    final List<dynamic> data = _decodeResponse(res)['data'];
    return data.map((json) => HouseWork.fromJson(json)).toList();
  }

  // カテゴリ毎の家事一覧取得API
  Future<List<HouseWork>> getHouseWorksList({required int houseWorkCategoryId}) async {
    final res = await http.get(
      _makeUri('/house-works',
          queryParams: {'houseWorkCategoryId': houseWorkCategoryId.toString()}),
      headers: await _makeAuthenticatedHeader(),
    );
    final List<dynamic> data = _decodeResponse(res)['data'];
    return data.map((json) => HouseWork.fromJson(json)).toList();
  }

  // 家事登録API
  Future<bool> createHouseWork({
    required int houseWorkCategoryId,
    required String houseWorkName,
    required int point,
  }) async {
    final res = await http.post(
      _makeUri('/house-works'),
      headers: await _makeAuthenticatedHeader(),
      body: jsonEncode(
          {'houseWorkCategoryId': houseWorkCategoryId, 'name': houseWorkName, 'point': point}),
    );
    return _checkStatusCode(res);
  }

  // 家事更新API
  Future<bool> putHouseWork({
    required int houseWorkId,
    required String houseWorkName,
    required int point,
  }) async {
    final res = await http.put(
      _makeUri('/house-works/$houseWorkId'),
      headers: await _makeAuthenticatedHeader(),
      body: jsonEncode({'name': houseWorkName, 'point': point}),
    );
    return _checkStatusCode(res);
  }

  // 家事削除API
  Future<bool> deleteHouseWork({required int houseWorkId}) async {
    final res = await http.delete(
      _makeUri('/house-works/$houseWorkId'),
      headers: await _makeAuthenticatedHeader(),
    );
    return _checkStatusCode(res);
  }

  // 家事完了API
  Future<bool> postCompleteHouseWork({required int houseWorkId}) async {
    final res = await http.post(
      _makeUri('/house-works/$houseWorkId/complete'),
      headers: await _makeAuthenticatedHeader(),
    );
    return _checkStatusCode(res);
  }

  // お知らせ一覧API
  Future<PaginationResponse<List<Notice>>> getNoticesList({int page = 1}) async {
    final res = await http.get(
      _makeUri('/notices', queryParams: {
        'page': page.toString(),
      }),
      headers: await _makeAuthenticatedHeader(),
    );
    final List<dynamic> data = _decodeResponse(res)['data'];
    final dynamic meta = _decodeResponse(res)['meta'];
    return PaginationResponse(
      data: data.map((json) => Notice.fromJson(json)).toList(),
      meta: PaginationMeta.fromJson(meta),
    );
  }

  // お知らせ既読API
  Future<bool> readNotices() async {
    final res = await http.put(
      _makeUri('/notices/read'),
      headers: await _makeAuthenticatedHeader(),
    );
    return _checkStatusCode(res);
  }

  // お知らせ未読数取得API
  Future<int> getNotificationUnreadCount() async {
    final res = await http.get(
      _makeUri('/notice/unread-count'),
      headers: await _makeAuthenticatedHeader(),
    );
    final int count = _decodeResponse(res)['data']['unreadCount'];
    return count;
  }

  // ごほうび一覧API
  Future<List<FamilyReward>> getFamilyRewardList() async {
    final res = await http.get(
      _makeUri('/rewards'),
      headers: await _makeAuthenticatedHeader(),
    );
    final List<dynamic> data = _decodeResponse(res)['data'];
    return data.map((json) => FamilyReward.fromJson(json)).toList();
  }

  // ごほうび履歴API
  Future<List<RewardHistory>> getRewardHistoryList(int rewardId) async {
    final res = await http.get(
      _makeUri('/rewards/$rewardId/history'),
      headers: await _makeAuthenticatedHeader(),
    );
    final List<dynamic> data = _decodeResponse(res)['data'];
    return data.map((json) => RewardHistory.fromJson(json)).toList();
  }

  // ごほうび更新API
  Future<bool> putReward({
    required int rewardId,
    required String rewardName,
    required int point,
    required String memo,
  }) async {
    final res = await http.put(
      _makeUri('/rewards/$rewardId'),
      headers: await _makeAuthenticatedHeader(),
      body: jsonEncode({'name': rewardName, 'point': point, 'note': memo}),
    );
    return _checkStatusCode(res);
  }

  // ごほうびリクエストAPI
  Future<bool> requestReward({required int rewardId}) async {
    final res = await http.put(
      _makeUri('/rewards/$rewardId/request'),
      headers: await _makeAuthenticatedHeader(),
    );
    return _checkStatusCode(res);
  }

  // ねぎらい完了リクエストAPI
  Future<bool> completeReward({required int rewardId, required String body}) async {
    final res = await http.put(
      _makeUri('/rewards/$rewardId/complete'),
      headers: await _makeAuthenticatedHeader(),
      body: jsonEncode({'message': body}),
    );
    return _checkStatusCode(res);
  }

  // 家事履歴一覧API
  Future<List<PointHistory>> getPointHistoryList() async {
    final res = await http.get(
      _makeUri('/point-histories'),
      headers: await _makeAuthenticatedHeader(),
    );
    final List<dynamic> data = _decodeResponse(res)['data'];
    return data.map((json) => PointHistory.fromJson(json)).toList();
  }

  // 個人別家事履歴一覧API
  Future<List<Point>> getUserPointHistoryList({required int userId, int page = 1}) async {
    final res = await http.get(
      _makeUri('/$userId/point-histories', queryParams: {
        'page': page.toString(),
      }),
      headers: await _makeAuthenticatedHeader(),
    );
    final List<dynamic> data = _decodeResponse(res)['data'];
    return data.map((json) => Point.fromJson(json)).toList();
  }

  // 家族全体の家事履歴API
  Future<TotalPointHistory> getTotalPointHistory({int page = 1}) async {
    final res = await http.get(
      _makeUri('/point-histories/total', queryParams: {
        'page': page.toString(),
      }),
      headers: await _makeAuthenticatedHeader(),
    );
    final dynamic data = _decodeResponse(res)['data'];
    return TotalPointHistory.fromJson(data);
  }

  // 家事履歴削除API
  Future<bool> deletePointHistory({required int pointHistoryId}) async {
    final res = await http.delete(
      _makeUri('/point-histories/$pointHistoryId'),
      headers: await _makeAuthenticatedHeader(),
    );
    return _checkStatusCode(res);
  }

  // 問い合わせAPI
  Future<bool> postInquiry({required String title, required String body}) async {
    final res = await http.post(
      _makeUri('/inquiry'),
      headers: await _makeAuthenticatedHeader(),
      body: jsonEncode({'title': title, 'body': body}),
    );
    return _checkStatusCode(res);
  }
}

class ApiException implements Exception {
  String message;

  ApiException(this.message);
}
