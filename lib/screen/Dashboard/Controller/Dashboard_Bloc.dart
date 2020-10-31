import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app_bloc/db/DatabaseServices.dart';
import 'package:test_app_bloc/db/TransactionModel.dart';
import 'package:test_app_bloc/screen/Dashboard/Controller/Dahsboard_Event.dart';
import 'package:test_app_bloc/screen/Dashboard/Controller/Dashboard_State.dart';

class Dashboard_Bloc extends Bloc<Dashbaord_Event, Dashbaord_State>{
  Dashboard_Bloc(Dashbaord_State initialState) : super(initialState);

  @override
  Stream<Dashbaord_State> mapEventToState(Dashbaord_Event event) async*{

    List<TranscationModel> _list;
    int _balanced = 0;

    if(event is DashboardDataEvent){
      yield GetDataLoading();
      try{
        _list = await DatabaseServices.db.getTrc();
        if(_list == null){
          _list = new List<TranscationModel>();
        }else{
          _list.forEach((item) {
            if(item.transcation_type == 'Expense'){
              _balanced -= item.ammount;
            }else{
              _balanced += item.ammount;
            }
          });
        }
        yield GetDataSuccess(_list, _balanced);
      }catch(e){
        yield GetDataError(e.toString());
      }
    }

  }

}