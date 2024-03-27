import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:live_streaming/controller/live_stream_controller/live_stream_bloc.dart';
import 'package:live_streaming/controller/live_stream_controller/live_stream_event.dart';
import 'package:live_streaming/controller/live_stream_controller/live_stream_state.dart';
import 'package:live_streaming/router/route_name.dart';
import 'package:logger/logger.dart';
import 'package:starlight_utils/starlight_utils.dart';

class PostCreateScreen extends StatelessWidget {
  static final _logger = Logger();
  const PostCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LiveStreamHostBloc liveStreamBloc =
        context.read<LiveStreamHostBloc>();
    // final LiveStreamHostBloc liveStreamBloc =
    //     context.read<LiveStreamHostBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: const ButtonStyle(
                elevation: MaterialStatePropertyAll(0.4),
                padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 5)),
                minimumSize: MaterialStatePropertyAll(
                  Size(80, 35),
                ),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(),
                ),
              ),
              onPressed: () {
                liveStreamBloc.add(const LiveStreamContentCreateEvent());
              },
              child: const Text("Start Live"),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          TextFormField(
            controller: liveStreamBloc.controller,
            focusNode: liveStreamBloc.focusNode,
            expands: true,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
              hintText: "Type here...",
            ),
          ),
          BlocConsumer<LiveStreamHostBloc, LiveStreamBaseState>(
            builder: (_, state) {
              _logger.i(state);
              if (state is LiveStreamContentCreateLoadingState) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              return const SizedBox();
            },
            listener: (_, state) {
              if (state is LiveStreamContentCreateErrorState) {
                Fluttertoast.showToast(msg: state.message);
                return;
              }
              if (state is LiveStreamContentCreateSuccessState) {
                StarlightUtils.pushNamed(
                  RouteNames.host,
                  arguments: liveStreamBloc,
                );
              }
            },
          )
        ],
      ),
    );
  }
}
