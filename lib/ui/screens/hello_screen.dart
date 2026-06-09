import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HelloScreen extends StatefulWidget {

  final VoidCallback nextPage;

  const HelloScreen({
    super.key,
    required this.nextPage
  });

  @override
  State<HelloScreen> createState() => _HelloScreenState();

}

class _HelloScreenState extends State<HelloScreen> with TickerProviderStateMixin {

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000)
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500)
    );

    _slideAnimation = Tween<double>(
      begin: 0,
      end: -300
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn)
    ));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn)
    ));

    Future.delayed(const Duration(milliseconds: 200), () {
      if(mounted) {
        _slideController.forward();
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if(mounted) {
        _fadeController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _slideController,
            _fadeController
          ]),
          builder: (context, child) => Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7
              ),
              child: Transform.translate(
                offset: Offset(0, _slideAnimation.value * 0.2),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/logo.svg",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Text(
                            "Добро пожаловать в ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                                text: "Shlus Messenger",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w700
                                ),
                                children: [
                                  TextSpan(
                                    text: "!",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700
                                    )
                                  )
                                ]
                              ),
                          )
                        ],
                      ),
                      const SizedBox(height: 50),
                      Opacity(
                        opacity: _fadeAnimation.value,
                        child: Column(
                          children: [
                            Text(
                              "Shlus — это децентрализованный OpenSource мессенджер.",
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Свободно. Надёжно. Безопасно.",
                              style: TextStyle(
                                color: Colors.grey.shade600
                              )
                            ),
                            const SizedBox(height: 200),
                            InkWell(
                              onTap: widget.nextPage,
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Text(
                                  "Начать общение",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500                            )
                                ),
                              )
                            )
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              )
            ),
          ),
        ),
      )
    );
  }
}