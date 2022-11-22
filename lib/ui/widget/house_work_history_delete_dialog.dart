import 'package:cajico_app/ui/common/app_color.dart';
import 'package:cajico_app/ui/common/ui_helper.dart';
import 'package:cajico_app/ui/widget/primary_small_button.dart';
import 'package:cajico_app/ui/widget/primary_small_outline_button.dart';
import 'package:flutter/material.dart';

class HouseWorkHistoryDeleteDialog extends StatelessWidget {
  const HouseWorkHistoryDeleteDialog({
    super.key,
    required this.categoryName,
    required this.houseWorkName,
  });
  final String categoryName;
  final String houseWorkName;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      title: Column(
        children: [
          Text(categoryName, style: const TextStyle(color: gray2, fontSize: 18)),
          verticalSpaceSmall,
          Text(houseWorkName, style: const TextStyle(fontWeight: FontWeight.bold, color: gray2)),
          verticalSpaceMedium,
          const Text('を取り消しますか？', style: TextStyle(fontSize: 16, color: gray2))
        ],
      ),
      children: [
        SimpleDialogOption(
          child: const PrimarySmallButton(text: 'はい！'),
          onPressed: () {
            Navigator.pop(context, '1が選択されました');
          },
        ),
        SimpleDialogOption(
          child: const PrimarySmallOutlineButton(text: 'いいえ'),
          onPressed: () {
            Navigator.pop(context, '2が選択されました');
          },
        )
      ],
    );
  }
}