import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'list_pesanan_event.dart';
part 'list_pesanan_state.dart';

class ListPesananBloc extends Bloc<ListPesananEvent, ListPesananState> {
  ListPesananBloc() : super(ListPesananInitial()) {
    on<ListPesananEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
