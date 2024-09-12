import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_crud/custom/button.dart';
import 'package:hive_crud/resource/color.dart';
import 'package:hive_crud/resource/styles.dart';

import '../boxes/boxes.dart';
import '../custom/textfeild.dart';
import '../models/notes_model.dart';
import '../resource/strings.dart';
import 'home_screen.dart';



class ShowData extends StatefulWidget {
  const ShowData({super.key});

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  final titleController = TextEditingController();
  List<bool> checkedList = [];
  final descriptionController = TextEditingController();
  final duedateController = TextEditingController();
  var box = Hive.box<NoteModel>('notes');
  ValueNotifier<List<NoteModel>> data = ValueNotifier([]);
  List<NoteModel> items = [];
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    data.value = box.values.toList().cast<NoteModel>();
    items = data.value;
  }
  Future<void> getupdateData() async {
    data.value = box.values.toList().cast<NoteModel>();
    items = data.value;
  }
  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field is not empty';
    }

    return null;
  }


  Future<void> getItemsByName(String name) async {
    if (name.isEmpty) {
      data.value = items;
    } else {
      print(name);
      try {
        data.value = box.values
            .where((item) => item.title.contains(name))
            .toList()
            .cast<NoteModel>();

        print('nameeee${data.value.length}');
      }
      //await box.close();}

      catch (e) {
        print('exception catch$e');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${Strings.title} :',
          style: Styles.titlestyle),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonWidget(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
            }, buttonText: Strings.viewtitle,buttonColor: AppColors.blue,
              textColor: AppColors.white,
              borderRadius: 10,),
          )
        ],),
      body:  ValueListenableBuilder<List<NoteModel>>(
        valueListenable: data,
        builder: (context, box, _) {

          return Column(
            children: [
              SizedBox(height: 20,),
              Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.kcontentColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 4,
                      child: TextField(
                        onChanged: (value) {
                          print(value);

                          getItemsByName(value);
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: "Search...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      height: 25,
                      width: 1.5,
                      color: Colors.grey,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: data.value.isNotEmpty?ListView.builder(
                    //reverse: true,
                    shrinkWrap: true,
                    itemCount:data.value.length,
                    //  itemCount: data.value.length,
                    itemBuilder: (context, index) {
                      return  Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: (){
                            _editDialog(
                                data.value[index],
                                data.value[index].title.toString(),
                                data.value[index].description.toString());
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.value[index].title.toString().toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      ' Description: ${data.value[index].description.toString()}',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_month, size: 18.0, color: Colors.grey[600]),
                                        SizedBox(width: 4.0),
                                        Text(
                                          ':${data.value[index].duedate.toString()}',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  InkWell(
                                      onTap: (){
                                        delete(data.value[index]);
                                        getupdateData();
                                      },
                                      child: Icon(Icons.delete,color: Colors.red,)),
                                  SizedBox(height: 16.0),
                                  InkWell(
                                    onTap: (){
                                      _editDialog(
                                          data.value[index],
                                          data.value[index].title.toString(),
                                          data.value[index].description.toString());
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16.0,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ):  Container(

                      color: AppColors.grey,

                      child:
                      Center(child: Text(Strings.noRecord_mes,textAlign:TextAlign.center))


                  )
              ),


            ],
          );
        },
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }





  void delete(NoteModel noteModel) async {
    await noteModel.delete();
    getupdateData();
  }

  Future<void> _editDialog(
      NoteModel noteModel, String title, String description) async {
    titleController.text = title;
    descriptionController.text = description;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Strings.edit_Notes_title),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    hintText: Strings.enter_Title, border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                    hintText: Strings.enter_description,
                    border: OutlineInputBorder()),
              )
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                titleController.text = "";
                descriptionController.text= "";
                duedateController.text ='';
                Navigator.pop(context);
              },
              child: Text(Strings.cancel)),
          TextButton(
              onPressed: () async {
                noteModel.title = titleController.text.toString();
                noteModel.description = descriptionController.text.toString();
                noteModel.save();
                getupdateData();
                titleController.text = "";
                descriptionController.text= "";
                duedateController.text ='';
                Navigator.pop(context);
              },
              child: Text(Strings.edit))
        ],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Strings.add_task_title),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                MyTextField(
                  controller: titleController,
                  type: TextInputType.text,
                  hintText: Strings.enter_Title,
                  onChange: (text) {
                  },
                  obscureText: false,
                  validator: validateField,
                ),
                SizedBox(
                  height: 20,
                ),
                MyTextField(
                  controller: descriptionController,
                  type: TextInputType.text,
                  hintText: Strings.enter_description,
                  onChange: (text) {
                  },
                  obscureText: false,
                  validator: validateField,
                ),
                SizedBox(
                  height: 20,
                ),
                MyTextField(
                  controller: duedateController,
                  type: TextInputType.text,
                  hintText: Strings.enter_dueDAte,
                  onChange: (text) {
                  },
                  obscureText: false,
                ),


              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(Strings.cancel)),
          TextButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                else{
                  final data = NoteModel(
                      duedate: duedateController.text,
                      title: titleController.text,
                      description: descriptionController.text);
                  final box = Boxes.getData();
                  box.add(data);
                  //  data.save();
                  titleController.clear();
                  descriptionController.clear();
                  duedateController.clear();
                  getupdateData();
                  Navigator.pop(context);}
              },
              child: Text(Strings.add))
        ],
      ),
    );
  }
}
