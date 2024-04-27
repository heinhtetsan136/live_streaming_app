import "package:animated_toggle_switch/animated_toggle_switch.dart";
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/router/route_name.dart';
import 'package:live_streaming/service/auth_service.dart/auth_sevice.dart';
import 'package:live_streaming/service/frebase/firestore.dart';
import 'package:starlight_utils/starlight_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Locator<AuthService>();
    final SettingService settingService = Locator<SettingService>();

    return Scaffold(
      appBar: AppBar(
        leading: const IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: StarlightUtils.pop,
        ),
        title: const Text("Setting"),
      ),
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: ListView(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          children: [
            StreamBuilder(
              stream: authService.userchanges(),
              builder: (_, snap) {
                final data = snap.data;
                if (data == null) return const SizedBox();
                final url = data.photoURL;

                return GestureDetector(
                  onTap: () {
                    StarlightUtils.pushNamed(RouteNames.profilesettting);
                  },
                  // onTap: _goToProfileSetting,
                  child: ProfileCard(
                    shortName:
                        data.email?[0] ?? data.displayName?[0] ?? data.uid[0],
                    profileUrl: url ?? "",
                    displayName: data.displayName ?? "",
                    email: data.email ?? data.uid,
                  ),
                );
              },
            ),
            StreamBuilder(
                stream: settingService.setting(),
                builder: (_, snap) {
                  final data = snap.data;
                  return SwitchCard(
                      onTap: (value) async {
                        final result =
                            await settingService.Write("theme", value);
                        // print("theme $result");
                      },
                      title: "Theme",
                      first: "light",
                      second: "dark",
                      current: data?.theme ?? "light",
                      firstWidget: const Icon(Icons.brightness_5),
                      secondWidget: const Icon(Icons.brightness_2));
                }),
            StreamBuilder(
                stream: settingService.setting(),
                builder: (_, snap) {
                  final data = snap.data;
                  return SwitchCard(
                      onTap: (value) async {
                        await settingService.Write("isSound", value);
                      },
                      title: "Mute Audio",
                      first: true,
                      second: false,
                      current: data?.isSound ?? true,
                      firstWidget: const Icon(Icons.volume_up),
                      secondWidget: const Icon(Icons.volume_down));
                }),

            OnTapCard(
              title: "Term & Condition",
              onTap: () {
                launchUrl(Uri.parse("https://google.com"));
              },
            ),
            OnTapCard(
              title: "Liscenses",
              onTap: () {
                showLicensePage(context: context);
              },
            ),
            OnTapCard(
              title: "About Us",
              onTap: () {
                StarlightUtils.aboutDialog(
                    applicationName: "LiveStream Project",
                    applicationVersion: "1.0.0");
              },
            ),
            OnTapCard(
              title: "Contact Us",
              onTap: () {
                launchUrl(Uri.parse("tel:+959794810715"));
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Align(
                  child: TextButton(
                onPressed: () async {
                  await authService.logout();
                  StarlightUtils.pushNamed(RouteNames.home);
                },
                child: const Text(
                  "LogOut",
                  style: TextStyle(fontSize: 19),
                ),
              )),
            )

            // StreamBuilder(
            //   stream: settingService.settings(),
            //   builder: (_, snap) {
            //     final data = snap.data;

            //     return SwitchCard(
            //       onTap: (value) async {
            //         await settingService.write("theme", value);
            //       },
            //       title: "Theme",
            //       current: data?.theme ?? "light",
            //       first: "light",
            //       second: "dark",
            //       firstWidget: const Icon(Icons.brightness_5),
            //       secondWidget: const Icon(Icons.brightness_2),
            //     );
            //   },
            // ),
            // StreamBuilder(
            //   stream: settingService.settings(),
            //   builder: (_, snap) {
            //     final data = snap.data;
            //     return SwitchCard(
            //       onTap: (value) {
            //         settingService.write("is_mute", value);
            //       },
            //       title: "Mute Audio",
            //       current: data?.withSound ?? true,
            //       first: false,
            //       second: true,
            //       firstWidget: const Icon(
            //         Icons.volume_off,
            //       ),
            //       secondWidget: const Icon(
            //         Icons.volume_up,
            //         size: 22,
            //       ),
            //     );
            //   },
            // ),
            // const OnTapCard(
            //   onTap: _termsAndConditions,
            //   title: "Terms and Conditions",
            // ),
            // OnTapCard(
            //   onTap: () {
            //     StarlightUtils.push(
            //       Theme(
            //         data: theme.brightness == Brightness.dark
            //             ? ThemeData.dark().copyWith(
            //                 progressIndicatorTheme:
            //                     theme.progressIndicatorTheme,
            //               )
            //             : ThemeData.light().copyWith(
            //                 progressIndicatorTheme:
            //                     theme.progressIndicatorTheme,
            //               ),
            //         child: const LicensePage(),
            //       ),
            //     );
            //   },
            //   title: "Licenses",
            // ),
            // const OnTapCard(
            //   onTap: _contactUs,
            //   title: "Contact Us",
            // ),
            // const OnTapCard(
            //   onTap: _aboutUs,
            //   title: "About Us",
            // ),
            // const Padding(
            //   padding: EdgeInsets.only(top: 20),
            //   child: Align(
            //     child: LogoutButton(),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class SwitchCard<T> extends StatelessWidget {
  final String title;
  final T first;
  final T second;
  final T current;
  final Widget firstWidget, secondWidget;
  final Function(T)? onTap;
  const SwitchCard(
      {super.key,
      required this.title,
      required this.first,
      required this.second,
      required this.current,
      required this.firstWidget,
      required this.secondWidget,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Map<T, Widget> data = {};
    data.addEntries([
      MapEntry(
          first,
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: firstWidget,
          )),
      MapEntry(
        second,
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: secondWidget,
        ),
      )
    ]);
    final theme = context.theme;
    final textColor = theme.textTheme.bodyLarge?.color;
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
          ),
        ),
        trailing: AnimatedToggleSwitch.dual(
          onChanged: (value) {
            this.onTap?.call(value);
          },
          onTap: (t) {
            print(t.tapped?.value);
            final v = t.tapped?.value;
            if (v != null) this.onTap?.call(v);
          },
          style: const ToggleStyle(
            backgroundColor: Color.fromRGBO(230, 230, 230, 1),
            indicatorColor: Colors.transparent,
          ),
          animationOffset: const Offset(10, 0),
          spacing: 8,
          indicatorSize: const Size(30, 30),
          borderWidth: 0,
          height: 35,
          first: first,
          second: second,
          current: current,
          // second: second,
          // current: current,
          // first: first,
          iconBuilder: (i) {
            return data[i]!;
          },
        ),
      ),
    );
  }
}

