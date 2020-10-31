import 'package:equatable/equatable.dart';
import 'package:test_app_bloc/db/TransactionModel.dart';

abstract class Dashbaord_State extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetDataInitial extends Dashbaord_State{}

class GetDataLoading extends Dashbaord_State{}

class GetDataError extends Dashbaord_State{
  final String message;

  GetDataError(this.message);

  @override
  // TODO: implement props
  List<Object> get props => super.props..add(message);
}

class GetDataSuccess extends Dashbaord_State{

  final List<TranscationModel> list;
  final int balanced;

  GetDataSuccess(this.list, this.balanced);

  @override
  // TODO: implement props
  List<Object> get props => super.props..addAll([list, balanced]);

}