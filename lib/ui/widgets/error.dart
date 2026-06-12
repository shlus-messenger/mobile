import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorBanner extends StatefulWidget {

  final String message;
  final VoidCallback onDismiss;

  const ErrorBanner({
    super.key,
    required this.message,
    required this.onDismiss
  });

  @override
  State createState() => _ErrorBannerState();

  static void show(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => ErrorBanner(
        message: message,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }

}

class _ErrorBannerState extends State<ErrorBanner> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {

    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this
    );
    
    if(mounted) {
      Future.delayed(const Duration(seconds: 2), () {
        _controller.reverse().then((_) {
          widget.onDismiss();
        });
      });
    }

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 20.h,
          left: 10.w,
          right: 10.w,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(180, 0, 0, 0)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10.w,
                children: [
                  Icon(Icons.error, color: Colors.red),
                  DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                    ),
                    child: Text(
                      softWrap: true,
                      widget.message,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )
            ),
          ),
        )
      ],
    );
  }

}