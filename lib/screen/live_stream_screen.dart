import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/live_view-controller/live_view_cubit.dart';
import 'package:live_streaming/controller/live_view-controller/live_view_state.dart';
import 'package:live_streaming/models/comment.dart';
import 'package:live_streaming/service/base/agora_base_service.dart';
import 'package:live_streaming/service/impl/agora_host_service.dart';
import 'package:live_streaming/widget/live_comment.dart';
import 'package:starlight_utils/starlight_utils.dart';

const kVideoRadius = 20.0;
const kBgColor = Color.fromRGBO(45, 40, 42, 1);
final border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(kVideoRadius),
);

class LiveStreamScreen extends StatefulWidget {
  final AgoraBaseService agoraBaseService;
  const LiveStreamScreen({super.key, required this.agoraBaseService});

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  @override
  Widget build(BuildContext context) {
    const double kVideoRadius = 20.0;
    final screenHeight = context.height;
    return Scaffold(
      body: ViewPortBuilder(minimized: (context) {
        return Column(
          children: [
            Stack(children: [
              SizedBox(
                width: context.width,
                height: context.height * 0.3,
                child: LiveStreamVideoView(service: widget.agoraBaseService),
                // decoration: const BoxDecoration(
                //   image: DecorationImage(
                //       fit: BoxFit.cover,
                //       image: NetworkImage(
                //           "https://th.bing.com/th/id/R.3c1dd9a48beba7547417fb546fba5b8d?rik=9B0iVSi%2bYi9wRA&riu=http%3a%2f%2fgetwallpapers.com%2fwallpaper%2ffull%2f0%2f7%2f3%2f820767-full-hd-nature-wallpapers-1920x1080-for-meizu.jpg&ehk=BGgL4g9sk2uysoCXn6sslXVXvfyXDH16ISeI2ZB475o%3d&risl=&pid=ImgRaw&r=0")),
                //   borderRadius: BorderRadius.only(
                //       bottomLeft: Radius.circular(kVideoRadius),
                //       bottomRight: Radius.circular(kVideoRadius)),
                // ),
              ),
              // LiveStreamVideo<T>(
              //   service: service,
              // ),
              Positioned(
                left: 20,
                right: 20,
                top: 30,
                child: Container(
                  height: 50,
                  color: const Color.fromRGBO(0, 0, 0, 0.1),
                  width: context.width,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          LiveRemark(),
                          SizedBox(
                            width: 30,
                          ),
                          // StreamBuilder(
                          //   stream: bloc.service.viewCount,
                          //   builder: (_, snap) {
                          //     return LiveCount(
                          //       count: snap.data?.toString() ?? '0',
                          //     );
                          //   },
                          // ),
                          LiveCount()
                        ],
                      ),
                      LiveViewToggle(),
                    ],
                  ),
                ),
              ),
            ]),
            Container(
              color: Colors.red,
              height: screenHeight * 0.25,
            ),
            const Expanded(child: CommentSection()),
            // Container(
            //   color: Colors.blue,
            //   height: screenHeight * 0.45,
            // )
          ],
        );
      }, fullscreen: (context) {
        return Stack(
          children: [
            SizedBox(
              width: context.width,
              height: context.height,
              child: LiveStreamVideoView(service: widget.agoraBaseService),
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //       fit: BoxFit.cover,
              //       image: NetworkImage(
              //           "https://th.bing.com/th/id/R.3c1dd9a48beba7547417fb546fba5b8d?rik=9B0iVSi%2bYi9wRA&riu=http%3a%2f%2fgetwallpapers.com%2fwallpaper%2ffull%2f0%2f7%2f3%2f820767-full-hd-nature-wallpapers-1920x1080-for-meizu.jpg&ehk=BGgL4g9sk2uysoCXn6sslXVXvfyXDH16ISeI2ZB475o%3d&risl=&pid=ImgRaw&r=0")),
              //   borderRadius: BorderRadius.only(
              //       bottomLeft: Radius.circular(kVideoRadius),
              //       bottomRight: Radius.circular(kVideoRadius)),
              // ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 30,
              child: Container(
                height: 50,
                color: const Color.fromRGBO(0, 0, 0, 0.1),
                width: context.width,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        LiveRemark(),
                        SizedBox(
                          width: 30,
                        ),
                        // StreamBuilder(
                        //   stream: bloc.service.viewCount,
                        //   builder: (_, snap) {
                        //     return LiveCount(
                        //       count: snap.data?.toString() ?? '0',
                        //     );
                        //   },
                        // ),
                        LiveCount(),
                      ],
                    ),
                    LiveViewToggle(),
                    // LiveViewToggle(),
                  ],
                ),
              ),
            ),
            const Positioned(bottom: 10, child: CommentSection())
          ],
        );
      }),
    );
  }
}

