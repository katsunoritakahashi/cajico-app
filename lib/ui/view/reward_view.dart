import 'package:cajico_app/ui/common/app_color.dart';
import 'package:cajico_app/ui/widget/footer.dart';
import 'package:cajico_app/ui/widget/home_drawer.dart';
import 'package:cajico_app/ui/widget/notification.dart';
import 'package:flutter/material.dart';
import '../common/ui_helper.dart';
import '../widget/reward_category_card.dart';

class RewardView extends StatelessWidget {
  const RewardView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black54),
          centerTitle: true,
          title: Row(
              children: const [
                Image(
                  image: AssetImage(
                    'assets/images/logo_reward.png',
                  ),
                  height: 55,
                ),
                Text('ごほうび'),
              ]
          ),
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(
              color: gray2,
              fontSize: 22
          ),
          actions: const [
            NotificationAction(),
          ],
          bottom: const TabBar(
            labelColor: Colors.black87,
            indicatorColor: Colors.orange,
            labelStyle: TextStyle(fontSize: 16),
            tabs: <Widget>[
              Tab(
                  text: 'かつのり'
              ),
              Tab(
                  text: 'えりか'
              ),
            ],
          ),
        ),
        drawer: const HomeDrawer(),
        body: TabBarView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SingleChildScrollView (
                child: Column(
                  children: const [
                    verticalSpaceSmall,
                    RewardCategoryCard(
                      rank: "ライト",
                      rewardName: 'お菓子・スイーツ',
                      imageUrl: 'assets/images/afternoon_tea.png',
                      rating: 1.0,
                      ownedPoint: 1000,
                      requiredPoint: 1000,
                      differencePoint: 0,
                    ),
                    verticalSpaceSmall,
                    RewardCategoryCard(
                      rank: "スタンダード",
                      rewardName: 'Amazonギフト券',
                      imageUrl: 'assets/images/present.png',
                      rating: 0.33,
                      ownedPoint: 1000,
                      requiredPoint: 3000,
                      differencePoint: 2000,
                    ),
                    verticalSpaceSmall,
                    RewardCategoryCard(
                      rank: "スペシャル",
                      rewardName: 'あなたが欲しいもの',
                      imageUrl: 'assets/images/propose.png',
                      rating: 0.1,
                      ownedPoint: 1000,
                      requiredPoint: 10000,
                      differencePoint: 9000,
                    ),
                    verticalSpaceSmall,
                  ],
                ),
              ),
            ),
            const Center(
              child: Text('えりか', style: TextStyle(fontSize: 32.0)),
            ),
          ],
        ),
        bottomNavigationBar: const Footer(),
      ),
    );
  }
}
