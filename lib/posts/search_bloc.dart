import 'package:flutter/widgets.dart';
import 'package:live_streaming/locator.dart';
import 'package:live_streaming/posts/post_bloc.dart';
import 'package:live_streaming/service/post/post_service.dart';

class SearchBloc extends PostBaseBloc {
  TextEditingController queryC = TextEditingController();
  FocusNode queryF = FocusNode();
  SearchBloc() : super(Locator<SearchPostService>());
  @override
  Future<void> close() {
    queryC.dispose();
    queryF.dispose();
    // TODO: implement close
    return super.close();
  }
}
