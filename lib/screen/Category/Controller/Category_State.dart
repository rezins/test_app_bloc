import 'package:equatable/equatable.dart';
import 'package:test_app_bloc/db/CategoryModel.dart';

abstract class Category_State extends Equatable{

  @override
  // TODO: implement props
  List<Object> get props => [];

}

class GetDataInitial extends Category_State{}

class GetDataLoading extends Category_State{}

class GetDataError extends Category_State{
  final String message;

  GetDataError(this.message);
  
  @override
  // TODO: implement props
  List<Object> get props => super.props..add(message);
}

class GetDataSuccess extends Category_State{

  final List<CategoryModel> list;

  GetDataSuccess(this.list);

  @override
  // TODO: implement props
  List<Object> get props => super.props..add(list);
  
}