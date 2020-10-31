import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_app_bloc/db/TransactionModel.dart';
import 'package:test_app_bloc/screen/Category/Widget/Category.dart';
import 'package:test_app_bloc/screen/Transaction/Controller/Transaction_Event.dart';
import 'package:test_app_bloc/screen/Transaction/Controller/Transcation_Bloc.dart';
import 'package:test_app_bloc/screen/Transaction/Controller/Transcation_State.dart';

class Transaction extends StatefulWidget {

  TranscationModel model;
  String trcType;

  Transaction({Key key, this.trcType, this.model}) : super(key : key);

  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _typeTrc = widget.trcType;
    _trc = widget.model;
    if(_trc != null){
      _dateController.text = _trc.transcation_date;
      _categoryController.text = _trc.category;
      _ammountController.text =  _trc.ammount.toString();
      _desciprtionController.text = _trc.description;
    }
  }

  final _formKey = GlobalKey<FormState>();

  String _typeTrc;
  TranscationModel _trc;

  TextEditingController _dateController = new TextEditingController();
  TextEditingController _categoryController = new TextEditingController();
  TextEditingController _ammountController = new TextEditingController();
  TextEditingController _desciprtionController = new TextEditingController();

  bool trc_type_exp = true, trc_type_inc = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<Transcation_Bloc>(
      create: (context) => Transcation_Bloc(GetDataInitial()),
      child: BlocBuilder<Transcation_Bloc, Transcation_State>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  _typeTrc == 'Add' ? 'Create Transcation' : 'Update Transcation',
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue)
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      trc_type_exp = true;
                                      trc_type_inc = false;
                                    });
                                  },
                                  child: Container(
                                    child: Container(
                                      color: trc_type_exp ? Colors.blue : Colors.white,
                                      child: Center(
                                        child: Text('EXPENSE',
                                          style: TextStyle(
                                            color: trc_type_exp ? Colors.white : Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        trc_type_exp = false;
                                        trc_type_inc = true;
                                      });
                                    },
                                    child: Container(
                                      child: Container(
                                        color: trc_type_inc ? Colors.blue : Colors.white,
                                        child: Center(
                                          child: Text(
                                            'INCOME',
                                            style: TextStyle(
                                              color: trc_type_inc ?Colors.white : Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              )
                            ],
                          )
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                onTap: () async {
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  DateTime date = DateTime(1900);
                                  date = await showDatePicker(
                                      context: context,
                                      initialDate:DateTime.now(),
                                      firstDate:DateTime(1900),
                                      lastDate: DateTime(2100));
                                  if(date!=null){
                                    String _tmpDate = DateFormat('dd/MM/yyyy').format(date);
                                    _dateController.text = _tmpDate;
                                  }
                                },
                                controller: _dateController,
                                decoration: InputDecoration(
                                  labelText: 'Transaction Date',
                                ),
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return 'Transaction Date must filled';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                onTap: ()async{
                                  var categorySelected = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => Category(),));
                                  _categoryController.text = categorySelected;
                                },
                                controller: _categoryController,
                                decoration: InputDecoration(
                                  labelText: 'Select Category',
                                ),
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return 'Select Category cannot be blank';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _ammountController,
                                decoration: InputDecoration(
                                  labelText: 'Ammount',
                                ),
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return 'Ammount cannot be blank';
                                  }
                                  return null;
                                },
                              )
                              ,
                              TextFormField(
                                controller: _desciprtionController,
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                ),
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return 'Description cannot be blank';
                                  }
                                  return null;
                                },
                              ),
                              _typeTrc == 'Add' ? Container(
                                height: 75,
                                padding: EdgeInsets.only(top: 20),
                                child: Container(
                                  child: FlatButton(
                                      onPressed: (){
                                        if (_formKey.currentState.validate()) {
                                          _formKey.currentState.save();
                                          TranscationModel trc = new TranscationModel(
                                              transcation_type: trc_type_exp ? 'Expense' : 'Income',
                                              transcation_date: _dateController.value.text,
                                              category: _dateController.value.text,
                                              ammount: int.parse(_ammountController.value.text),
                                              description: _desciprtionController.value.text
                                          );
                                          BlocProvider.of<Transcation_Bloc>(context).add(InsertTransaction(trc));
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      color: Colors.blue,
                                      child: Center(
                                        child: Text(
                                          'Save',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                              ) : Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 75,
                                          padding: EdgeInsets.only(top: 20),
                                          child: Container(
                                            child: FlatButton(
                                                onPressed: (){
                                                  if (_formKey.currentState.validate()) {
                                                    _formKey.currentState.save();
                                                    TranscationModel trc = new TranscationModel(
                                                        transcation_type: trc_type_exp ? 'Expense' : 'Income',
                                                        transcation_date: _dateController.value.text,
                                                        category: _dateController.value.text,
                                                        ammount: int.parse(_ammountController.value.text),
                                                        description: _desciprtionController.value.text
                                                    );
                                                    BlocProvider.of<Transcation_Bloc>(context).add(UpdateTranscation(trc, _trc.id));
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                color: Colors.blue,
                                                child: Center(
                                                  child: Text(
                                                    'Save',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18
                                                    ),
                                                  ),
                                                )
                                            ),
                                          ),
                                        )
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: 75,
                                        padding: EdgeInsets.only(top: 20),
                                        child: Container(
                                          child: FlatButton(
                                              onPressed: (){

                                                showDialog(
                                                  context: context,
                                                  builder: (_) {
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
                                                            BlocProvider.of<Transcation_Bloc>(context).add(DeleteTranscation(_trc.id));
                                                            Navigator.of(context).pop();
                                                            Navigator.of(context).pop();
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              color: Colors.red,
                                              child: Center(
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18
                                                  ),
                                                ),
                                              )
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
          );
        },
      ),
    );
  }
}

