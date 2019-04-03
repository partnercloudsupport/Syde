import 'dart:async';




class HomePageBloc{


  StreamController<int> controller = StreamController();


  Sink<int> get tabPosition=> controller.sink;
  Stream<int> get stream=> controller.stream;



  dispose()=>controller.close();

}



HomePageBloc homePageBloc = HomePageBloc();