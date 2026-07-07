import 'package:flutter/material.dart';
import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController pulseController;

  late AnimationController fadeController;

  late Animation<double> pulse;

  late Animation<double> fade;

  @override
  void initState() {
    super.initState();

    pulseController =
        AnimationController(

      vsync: this,

      duration:
          const Duration(
        milliseconds: 1400,
      ),
    );

    fadeController =
        AnimationController(

      vsync: this,

      duration:
          const Duration(
        milliseconds: 1800,
      ),
    );

    pulse = Tween<double>(
      begin: 0.85,
      end: 1.12,
    ).animate(

      CurvedAnimation(

        parent:
            pulseController,

        curve:
            Curves.easeInOut,
      ),
    );

    fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(

      CurvedAnimation(

        parent:
            fadeController,

        curve:
            Curves.easeIn,
      ),
    );

    pulseController.repeat(
      reverse: true,
    );

    fadeController.forward();

    Future.delayed(

      const Duration(
          seconds: 4),

      () {

        if (!mounted) return;

        Navigator.pushReplacement(

          context,

          PageRouteBuilder(

            transitionDuration:
                const Duration(
              milliseconds:
                  900,
            ),

            pageBuilder:
                (
              context,
              animation,
              secondary,
            ) {

              return FadeTransition(

                opacity:
                    animation,

                child:
                    const MainNavigation(),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {

    pulseController.dispose();

    fadeController.dispose();

    super.dispose();
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      body: Container(

        decoration:
            const BoxDecoration(

          gradient:
              LinearGradient(

            begin:
                Alignment
                    .topLeft,

            end:
                Alignment
                    .bottomRight,

            colors: [

              Color(
                  0xFFB71C1C),

              Color(
                  0xFFD32F2F),

              Color(
                  0xFFEF5350),
            ],
          ),
        ),

        child:
            Center(

          child:
              FadeTransition(

            opacity:
                fade,

            child:
                Column(

              mainAxisAlignment:
                  MainAxisAlignment
                      .center,

              children: [

                AnimatedBuilder(

                  animation:
                      pulse,

                  builder:
                      (
                    context,
                    child,
                  ) {

                    return Transform.scale(

                      scale:
                          pulse
                              .value,

                      child:
                          Container(

                        width:
                            150,

                        height:
                            150,

                        decoration:
                            BoxDecoration(

                          color:
                              Colors.white,

                          shape:
                              BoxShape.circle,

                          boxShadow: [

                            BoxShadow(

                              color:
                                  Colors.white
                                      .withOpacity(
                                          0.5),

                              blurRadius:
                                  30,

                              spreadRadius:
                                  8,
                            ),
                          ],
                        ),

                        child:
                            const Icon(

                          Icons.favorite,

                          color:
                              Colors.red,

                          size:
                              90,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(
                    height:
                        35),

                const Text(

                  "Blood Connect",

                  style:
                      TextStyle(

                    color:
                        Colors.white,

                    fontSize:
                        34,

                    fontWeight:
                        FontWeight.bold,

                    letterSpacing:
                        1.5,
                  ),
                ),

                const SizedBox(
                    height:
                        15),

                TweenAnimationBuilder(

                  tween:
                      Tween(
                    begin: -20.0,
                    end: 0.0,
                  ),

                  duration:
                      const Duration(
                    milliseconds:
                        1400,
                  ),

                  builder:
                      (
                    context,
                    value,
                    child,
                  ) {

                    return Transform.translate(

                      offset:
                          Offset(
                        0,
                        value,
                      ),

                      child:
                          const Text(

                        "Donate Blood • Save Lives",

                        style:
                            TextStyle(

                          color:
                              Colors.white70,

                          fontSize:
                              16,

                          letterSpacing:
                              1.1,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(
                    height:
                        60),

                SizedBox(

                  width:
                      45,

                  height:
                      45,

                  child:
                      CircularProgressIndicator(

                    color:
                        Colors.white,

                    strokeWidth:
                        4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}