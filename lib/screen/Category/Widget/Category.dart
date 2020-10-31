import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app_bloc/screen/Category/Controller/Category_Bloc.dart';
import 'package:test_app_bloc/screen/Category/Controller/Category_Event.dart';
import 'package:test_app_bloc/screen/Category/Controller/Category_State.dart';

class Category extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<Category_Bloc>(
      create: (context) => Category_Bloc(GetDataInitial()),
      child: BlocBuilder<Category_Bloc, Category_State>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Create Category',
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                // ignore: close_sinks
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text('Create Category',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                        ),
                      ),
                      content: Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: "Category Name"),
                          onSaved: (val) => BlocProvider.of<Category_Bloc>(context).add(InsertCategory(val)),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Category Name cannot be blank';
                            }
                            return null;
                          },
                        ),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        new FlatButton(
                          child: new Text('Save'),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              BlocProvider.of<Category_Bloc>(context).add(AddCategory());
                              BlocProvider.of<Category_Bloc>(context).add(CategoryEventGetData());
                              Navigator.of(context).pop();
                            }
                          },
                        )
                      ],
                    );
                  },
                );
              },
              child: Center(
                child: Icon(Icons.add, size: 30,),
              ),
            ),
            body: Builder(
              // ignore: missing_return
              builder: (_) {
                if(state is GetDataInitial){
                  BlocProvider.of<Category_Bloc>(context).add(CategoryEventGetData());
                }else if(state is GetDataLoading){
                  return Center(child: CircularProgressIndicator(),);
                }else if(state is GetDataSuccess){
                  return ListView.builder(
                    itemCount: state.list.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          Navigator.pop(context, state.list[index].category_name);
                        },
                        child: Container(
                          height: 70,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  spreadRadius: 2,
                                  blurRadius: 2
                              )
                            ],
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Container(
                                    child: Text(
                                      state.list[index].category_name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: GestureDetector(
                                    onTap: () async{
                                      await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return BlocProvider<Category_Bloc>(
                                            create: (context) => Category_Bloc(GetDataInitial()),
                                            child: BlocBuilder<Category_Bloc,Category_State>(
                                              builder: (context, state1) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Warning',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  content: Text(
                                                      'Are you sure want to delete this item?'
                                                  ),
                                                  actions: <Widget>[
                                                    new FlatButton(
                                                      child: new Text('No'),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    new FlatButton(
                                                      child: new Text('Yes'),
                                                      onPressed: () {
                                                        BlocProvider.of<Category_Bloc>(context).add(DeleteCategory(state.list[index].id));
                                                        Navigator.of(context).pop();
                                                      },
                                                    )
                                                  ],
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                      BlocProvider.of<Category_Bloc>(context).add(CategoryEventGetData());
                                    },
                                    child: Center(
                                      child: Icon(Icons.delete, color: Colors.grey,),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }else if(state is GetDataError){
                  return Center(child: Text(state.message),);
                }
                return Container();
              },
            ),
          );
        },
      )
    );
  }

  Widget _alertAction(BuildContext context){

  }
}
