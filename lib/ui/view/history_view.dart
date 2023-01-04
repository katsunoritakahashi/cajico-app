import 'package:cached_network_image/cached_network_image.dart';
import 'package:cajico_app/ui/common/app_color.dart';
import 'package:cajico_app/ui/widget/footer.dart';
import 'package:cajico_app/ui/widget/home_drawer.dart';
import 'package:cajico_app/ui/widget/house_work_history_delete_dialog.dart';
import 'package:cajico_app/ui/widget/normal_completed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../model/point_history.dart';
import '../common/ui_helper.dart';
import '../controller/history_view_controller.dart';
import 'package:intl/intl.dart';
import '../widget/loading_stack.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.put(HistoryViewController());
      final totalPointHistory = controller.totalPointHistory();
      final int totalCurrentPage = controller.totalCurrentPage();

      return DefaultTabController(
        initialIndex: 0,
        length: controller.pointHistories().length + 1,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black54),
            centerTitle: true,
            title: Row(children: const [
              Image(
                image: AssetImage(
                  'assets/images/logo_history.png',
                ),
                height: 55,
              ),
              Text('家事履歴', style: TextStyle(color: gray2)),
            ]),
            backgroundColor: Colors.white,
            titleTextStyle: const TextStyle(fontSize: 22),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  isScrollable: true,
                  labelColor: primaryColor,
                  unselectedLabelColor: gray4,
                  indicatorColor: primaryColor,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontSize: 16),
                  tabs: <Widget>[
                    const Tab(text: '全て'),
                    for (var pointHistory in controller.pointHistories()) ...{
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: pointHistory.iconUrl,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(color: primaryColor),
                              ),
                              imageBuilder: (context, imageProvider) {
                                return CircleAvatar(
                                  radius: 15,
                                  backgroundImage: imageProvider,
                                );
                              },
                            ),
                            horizontalSpaceSmall,
                            Text(pointHistory.userName)
                          ],
                        ),
                      )
                    },
                  ],
                ),
              ),
            ),
          ),
          drawer: const HomeDrawer(),
          body: GetLoadingStack<HistoryViewController>(
            child: TabBarView(
              children: [
                RefreshIndicator(
                  color: primaryColor,
                  onRefresh: controller.fetchData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: totalPointHistory != null
                        ? Column(
                            children: [
                              _PointSummaries(
                                  todayPoint: totalPointHistory.todayPoint,
                                  totalPoint: totalPointHistory.totalPoint),
                              GroupedListView<Point, String>(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                elements: controller.totalPointHistories(),
                                groupBy: (element) => element.date,
                                sort: false,
                                itemBuilder: (context, element) {
                                  return _HouseWorkDetail(
                                    pointHistoryId: element.pointHistoryId,
                                    categoryImageUrl: element.houseWorkCategoryImageUrl,
                                    categoryName: element.houseWorkCategoryName,
                                    houseWorkName: element.houseWorkName,
                                    userIconImageUrl: element.iconUrl,
                                    time: element.time,
                                    point: element.point,
                                    isMe: element.isMe,
                                  );
                                },
                                groupSeparatorBuilder: (date) {
                                  return Container(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      child: Text(date, style: const TextStyle(color: gray3)));
                                },
                              ),
                              totalCurrentPage < totalPointHistory.lastPage
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: gray4,
                                          shape: const StadiumBorder(),
                                          side: const BorderSide(color: gray4),
                                          elevation: 0,
                                        ),
                                        onPressed: () =>
                                            controller.onTapNextTotalPage(page: totalCurrentPage),
                                        child: const Text(
                                          '次の10件を表示',
                                          style: TextStyle(fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          )
                        : const SizedBox(),
                  ),
                ),
                for (var item in controller.pointHistories()) ...{
                  RefreshIndicator(
                    color: primaryColor,
                    onRefresh: controller.fetchData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          _PointSummaries(
                              todayPoint: item.todayPoint,
                              totalPoint: item.totalPoint),
                          GroupedListView<Point, String>(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            elements: item.points,
                            groupBy: (element) => element.date,
                            sort: false,
                            itemBuilder: (context, element) {
                              return _HouseWorkDetail(
                                pointHistoryId: element.pointHistoryId,
                                categoryImageUrl: element.houseWorkCategoryImageUrl,
                                categoryName: element.houseWorkCategoryName,
                                houseWorkName: element.houseWorkName,
                                userIconImageUrl: element.iconUrl,
                                time: element.time,
                                point: element.point,
                                isMe: element.isMe,
                              );
                            },
                            groupSeparatorBuilder: (date) {
                              return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  child: Text(date, style: const TextStyle(color: gray3)));
                            },
                          ),
                          item.currentPage < item.lastPage
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: gray4,
                                      shape: const StadiumBorder(),
                                      side: const BorderSide(color: gray4),
                                      elevation: 0,
                                    ),
                                    onPressed: () => controller.onTapNextPage(
                                        userId: item.userId,
                                        page: item.currentPage),
                                    child: const Text(
                                      '次の10件を表示',
                                      style: TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                }
              ],
            ),
          ),
          bottomNavigationBar: const Footer(),
        ),
      );
    });
  }
}

class _PointSummaries extends StatelessWidget {
  const _PointSummaries({required this.todayPoint, required this.totalPoint});

  final int todayPoint;
  final int totalPoint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _PointSummary(title: "今日", point: todayPoint),
          _PointSummary(title: "累計", point: totalPoint),
        ],
      ),
    );
  }
}

class _PointSummary extends StatelessWidget {
  const _PointSummary({
    required this.title,
    required this.point,
  });

  final String title;
  final int point;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###");
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 18)),
        horizontalSpaceSmall,
        Text(
          '${formatter.format(point)}P',
          style: const TextStyle(fontSize: 30, color: primaryColor),
        ),
      ],
    );
  }
}

class _HouseWorkDetail extends GetView<HistoryViewController> {
  const _HouseWorkDetail(
      {required this.pointHistoryId,
      required this.categoryImageUrl,
      required this.categoryName,
      required this.houseWorkName,
      required this.userIconImageUrl,
      required this.time,
      required this.point,
      required this.isMe});

  final int pointHistoryId;
  final String categoryImageUrl;
  final String categoryName;
  final String houseWorkName;
  final String userIconImageUrl;
  final String time;
  final int point;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: isMe
              ? () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return HouseWorkHistoryDeleteDialog(
                          houseWorkName: houseWorkName,
                          categoryName: categoryName,
                          onPressed: () {
                            controller.onTapDelete(pointHistoryId: pointHistoryId);
                            Navigator.pop(context, true);
                          },
                        );
                      }).then((value) {
                    if (value) {
                      return showDialog(
                          context: context,
                          builder: (context) => const NormalCompletedDialog(message: '家事を取り消しました'));
                    }
                  });
                }
              : () {},
          child: Container(
            height: 70,
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: categoryImageUrl,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      ),
                    ),
                    horizontalSpaceSmall,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(categoryName, style: const TextStyle(fontSize: 12)),
                        verticalSpaceTiny,
                        Text(
                          houseWorkName,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: userIconImageUrl,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      ),
                      imageBuilder: (context, imageProvider) {
                        return CircleAvatar(
                          radius: 15,
                          backgroundImage: imageProvider,
                        );
                      },
                    ),
                    horizontalSpaceSmall,
                    SizedBox(
                      width: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(time, style: const TextStyle(fontSize: 16)),
                          Text(
                            "${point}P",
                            style: const TextStyle(fontSize: 20, color: primaryColor),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
