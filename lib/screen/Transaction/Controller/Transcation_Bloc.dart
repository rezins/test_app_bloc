import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app_bloc/db/DatabaseServices.dart';
import 'package:test_app_bloc/screen/Transaction/Controller/Transaction_Event.dart';
import 'package:test_app_bloc/screen/Transaction/Controller/Transcation_State.dart';

class Transcation_Bloc extends Bloc<Transaction_Event, Transcation_State>{

  Transcation_Bloc(Transcation_State initialState) : super(initialState);

  @override
  Stream<Transcation_State> mapEventToState(Transaction_Event event)async* {
    // TODO: implement mapEventToState

    if(event is InsertTransaction){
      await DatabaseServices.db.insertTrc(event.trc);
    }

    if(event is UpdateTranscation){
      await DatabaseServices.db.UpdateTrc(event.trc, event.id);
    }

    if(event is DeleteTranscation){
      await DatabaseServices.db.deleteTrc(event.id);
    }

  }




}