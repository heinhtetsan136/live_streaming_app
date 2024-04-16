import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/screen/view/screen/setting_screen.dart';
import 'package:live_streaming/service/auth_service.dart/auth_sevice.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ProfileSettingScreen extends StatelessWidget {
  const ProfileSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Locator<AuthService>();
    final theme = context.theme;
    final primaryColor = theme.floatingActionButtonTheme.backgroundColor;
    final cardBgColor = theme.bottomNavigationBarTheme.backgroundColor;
    final textColor = theme.textTheme.bodyLarge?.color;
    // final TextEditingController controller = TextEditingController();
    // final FocusNode focusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        leading: const IconButton(
          onPressed: StarlightUtils.pop,
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text("Update Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              height: context.height * 0.3,
              width: context.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await authService.UpdateProfile();
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          maxRadius: 44,
                          backgroundColor: primaryColor,
                        ),
                        NetworkUserInfo(
                          builder: (data) {
                            final shortName = data.displayName?[0] ??
                                data.email?[0] ??
                                data.uid[0];
                            final profileUrl = data.photoURL ?? "";
                            if (profileUrl.isEmpty == true) {
                              return CircleAvatar(
                                maxRadius: 42,
                                child: Text(
                                  shortName,
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: textColor,
                                  ),
                                ),
                              );
                            }
                            return NetworkProfile(
                              radius: 42,
                              profileUrl: profileUrl,
                              onFail: CircleAvatar(
                                maxRadius: 42,
                                child: Text(
                                  shortName,
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 5,
                          child: Icon(
                            Icons.camera_alt,
                            color: textColor,
                            size: 15,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: NetworkUserInfo(
                      builder: (user) {
                        return Text(
                          user.displayName ??
                              user.email ??
                              user.uid.substring(0, 5),
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: NetworkUserInfo(
                      builder: (user) {
                        return Text(
                          "Identity: ${user.providerData.first.email ?? user.providerData.first.phoneNumber ?? user.email ?? "NA"}",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: NetworkUserInfo(
                      builder: (user) {
                        return Text(
                          "Linked With: ${user.providerData.first.providerId}",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ProfileSettingCard(
                onTap: () async {
                  final result = await StarlightUtils.bottomSheet(builder: (_) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      width: context.width,
                      height: context.height * 0.5,
                      color: theme.scaffoldBackgroundColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            // controller: controller,
                            // focusNode: focusNode,
                            validator: (value) {
                              return value?.isNotEmpty == true
                                  ? null
                                  : "Display Name cannot be empty";
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            initialValue: authService.currentuser?.displayName,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Display Name",
                            ),
                            onFieldSubmitted: (value) {
                              if (value.isNotEmpty) {
                                StarlightUtils.pop(result: value);
                              }
                            },
                          )
                        ],
                      ),
                    );
                  });
                  if (result != null) {
                    Locator<AuthService>().UpdateDisplayName(result);
                  }
                },
                title: "Display Name",
                value: (user) =>
                    user.displayName ?? user.email ?? user.uid.substring(0, 5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ProfileSettingCard(
                title: "Identity",
                value: (user) {
                  return user.providerData.first.email ??
                      user.providerData.first.phoneNumber ??
                      user.email ??
                      "NA";
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ProfileSettingCard(
                title: "Linked With",
                value: (user) {
                  return user.providerData.first.providerId;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileSettingCard extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final String Function(User) value;

  const ProfileSettingCard({
    super.key,
    this.onTap,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final textColor = theme.textTheme.bodyLarge?.color;
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
        ),
      ),
      trailing: NetworkUserInfo(
        builder: (user) {
          return Text(
            value(user),
            style: TextStyle(
              color: textColor,
              fontSize: 14,
            ),
          );
        },
      ),
    );
  }
}

class NetworkUserInfo extends StatelessWidget {
  final Widget Function(User) builder;

  const NetworkUserInfo({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Locator<AuthService>().userchanges(),
      builder: (_, snap) {
        final data = snap.data;
        if (data == null) return const SizedBox();
        return builder(data);
      },
    );
  }
}
