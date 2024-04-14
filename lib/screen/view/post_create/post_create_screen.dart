import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/live_stream_controller/base/live_stream_base_event.dart';
import 'package:live_streaming/controller/live_stream_controller/base/live_stream_base_state.dart';
import 'package:live_streaming/controller/live_stream_controller/impl/host_controller/live_stream_host_bloc.dart';
import 'package:live_streaming/controller/live_stream_controller/impl/host_controller/live_stream_host_event.dart';
import 'package:live_streaming/controller/live_stream_controller/impl/host_controller/live_stream_host_state.dart';
import 'package:live_streaming/router/route_name.dart';
import 'package:live_streaming/util/dialog/errror_dialog.dart';
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
        centerTitle: true,
        title: const Text("Live"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: BlocBuilder<LiveStreamHostBloc, LiveStreamBaseState>(
                builder: (_, state) {
              if (state is LiveStreamContentCreateInitalState) {
                return const SizedBox();
              }
              return ElevatedButton(
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
              );
            }),
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
              if (state is LiveStreamContentCreateLoadingState ||
                  state is LiveStreamContentCreateInitalState) {
                return Container(
                  width: context.width,
                  height: context.height,
                  alignment: Alignment.center,
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  child: const CupertinoActivityIndicator(),
                );
              }
              return const SizedBox();
            },
            listener: (_, state) async {
              if (state is LiveStreamContentCreateErrorState) {
                final result = await showErrorDialog<bool>(
                    "failed to live", state.message,
                    action: [
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: const MaterialStatePropertyAll(
                                Colors.deepOrange),
                            foregroundColor:
                                const MaterialStatePropertyAll(Colors.white),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                          ),
                          onPressed: () {
                            StarlightUtils.pop(result: false);
                            liveStreamBloc
                                .add(const LiveStreamSocketConnectEvent());
                          },
                          child: const Text("Retry"))
                    ],
                    defaultActionButtonLabel: "Back",
                    showdefaultActionOnRight: false);
                // Fluttertoast.showToast(msg: state.message);
                // return;

                print("quick is ${result.data}");
                if (result.data is Quit) {
                  StarlightUtils.pop();
                }
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
