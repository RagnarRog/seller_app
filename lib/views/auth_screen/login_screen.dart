import 'package:get/get.dart';
import 'package:seller_app/const/const.dart';
import 'package:seller_app/controllers/auth_controller.dart';
import 'package:seller_app/views/widgets/our_button.dart';

import '../home_screen/home.dart';
import '../widgets/normal_text.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: purpleColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              30.heightBox,
              normalText(text: welcome, size: 18.0),
              20.heightBox,
              Row(
                children: [
                  Image.asset(
                    icLogo,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ).box.rounded.clip(Clip.antiAlias).make(),
                  10.widthBox,
                  boldText(text: appname, size: 20.0),
                ],
              ),
              60.heightBox,
              normalText(text: loginto, size: 18.0, color: lightGrey),
              10.heightBox,
              Obx(
                () =>
                    Column(
                          children: [
                            TextFormField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: textfieldGrey,
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: purpleColor,
                                ),
                                border: InputBorder.none,
                                hintText: emailHint,
                              ),
                            ),
                            10.heightBox,
                            TextFormField(
                              obscureText: true,
                              controller: controller.passwordController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: textfieldGrey,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: purpleColor,
                                ),
                                border: InputBorder.none,
                                hintText: passwordHint,
                              ),
                            ),
                            10.heightBox,
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () =>
                                    controller.sendPasswordReset(context),
                                child: normalText(
                                  text: forgotPassword,
                                  color: purpleColor,
                                ),
                              ),
                            ),
                            30.heightBox,
                            SizedBox(
                              width: context.screenWidth - 100,
                              child: controller.isLoading.value
                                  ? CircularProgressIndicator()
                                  : ourButton(
                                      title: login,
                                      onPress: () async {
                                        controller.isLoading(true);
                                        await controller
                                            .loginMethod(context: context)
                                            .then((value) {
                                              if (value != null) {
                                                VxToast.show(
                                                  // ignore: use_build_context_synchronously
                                                  context,
                                                  msg: "logged in",
                                                );
                                                controller.isLoading(false);
                                                Get.offAll(() => const Home());
                                              } else {
                                                controller.isLoading(false);
                                              }
                                            });
                                      },
                                    ),
                            ),
                          ],
                        ).box.white.rounded.outerShadowMd
                        .padding(const EdgeInsets.all(8))
                        .make(),
              ),
              10.heightBox,
              Center(
                child: normalText(text: anyProblem, color: lightGrey),
              ),
              const Spacer(),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
