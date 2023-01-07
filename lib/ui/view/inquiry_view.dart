import 'package:cajico_app/ui/common/app_color.dart';
import 'package:cajico_app/ui/common/ui_helper.dart';
import 'package:cajico_app/ui/controller/inquiry_view_controller.dart';
import 'package:cajico_app/ui/widget/normal_completed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_view_controller.dart';
import '../widget/normal_dialog.dart';
import '../widget/primary_button.dart';

class InquiryView extends StatelessWidget {
  InquiryView({super.key});

  final focusNode = FocusNode();
  final titleTextController = TextEditingController();
  final bodyTextController = TextEditingController();
  String title = '';
  String body = '';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InquiryViewController());
    final homeController = Get.put(HomeViewController());
    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: focusNode.requestFocus,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.black54),
              centerTitle: true,
              title: const Text('ご意見箱', style: TextStyle(color: gray2)),
              backgroundColor: Colors.white,
              titleTextStyle: const TextStyle(fontSize: 22)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    '追加してほしい機能や\n改善して欲しい箇所がありましたら\nお気軽にご連絡ください。\nできる限りご希望に添えるよう改善いたします。',
                    textAlign: TextAlign.center,
                  ),
                ),
                verticalSpaceLarge,
                TextField(
                  controller: titleTextController,
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                      labelText: 'タイトル',
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
                  controller: bodyTextController,
                  cursorColor: primaryColor,
                  keyboardType: TextInputType.multiline,
                  minLines: 10,
                  maxLines: 10,
                  decoration: InputDecoration(
                      labelText: 'ご意見 / 改善点など',
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
                  label: '送信する',
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
                          builder: (context) => NormalCompletedDialog(
                            message: '送信されました',
                            onPressed: () {
                              Navigator.pop(context);
                              homeController.onTapGetUnreadCount();
                            },
                          ),
                        );
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
