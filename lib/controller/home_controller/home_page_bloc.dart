import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_streaming/controller/home_controller/home_page_event.dart';

class HomePageBloc extends Bloc<HomePageEvent, int> {
  final PageController controller;
  static const Duration _duration = Duration(milliseconds: 300);
  static const Curve _curve = Curves.linear;
  HomePageBloc()
      : controller = PageController(),
        super(0) {
    on<gotoHomePage>(
      (event, emit) {
        emit(0);
        controller.animateToPage(0, duration: _duration, curve: _curve);
      },
    );
    on<gotoSearchScreen>(
      (event, emit) {
        emit(1);
        controller.animateToPage(1, duration: _duration, curve: _curve);
      },
    );
    on<gotoProfile>(
      (event, emit) {
        emit(2);
        controller.animateToPage(2, duration: _duration, curve: _curve);
      },
    );
  }
  HomePageEvent activate(int value) {
    switch (value) {
      case 0:
        return const gotoHomePage();

      case 1:
        return const gotoSearchScreen();
      default:
        return const gotoProfile();
    }
  }

  @override
  Future<void> close() {
    controller.dispose();
    // TODO: implement close
    return super.close();
  }
}
