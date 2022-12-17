import 'package:cajico_app/ui/widget/primary_small_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/home_view.dart';

class NormalCompletedDialog extends StatelessWidget {
  const NormalCompletedDialog({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      title: Text(message,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center),
      children: [
        SimpleDialogOption(
          child: const PrimarySmallButton(text: 'OK'),
          onPressed: () {
            Navigator.pop(context);
            Get.to(() => const HouseWork());
          },
        )
      ],
    );
  }
}
