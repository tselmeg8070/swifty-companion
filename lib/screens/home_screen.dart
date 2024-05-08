import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:swifty_companion/models/user.dart';
import 'package:swifty_companion/screens/profile_screen.dart';
import 'package:swifty_companion/services/server.dart';
import 'package:toastification/toastification.dart';

import '../style/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool hasError = false;
  late final AnimationController _controller;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: AppColors.dark,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Builder(builder: (context) {
                if (hasError) {
                  return Lottie.asset(
                    'assets/error.json',
                    controller: _controller,
                    onLoaded: (composition) {
                      _controller.duration = composition.duration;
                    },
                  );
                }
                return Lottie.asset(
                  'assets/cute.json',
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller.duration = composition.duration;
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
              child: SearchBar(
                controller: _textEditingController,
                elevation: const MaterialStatePropertyAll<double?>(0),
                backgroundColor:
                    const MaterialStatePropertyAll<Color>(AppColors.white),
                shape: MaterialStatePropertyAll<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32))),
                hintText: "Who is this carrot?",
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8)),
                leading: Icon(
                  PhosphorIcons.carrot(PhosphorIconsStyle.fill),
                  color: Colors.deepOrange,
                ),
                trailing: <Widget>[
                  Tooltip(
                    message: 'Change brightness mode',
                    child: IconButton(
                        onPressed: () async {
                          setState(() {
                            hasError = false;
                          });
                          _controller.forward(from: 0);
                          try {
                            String login = _textEditingController.value.text;
                            final res =
                                await Server().getRequest("/v2/users/$login");
                            Duration remaining =
                                _controller.duration ?? const Duration(seconds: 0);
                            await Future.delayed(remaining, () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                      userModel:
                                          UserModel.fromJson(res.data))));
                            });
                          } catch (e) {
                            if (e is DioException) {
                              toastification.show(
                                type: ToastificationType.error,
                                title: Text('Status code: ${e.response!.statusCode}'),
                                autoCloseDuration: const Duration(seconds: 2),
                              );
                            }
                            setState(() {
                              hasError = true;
                            });
                          }
                        },
                        icon: Icon(
                          PhosphorIcons.caretRight(),
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