class OnTapCard extends StatelessWidget {
  final String title;

  final void Function()? onTap;

  const OnTapCard({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textColor = theme.textTheme.bodyLarge?.color;
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String profileUrl, shortName, displayName, email;

  const ProfileCard({
    super.key,
    required this.profileUrl,
    required this.shortName,
    required this.displayName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textColor = theme.textTheme.bodyLarge?.color;
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
        left: 10,
        right: 10,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor, //
        borderRadius:
            BorderRadius.circular(8), // Color.fromRGBO(r, g, b, opacity)
      ),
      child: Row(
        children: [
          if (profileUrl.isEmpty == true)
            CircleAvatar(
              maxRadius: 35,
              child: Text(
                shortName,
                style: TextStyle(
                  fontSize: 28,
                  color: textColor,
                ),
              ),
            )
          else
            NetworkProfile(
              radius: 35,
              onFail: CircleAvatar(
                maxRadius: 35,
                child: Text(
                  shortName,
                  style: TextStyle(
                    fontSize: 28,
                    color: textColor,
                  ),
                ),
              ),
              profileUrl: profileUrl,
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(Icons.chevron_right),
          )
        ],
      ),
    );
  }
}

class NetworkProfile extends StatelessWidget {
  final Widget onFail;
  final String profileUrl;
  final double? radius;

  const NetworkProfile({
    super.key,
    required this.profileUrl,
    required this.radius,
    required this.onFail,
  });

  double get _radius => radius ?? 42;

  @override
  Widget build(BuildContext context) {
    if (profileUrl.startsWith("http")) {
      return CircleAvatar(
        maxRadius: radius,
        backgroundImage: CachedNetworkImageProvider(profileUrl),
      );
    }

    return FutureBuilder(
      key: ValueKey(profileUrl),
      future: Locator<FirebaseStorage>().ref(profileUrl).getDownloadURL(),
      builder: (_, snap) {
        return ClipOval(
          child: CachedNetworkImage(
            width: _radius,
            height: _radius,
            fit: BoxFit.cover,
            imageUrl: snap.data ?? '',
            placeholder: (_, s) => const CircleAvatar(
              child: Align(
                child: CupertinoActivityIndicator(),
              ),
            ),
            errorWidget: (_, s, b) => onFail,
          ),
        );
      },
    );
  }
}
