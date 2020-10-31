import 'package:equatable/equatable.dart';
import 'package:test_app_bloc/db/TransactionModel.dart';

abstract class Transaction_Event extends Equatable{}

class InsertTransaction extends Transaction_Event{

  final TranscationModel trc;

  InsertTransaction(this.trc);

  @override
  // TODO: implement props
  List<Object> get props => [trc];

}

class DeleteTranscation extends Transaction_Event{

  final int id;

  DeleteTranscation(this.id);

  @override
  // TODO: implement props
  List<Object> get props => [id];

}

class UpdateTranscation extends Transaction_Event{

  final TranscationModel trc;
  final int id;

  UpdateTranscation(this.trc, this.id);

  @override
  // TODO: implement props
  List<Object> get props => [trc];
}