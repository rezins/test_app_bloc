import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_app_bloc/screen/Dashboard/Controller/Dahsboard_Event.dart';
import 'package:test_app_bloc/screen/Dashboard/Controller/Dashboard_Bloc.dart';
import 'package:test_app_bloc/screen/Dashboard/Controller/Dashboard_State.dart';
import 'package:test_app_bloc/screen/Transaction/Widget/Transaction.dart';

class Dashboard extends StatelessWidget {

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<Dashboard_Bloc>(
      create: (context) => Dashboard_Bloc(GetDataInitial()),
      child: BlocBuilder<Dashboard_Bloc, Dashbaord_State>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                    'Expanse Manager'
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: ()async{
                  await Navigator.of(context).push(MaterialPageRoute(builder: (context) => Transaction(trcType: 'Add', model: null,),));
                  BlocProvider.of<Dashboard_Bloc>(context).add(DashboardDataEvent());
                },
                child: Center(
                  child: Icon(Icons.add, size: 30,),
                ),
              ),
              body: SingleChildScrollView(
                child: Builder(
                  // ignore: missing_return
                  builder: (_) {
                    if(state is GetDataInitial){
                      BlocProvider.of<Dashboard_Bloc>(context).add(DashboardDataEvent());
                    }else if(state is GetDataLoading){
                      return Center(child: CircularProgressIndicator(),);
                    }else if(state is GetDataSuccess){
                      return Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 60,
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
                              child: Center(
                                  child: Text(
                                    'Balanced: ' + NumberFormat.currency(locale: 'id', name: 'IDR'+' ',).format(
                                        state.balanced),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 20
                                    ),
                                  )
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Scrollbar(
                              controller: _scrollController,
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: state.list.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await Navigator.of(context).push(MaterialPageRoute(builder: (context) => Transaction(trcType: 'Update', model: state.list[index],),));
                                      BlocProvider.of<Dashboard_Bloc>(context).add(DashboardDataEvent());
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: 100,
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
                                            flex: 1,
                                            child: Container(
                                              child: state.list[index].transcation_type == "Expense" ? Icon(Icons.arrow_upward, color: Colors.green,size: 40,) : Icon(Icons.arrow_downward, color: Colors.red,size: 40,),
                                              //child: Icon(Icons.arrow_upward, color: Colors.green,size: 40,),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    NumberFormat.currency(locale: 'id', name: 'IDR'+' ',).format(state.list[index].ammount),
                                                    //snapshot.data[index].ammount),
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  Text(
                                                    state.list[index].category,//snapshot.data[index].category,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    state.list[index].description,//snapshot.data[index].description,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              padding: EdgeInsets.only(right: 10),
                                              child: Text(
                                                state.list[index].transcation_date,//snapshot.data[index].transcation_date,
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      );
                    }else if(state is GetDataError){
                      return Center(child: Text(state.message),);
                    }
                    return Container();
                  },
                ),
              )
          );
        },
      ),
    );
  }
}
