import 'package:flutter/material.dart';
import 'package:project_firebase/widgets/app_color.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  const RoundButton({
    super.key,
    required this.title,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.deepColor,
        ),

        child: Center(
          child: loading
              ? CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColor.whiteColor,
                )
              : Center(
                  child: Text(
                    title,
                    style: TextStyle(color: AppColor.whiteColor),
                  ),
                ),
        ),
      ),
    );
  }
}
