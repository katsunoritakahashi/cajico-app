import 'package:cajico_app/ui/common/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:speech_balloon/speech_balloon.dart';

class RewardCategoryCard extends StatelessWidget {
  const RewardCategoryCard({
    super.key,
    required this.rank,
    required this.rewardName,
    required this.rating,
    required this.ownedPoint,
    required this.requiredPoint,
    required this.differencePoint,
    required this.imageUrl
  });

  final String rank;
  final String rewardName;
  final double rating;
  final int ownedPoint;
  final int requiredPoint;
  final int differencePoint;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.mode(
            Colors.black26,
            BlendMode.srcATop,
          ), //
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "ごほうび",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white
                        ),
                      ),
                      Text(
                        "「$rank」",
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                  verticalSpaceSmall,
                  Row(
                    children: [
                      Text(
                        rewardName,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SpeechBalloon(
                nipLocation: NipLocation.left,
                height: 60, // マルなので同じheightとwidth
                width: 60,
                borderRadius: 40,
                offset: const Offset(1,0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 35,
                      child: Text(
                        'あと',
                        style: TextStyle(color: Colors.black87, fontSize: 10),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Text(
                      "${differencePoint}P",
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              )
            ],
          ),
          verticalSpaceMedium,
          verticalSpaceLarge,
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: rating,
              color: Colors.amber[600],
              backgroundColor: Colors.white,
              minHeight: 8,
            ),
          ),
          verticalSpaceTiny,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    "保有ポイント",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white
                    ),
                  ),
                  Text(
                    "${ownedPoint}P",
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "必要ポイント",
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white
                    ),
                  ),
                  Text(
                    "${requiredPoint}P",
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}