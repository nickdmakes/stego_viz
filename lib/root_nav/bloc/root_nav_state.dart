part of 'root_nav_cubit.dart';

class RootNavState extends Equatable {
  const RootNavState({
    this.navIndex = 0,
  });

  final int navIndex;

  @override
  List<Object> get props => [navIndex];

  RootNavState copyWith({
    int? navIndex,
  }) {
    return RootNavState(
      navIndex: navIndex ?? this.navIndex,
    );
  }
}
