import 'dart:async';

class HomePageBloc {

  //stream controller
  StreamController<int> controller = StreamController<int>.broadcast();


  //sink to accept tab position
  Sink<int> get tabPosition => controller.sink;

  //stream
  Stream<int> get stream => controller.stream;

  //dispose controller
  dispose() => controller.close();
}

HomePageBloc homePageBloc = HomePageBloc();
