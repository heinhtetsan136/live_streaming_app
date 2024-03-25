import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/live_stream_controller/live_stream_bloc.dart';
import 'package:live_streaming/models/comment.dart';
import 'package:live_streaming/screen/live_stream_screen.dart';
import 'package:live_streaming/screen/view/live_stream_view.dart';
import 'package:live_streaming/service/base/agora_base_service.dart';
import 'package:starlight_utils/starlight_utils.dart';

Widget _builder(BuildContext context, Comments comment) {
  return CommentBox(
    borderRadius: BorderRadius.circular(8),
    comment: comment,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(10),
    backgroundColor: Colors.white.withOpacity(0.8),
    foregroundColor: Colors.black,
  );
}

class LiveStreamFullScreenView extends StatelessWidget {
  final AgoraBaseService service;
  const LiveStreamFullScreenView({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LiveStreamBloc>();
    // final commentHeight = context.height * 0.5;
    final screenWidth = context.width;

    return Stack(
      children: [
        LiveStreamVideo(
          service: service,
        ),
        Positioned(
          left: 20,
          right: 20,
          top: 30,
          child: Container(
            height: 50,
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            width: screenWidth,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // const LiveRemark(),
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
                  ],
                ),
                LiveViewToggle(),
              ],
            ),
          ),
        ),
        // if (service is AgoraHostService)
        //   Positioned(
        //     bottom: 0,
        //     child: SizedBox(
        //       width: screenWidth,
        //       height: commentHeight,
        //       child: const LiveComments(
        //         builder: _builder,
        //       ),
        //     ),
        //   )
        // else
        //   Positioned(
        //     bottom: 0,
        //     child: CommentSection(
        //       builder: _builder,
        //       borderRadius: BorderRadius.zero,
        //       backgroundColor: const Color.fromRGBO(70, 70, 70, 0.1),
        //       commentSectionWidth: screenWidth,
        //       commentSectionHeight: commentHeight,
        //     ),
        //   ),
      ],
    );
  }
}
