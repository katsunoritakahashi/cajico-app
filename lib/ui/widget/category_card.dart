import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.categoryName,
    required this.imageUrl,
  });

  final String categoryName;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.28, // SEでも対応できるギリギリのサイズ
      child: ElevatedButton(
        onPressed: (){},
        style: ElevatedButton.styleFrom(
          splashFactory: InkRipple.splashFactory,
          elevation: 3,
          foregroundColor: Colors.grey,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Text(
              categoryName,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87
              ),
            ),
            Image(
              image: AssetImage(imageUrl),
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}
