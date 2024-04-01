import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'root_nav_state.dart';

class RootNavCubit extends Cubit<RootNavState> {
  RootNavCubit() : super(const RootNavState());

  void navIndexChanged(int value) {
    emit(
      state.copyWith(
        navIndex: value,
      ),
    );
  }
}
