import 'package:flutter_bloc/flutter_bloc.dart';

class DemoToggleCubit extends Cubit<bool> {
  DemoToggleCubit() : super(false);

  void toggle() => emit(!state);
}
