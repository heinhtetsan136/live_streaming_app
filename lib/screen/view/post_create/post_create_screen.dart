import 'package:flutter/material.dart';

class PostCreateScreen extends StatelessWidget {
  const PostCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
              // onPressed: () {
              //   liveStreamBloc.add(const LiveStreamContentCreateEvent());
              // },
              child: const Text("Start Live"),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          TextFormField(
            // controller: liveStreamBloc.controller,
            // focusNode: liveStreamBloc.focusNode,
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
          // BlocConsumer<LiveStreamHostBloc, LiveStreamBaseState>(
          //   builder: (_, state) {
          //     if (state is LiveStreamContentCreateLoadingState) {
          //       return const Center(
          //         child: CupertinoActivityIndicator(),
          //       );
          //     }
          //     return const SizedBox();
          //   },
          //   listener: (_, state) {
          //     if (state is LiveStreamContentCreateErrorState) {
          //       Fluttertoast.showToast(msg: state.message);
          //       return;
          //     }
          //     if (state is LiveStreamContentCreateSuccessState) {
          //       StarlightUtils.pushNamed(
          //         RouteNames.host,
          //         arguments: liveStreamBloc,
          //       );
          //     }
          //   },
          // )
        ],
      ),
    );
  }
}
