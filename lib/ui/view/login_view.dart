import 'package:cajico_app/ui/common/app_color.dart';
import 'package:cajico_app/ui/view/home_view.dart';
import 'package:cajico_app/ui/widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/ui_helper.dart';
import '../widget/cajico_text_form_field.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Focus(
        focusNode: focusNode,
        child: GestureDetector(
            onTap: focusNode.requestFocus,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.black54),
                centerTitle: true,
                title: const Text('ログイン', style: TextStyle(color: gray2)),
                backgroundColor: Colors.white,
                titleTextStyle: const TextStyle(fontSize: 22),
              ),
              body: Container(
                padding: const EdgeInsets.only(right: 16, left: 16, top: 40, bottom: 24),
                child: Column(
                  children: [
                    const Text(
                      'メールアドレスとパスワードを\n入力してください',
                      textAlign: TextAlign.center,
                    ),
                    verticalSpaceLarge,
                    const CajicoTextFormField(
                      label: 'メールアドレス',
                      initValue: '',
                    ),
                    verticalSpaceMedium,
                    const CajicoTextFormField(
                      label: 'パスワード',
                      initValue: '',
                      obscureText: true,
                      maxLines: 1,
                    ),
                    verticalSpaceMediumLarge,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'メールアドレス及びパスワードをお忘れの方は',
                            style: TextStyle(fontSize: 13),
                          ),
                          InkWell(
                            child: const Text(
                              'こちら',
                              style: TextStyle(color: primaryColor, fontSize: 13),
                            ),
                            onTap: () => Get.to(() => const HouseWork()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: PrimaryButton(
                  label: 'ログイン',
                  onPressed: () => Get.to(const HouseWork()),
                ),
              ),
            )));
  }
}
