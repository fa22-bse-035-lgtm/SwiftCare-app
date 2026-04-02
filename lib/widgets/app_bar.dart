import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool color;
  final IconData? rightIcon1;
  final VoidCallback? onRightIcon1Pressed;
  final IconData? rightIcon2;
  final VoidCallback? onRightIcon2Pressed;

  const CustomAppBar({
    super.key,
    this.title,
    required this.color,
    this.rightIcon1,
    this.onRightIcon1Pressed,
    this.rightIcon2,
    this.onRightIcon2Pressed,
  });

  Widget _circularIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color.fromARGB(0, 255, 255, 255),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color.fromARGB(255, 193, 193, 193),
          width: 1.1,
        ),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black, size: 20),
        onPressed: onPressed,
        splashRadius: 22,
      ),
    );
  }

  Widget _buildTitle() {
    if (rightIcon1 != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 48),
        child: Text(
          title!,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 18,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else if (rightIcon1 == null && rightIcon2 == null) {
      return Padding(
        padding: const EdgeInsets.only(right: 48),
        child: Text(
          title!,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 18,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      return Text(
        title!,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: Colors.black,
          fontSize: 18,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: preferredSize.height,
        color: color == true ? Colors.white : const Color.fromARGB(0, 255, 255, 255),
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 15.0,
          top: 12.0,
          bottom: 10.0,
        ),
        child: SizedBox(
          child: Row(
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: _circularIconButton(
                  icon: Icons.arrow_back,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              // Title (centered if present)
              Expanded(
                child: title != null && title!.isNotEmpty
                    ? Center(child: _buildTitle())
                    : Container(),
              ),
              // Right icons
              if (rightIcon1 != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: _circularIconButton(
                    icon: rightIcon1!,
                    onPressed: onRightIcon1Pressed,
                  ),
                ),
              if (rightIcon2 != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: _circularIconButton(
                    icon: rightIcon2!,
                    onPressed: onRightIcon2Pressed,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
