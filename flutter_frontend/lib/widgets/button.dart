import 'package:flutter/material.dart';

// Custom button widget
class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  final Icon? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: backgroundColor, // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 12,
        ),
      ),
      label: !isLoading
          ? Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
              ),
            )
          : const Center(
              child: SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              ),
            ),
      icon: !isLoading && icon != null ? const Icon(Icons.delete) : null,
    );
  }
}
