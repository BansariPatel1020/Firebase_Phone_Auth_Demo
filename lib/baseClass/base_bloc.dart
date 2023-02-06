import 'package:rxdart/rxdart.dart';

abstract class BaseBloc {
  BehaviorSubject<String> errorSubject = BehaviorSubject<String>();
  BehaviorSubject<bool> isLoading = BehaviorSubject<bool>();

  void dispose() {
    isLoading.close();
    errorSubject.close();
  }
}

