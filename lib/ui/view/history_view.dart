import 'package:cached_network_image/cached_network_image.dart';
import 'package:cajico_app/ui/common/app_color.dart';
import 'package:cajico_app/ui/widget/footer.dart';
import 'package:cajico_app/ui/widget/header.dart';
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
import '../controller/home_view_controller.dart';
import '../widget/loading_stack.dart';
import '../widget/next_page_button.dart';

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
          appBar: const PreferredSize(
              preferredSize: Size.fromHeight(105),
              child: Header(
                imageUrl: 'assets/images/logo_history.png',
                title: '家事履歴',
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: _TabBar(),
                ),
              )),
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
                                    userIconImageUrl: element.iconUrl ??
                                        'https://cazico-public.s3.ap-northeast-1.amazonaws.com/user_icon/icon.png',
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
                                  ? NextPageButton(
                                      onPressed: () =>
                                          controller.onTapNextTotalPage(page: totalCurrentPage))
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
                          _PointSummaries(todayPoint: item.todayPoint, totalPoint: item.totalPoint),
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
                                userIconImageUrl: element.iconUrl ??
                                    'https://cazico-public.s3.ap-northeast-1.amazonaws.com/user_icon/icon.png',
                                time: element.time,
                                point: element.point,
                                isMe: element.isMe,
                              );
                            },
                            groupSeparatorBuilder: (date) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                child: Text(date, style: const TextStyle(color: gray3)),
                              );
                            },
                          ),
                          item.currentPage < item.lastPage
                              ? NextPageButton(
                                  onPressed: () => controller.onTapNextPage(
                                    userId: item.userId,
                                    page: item.currentPage,
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

class _TabBar extends StatelessWidget {
  const _TabBar();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.put(HistoryViewController());

      return Align(
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
                      imageUrl: pointHistory.iconUrl ??
                          'https://cazico-public.s3.ap-northeast-1.amazonaws.com/user_icon/icon.png',
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
    final homeController = Get.put(HomeViewController());
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
                        builder: (context) => NormalCompletedDialog(
                          message: '家事を取り消しました',
                          onPressed: () {
                            Navigator.pop(context);
                            homeController.onTapGetUnreadCount();
                          },
                        ),
                      );
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
