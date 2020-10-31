import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app_bloc/db/CategoryModel.dart';
import 'package:test_app_bloc/db/DatabaseServices.dart';
import 'package:test_app_bloc/screen/Category/Controller/Category_Event.dart';
import 'package:test_app_bloc/screen/Category/Controller/Category_State.dart';

class Category_Bloc extends Bloc<Category_Event, Category_State>{
  Category_Bloc(Category_State initialState) : super(initialState);

  String _categoryName;
  List<CategoryModel> _list;

  @override
  Stream<Category_State> mapEventToState(Category_Event event)async* {

    if(event is CategoryEventGetData){
      yield GetDataLoading();
      try{
        _list = await DatabaseServices.db.getCat();
        if(_list == null){
          _list = new List<CategoryModel>();
        }
        yield GetDataSuccess(_list);
      }catch(e){
        yield GetDataError(e.toString());
      }
    }

    if(event is InsertCategory){
      _categoryName = event.category;
    }

    if(event is AddCategory){
      CategoryModel tmp = CategoryModel(
          category_name: _categoryName
      );
      await DatabaseServices.db.insertCat(tmp);
    }

    if(event is DeleteCategory){
      await DatabaseServices.db.deleteCat(event.idx);
    }
  }


}

