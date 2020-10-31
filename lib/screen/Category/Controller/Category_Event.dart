
import 'package:equatable/equatable.dart';

abstract class Category_Event extends Equatable{}

class CategoryEventGetData extends Category_Event{
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class InsertCategory extends Category_Event{

  final String category;

  InsertCategory(this.category);

  @override
  // TODO: implement props
  List<Object> get props => [category];

}

class AddCategory extends Category_Event{
  @override
  // TODO: implement props
  List<Object> get props => null;

}

class DeleteCategory extends Category_Event{

  final int idx;

  DeleteCategory(this.idx);

  @override
  // TODO: implement props
  List<Object> get props => [idx];
}