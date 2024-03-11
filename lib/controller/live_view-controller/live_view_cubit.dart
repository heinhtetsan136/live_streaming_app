import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/live_view-controller/live_view_state.dart';

class LiveViewCubit extends Cubit<LiveViewBaseState> {
  LiveViewCubit() : super(const MinimizedScreen());
  void toggle() {
    print("screen is $state");
    emit(state is MinimizedScreen
        ? const MaximizedScreen()
        : const MinimizedScreen());
  }
}
