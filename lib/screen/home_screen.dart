import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/notes_model.dart';
import '../resource/color.dart';
import '../resource/strings.dart';
import '../resource/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>with SingleTickerProviderStateMixin {
  final titleController = TextEditingController();
  List<bool> checkedList = [];
  final descriptionController = TextEditingController();
  final duedateController = TextEditingController();
  var box = Hive.box<NoteModel>('notes');
  ValueNotifier<List<NoteModel>> data = ValueNotifier([]);
  List<NoteModel> items = [];
  List<NoteModel>mylist= [];
  List<NoteModel> completed = [];
  late TabController _tabController;
  int? selected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    data.value = box.values.toList().cast<NoteModel>();
    mylist = data.value;
    items = data.value;
    _tabController = TabController(length: 2, vsync: this);
    checkedList = List<bool>.filled(mylist.length, false);
    print('hhh${mylist.length}');
  }

  Future<void> getupdateData() async {
    data.value = box.values.toList().cast<NoteModel>();
    items = data.value;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

          title: Text( 'TaskList :',
            style: Styles.titlestyle,)
      ),
      body: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 19,
            ),
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    // border: Border.all(color: AppColors.grey),
                      color: AppColors.specialist_color,
                      borderRadius: BorderRadius.circular(8)),
                  child: TabBar(
                    controller: _tabController,
                    //indicatorColor: Colors.transparent,
                    dividerColor: Colors.transparent,
                    labelColor: AppColors.white,
                    unselectedLabelColor: AppColors.black,

                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: AppColors.blue,
                    ),
                    tabs: [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            Strings.pending,
                            style: Styles.tab_barstyle,
                          ),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(Strings.completed,
                              style: Styles.tab_barstyle),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ValueListenableBuilder<List<NoteModel>>(
                    valueListenable: data,

                    builder: (context, box, _) {

                      return data.value.isNotEmpty? ListView.builder(
                        //reverse: true,
                        shrinkWrap: true,
                        itemCount: mylist.length,
                        itemBuilder: (context, index) {
                          return  CheckboxListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(mylist[index].title.toString().toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(mylist[index].description.toString()),
                                Text(mylist[index].duedate),
                              ],),

                            value: checkedList[index], // Current checked state
                            onChanged: (bool? value) {
                              setState(() {
                                checkedList[index] = value!; // Update the checked state

                                // Add or remove the item from selectedItems
                                if (value) {
                                  completed.add(mylist[index]);
                                } else {
                                  completed.remove(mylist[index]);
                                }
                              });
                            },
                          );

                        },
                      ):
                      Container(

                          color: AppColors.grey,

                          child:
                          Center(child: Text("No Record",textAlign:TextAlign.center))


                      );
                    },
                  ),
                  ValueListenableBuilder<List<NoteModel>>(
                    valueListenable: data,
                    builder: (context, box, _) {

                      return data.value.isNotEmpty?ListView.builder(
                        //reverse: true,
                        shrinkWrap: true,
                        itemCount:completed.length,
                        //  itemCount: data.value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                              data.value[index].title.toString().toUpperCase()),
                                        ],
                                      ),
                                      Text(data.value[index].description
                                          .toString()),
                                      Text(data.value[index].duedate
                                          .toString()),
                                    ]),
                              ),
                            ),
                          );
                        },
                      ):
                      Container(
                          color: AppColors.grey,
                          child: Center(child: Text("No Record",textAlign:TextAlign.center))


                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),



    );
  }

}