import 'package:cajico_app/ui/common/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/ui_helper.dart';
import '../controller/house_work_view_controller.dart';
import '../controller/inquiry_view_controller.dart';
import '../widget/house_work_card.dart';
import '../widget/loading_stack.dart';
import '../widget/normal_completed_dialog.dart';
import '../widget/normal_dialog.dart';
import '../widget/primary_button.dart';

class RewardEditView extends StatelessWidget {
  RewardEditView({
    super.key,
  });

  final focusNode = FocusNode();
  final titleTextController = TextEditingController();
  late TextEditingController bodyTextController = TextEditingController();
  String title = '';
  String body = '';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InquiryViewController());
    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: focusNode.requestFocus,
        child: Scaffold(
          backgroundColor: gray7,
          appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.black54),
              centerTitle: true,
              title: const Text('ごほうびの編集', style: TextStyle(color: gray2)),
              backgroundColor: Colors.white,
              titleTextStyle: const TextStyle(fontSize: 22)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                verticalSpaceLarge,
                TextFormField(
                  controller: TextEditingController.fromValue(
                    const TextEditingValue(text: 'リーズナブル'),
                  ),
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                      labelText: 'プラン',
                      labelStyle: const TextStyle(color: gray3),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: gray6)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: primaryColor))),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                verticalSpaceMedium,
                TextFormField(
                  controller: TextEditingController.fromValue(
                    const TextEditingValue(text: 'お菓子・スイーツ'),
                  ),
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                      labelText: 'ごほうび名',
                      labelStyle: const TextStyle(color: gray3),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: gray6)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: primaryColor))),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                verticalSpaceMedium,
                TextFormField(
                  controller: TextEditingController.fromValue(
                    TextEditingValue(text: 300.toString()),
                  ),
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                      labelText: '必要ポイント（100P~500P）',
                      labelStyle: const TextStyle(color: gray3),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: gray6)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: primaryColor))),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                verticalSpaceMedium,
                TextFormField(
                  controller: TextEditingController.fromValue(
                    const TextEditingValue(text: 'コンビニで手軽なスナック菓子を買ってもらえる！\n↓欲しいお菓子\nhttps://example.com'),
                  ),
                  cursorColor: primaryColor,
                  keyboardType: TextInputType.multiline,
                  minLines: 10,
                  maxLines: 10,
                  decoration: InputDecoration(
                      labelText: 'ごほうびメモ',
                      labelStyle: const TextStyle(color: gray3),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: gray6)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: primaryColor))),
                  onChanged: (value) {
                    body = value;
                  },
                ),
                verticalSpaceLarge,
                PrimaryButton(
                  label: '変更する',
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return NormalDialog(
                            message: '送信しますか？',
                            onPressed: () {
                              titleTextController.clear();
                              bodyTextController.clear();
                              controller.onTapInquiry(title: title, body: body);
                              Navigator.pop(context, true);
                            },
                          );
                        }).then((value) {
                      if (value) {
                        return showDialog(
                            context: context,
                            builder: (context) => const NormalCompletedDialog(message: '送信されました'));
                      }
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}