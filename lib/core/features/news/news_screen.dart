

import 'package:assignment_asl/core/features/news/news_controller.dart';
import 'package:assignment_asl/core/features/widgets/custom_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {

  final newsController = Get.put(NewsController());


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.withOpacity(0.5),
        centerTitle: true,
        title: Text("News",style: TextStyle(color: Colors.white,)),
      ),
      body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [

              ///Products list view
              Expanded(
                child: newsController.obx((state) =>
                    RefreshIndicator(
                      onRefresh:newsController.showNewsList,
                      child: ListView.builder(
                        itemCount: state!.length,
                        itemBuilder: (context, index) {
                          final item = state[index];
                          return Card(
                            elevation: 0.5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                ///goToDetails(item);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Image.network("${item.urlToImage}",height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.fill,),
                                    SizedBox(
                                      height: 8,
                                    ),

                                    Text(
                                      " ${item.title}",
                                      style: TextStyle(fontSize: 16),
                                    ),

                                    SizedBox(
                                      height: 8,
                                    ),

                                    Text(
                                      "author:${item.author}",
                                      style: TextStyle(fontSize: 14,fontWeight:FontWeight.bold),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),onError: (msg) {
                  return CustomErrorWidget(
                      icon: Icon(
                        msg == "No Internet." ? FluentIcons.wifi_off_24_regular : FluentIcons.error_circle_24_filled,
                        color: Colors.red,
                        size: 40,
                      ),
                      btnLevel: "Retry",
                      message: msg.toString(),
                      onClick: () {
                        newsController.showNewsList();
                      });
                }),
              ),


            ],
          )
      ),
    );
  }
}