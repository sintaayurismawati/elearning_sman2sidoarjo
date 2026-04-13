import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'landing_page_state.dart';

class LandingPageCubit extends Cubit<LandingPageState> {
  LandingPageCubit() : super(LandingPageInitial());
}