class LiveCount extends StatelessWidget {
  const LiveCount({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(
          Icons.person,
          size: 16,
          color: Colors.white,
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "2.5 k",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class LiveRemark extends StatelessWidget {
  const LiveRemark({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Color.fromARGB(255, 141, 18, 18)),
        ),
        const Text(
          "Live",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ],
    );
  }
}

class ViewPortBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) fullscreen;
  final Widget Function(BuildContext context) minimized;
  const ViewPortBuilder({
    super.key,
    required this.fullscreen,
    required this.minimized,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveViewCubit, LiveViewBaseState>(builder: (_, state) {
      print("state is $state");
      if (state is MaximizedScreen) return fullscreen(context);
      return minimized(context);
    });
  }
}

class LiveViewToggle extends StatelessWidget {
  const LiveViewToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveViewCubit, LiveViewBaseState>(builder: (_, state) {
      return IconButton(
        onPressed: () {
          context.read<LiveViewCubit>().toggle();
        },
        icon: Icon(
          state is MinimizedScreen
              ? Icons.view_in_ar_outlined
              : Icons.compare_arrows,
          color: Colors.white,
        ),
      );
    });
  }
}

class CommentSection extends StatelessWidget {
  final Widget Function(BuildContext, Comments)? builders;

  const CommentSection({super.key, this.builders});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: context.height * 0.45,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(kVideoRadius),
          topRight: Radius.circular(kVideoRadius),
        ),
        color: Colors.black.withOpacity(0.7),
      ),
      child: Stack(
        children: [
          LiveComment(
            builder: builders != null
                ? builders!
                : (_, comment) {
                    return CommentBox(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      comment: comment,
                    );
                  },
          ),
          Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: TextField(
                minLines: 1,
                maxLength: 3,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(color: Colors.white, letterSpacing: 1.2),
                decoration: InputDecoration(
                  hintText: "Type here ...",
                  hintStyle: const TextStyle(
                    color: Colors.white60,
                    fontWeight: FontWeight.w500,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                  ),
                  contentPadding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  fillColor: kBgColor.withOpacity(0.8),
                  filled: true,
                  border: border,
                  focusedBorder: border,
                ),
              ))
        ],
      ),
    );
  }
}

class CommentBox extends StatelessWidget {
  final Comments comment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor, foregroundColor;
  final BorderRadiusGeometry? borderRadius;
  const CommentBox({
    super.key,
    required this.comment,
    this.backgroundColor,
    this.foregroundColor,
    this.margin,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = foregroundColor ?? Colors.white;
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: color,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Person ${comment.createdAt}",
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              comment.message,
              style: TextStyle(
                color: color,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LiveStreamVideoView extends StatefulWidget {
  final AgoraBaseService service;
  const LiveStreamVideoView({super.key, required this.service});

  @override
  State<LiveStreamVideoView> createState() => _LiveStreamVideoViewState();
}

class _LiveStreamVideoViewState extends State<LiveStreamVideoView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  void dispose() {
    widget.service.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> init() async {
    await widget.service.init();
    widget.service.handler = AgoraHandler.fast();
    // widget.service.handler = AgoraHandler(
    //     onError: (msg, str) {},
    //     onLeaveChannel: (connection, status) {},
    //     onRejoinChannelSuccess: (connection, _) {},
    //     onUserJoined: (con, remoteUid, _) {},
    //     onUserOffline: (con, remoteuid, _) {},
    //     onJoinChannelSuccess: (con, _) {},
    //     onTokenPrivilegeWillExpire: (con, token) {});
    await widget.service.ready();
    await widget.service.live("lkjkj", "test");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.service.onLive.stream,
        builder: (_, snap) {
          if (widget.service is AgoraHostService) {
            return AgoraVideoView(
              onAgoraVideoViewCreated: (uid) => print("aavvc is $uid"),
              controller: widget.service.controller,
            );
          }
          if (widget.service.connection != null) {
            return AgoraVideoView(
              onAgoraVideoViewCreated: (uid) => print("aavvc is $uid"),
              controller: widget.service.controller,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
