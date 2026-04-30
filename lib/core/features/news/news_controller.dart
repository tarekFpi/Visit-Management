
import 'package:assignment_asl/core/features/network/dio_client.dart';
import 'package:assignment_asl/core/features/news/model/newsResponse.dart';
import 'package:assignment_asl/core/features/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NewsController extends GetxController with StateMixin<List<Article>> {

  final dioClient = DioClient.instance;

  final chemicalList = <Article>[].obs;

  Future<void> showNewsList() async {
    change(null, status: RxStatus.loading());

    try {
      final res = await dioClient.get("/v2/everything?q=tesla&from=2026-03-30&sortBy=publishedAt&apiKey=974029dd0413465db55a7b22052155ab");

      final response = NewsResponse.fromJson(res);

      if (response.articles != null) {
        final list = response.articles!;

        chemicalList.addAll(list);

        if (chemicalList.isEmpty) {
          change(null, status: RxStatus.empty());
        } else {
          change(chemicalList, status: RxStatus.success());
        }

      } else {
        Toast.errorToast("Data Not Found..");
        change(null, status: RxStatus.empty());
      }

    } catch (e) {
      Toast.errorToast(e.toString());
      debugPrint(e.toString());
      change(null, status: RxStatus.error(e.toString()));
    }
  }



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    showNewsList();
  }

}