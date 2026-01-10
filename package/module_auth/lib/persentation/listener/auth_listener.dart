import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthListener extends ChangeNotifier {
  late StreamSubscription _stream;
  AuthListener(BlocBase bloc){
   _stream =  bloc.stream.listen((event) {
      return notifyListeners();
    },);
  }
  @override
  void dispose() {
    _stream.cancel();
    super.dispose();
  }
  
}