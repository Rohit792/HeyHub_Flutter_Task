import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hayhub_assesment/Model/emojiModel.dart';
import 'package:hayhub_assesment/bloc/emojibock.dart';
import 'package:stream_transform/stream_transform.dart';

class LandingPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HeyHub Flutter Task',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EmogyPage(title: 'HeyHub Flutter Task'),
    );
  }
}

class EmogyPage extends StatefulWidget {
  EmogyPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EmogyPageState createState() => _EmogyPageState();
}

class _EmogyPageState extends State<EmogyPage> {
  List<EmojiModel> listEmoji = [];
  List<EmojiModel> filteredEmojiList = [];
  List<EmojiModel> categoryEmojiList = [];

  List<String> listFrequentlyUsed = [];
  final searchController = TextEditingController();
  StreamController<String> streamController = StreamController();

  @override
  initState() {
    emojiBloc.generateData(context).then((value) {
      print("object $value");

      setState(() {
        listEmoji = value;
        print(listEmoji.length);
        filteredEmojiList.addAll(listEmoji);

        var arrayTemp = [];
        listEmoji.forEach((element) {
          if (!arrayTemp.contains(element.category)) {
            arrayTemp.add(element.category);
          }
        });

        arrayTemp.forEach((elementTemp) {
          final EmojiModel questionOneSectionCategories = listEmoji.firstWhere(
              (element) => elementTemp.toString() == element.category);
          categoryEmojiList.add(questionOneSectionCategories);
          print(
              "SMilleeee $elementTemp - ${questionOneSectionCategories.emoji} - ");
        });
        print("helllooo : $arrayTemp");

        filteredEmojiList.clear();
        listEmoji.forEach((element) {
          if (element.category.toString() ==
              categoryEmojiList[0].category.toString()) {
            filteredEmojiList.add(element);
          }
          setState(() {
            print(filteredEmojiList.length);
          });
        });
        // print(map1.keys);
      });
    });

    streamController.stream
        .transform(debounce(Duration(milliseconds: 400)))
        .listen((s) => _filterValues());
    super.initState();
  }

  _filterValues() {
    setState(() {
      if (searchController.text.length == 0) {
        filteredEmojiList.clear();
        filteredEmojiList.addAll(listEmoji);
      } else {
        filteredEmojiList.clear();
        listEmoji.forEach((element) {
          bool addToFilterList = false;
          if (element.description.contains(searchController.text)) {
            addToFilterList = true;
          }
          element.aliases.forEach((element) {
            if (element.contains(searchController.text)) {
              addToFilterList = true;
            }
          });
          element.tags.forEach((element) {
            if (element.contains(searchController.text)) {
              addToFilterList = true;
            }
          });
          if (addToFilterList) {
            filteredEmojiList.add(element);
          }
        });
      }
    });
    print('filteredEmojiList length ' + filteredEmojiList.length.toString());
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        width: width,
        height: height,
        // color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              emojiMenu(),
              searchBox(),
              frequentlyusedEmoji(),
              Expanded(
                  // padding: EdgeInsets.all(0),
                  flex: 1,
                  child: GridView.count(
                      crossAxisCount: 10,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      children:
                          List.generate(listFrequentlyUsed.length, (index) {
                        return Center(
                          child: frequentlyUsedIcons(index),
                        );
                      }))),
              SizedBox(
                height: 10,
              ),
              gettingWorkDoneEmoji(),
              emojiItems(),
            ],
          ),
        ),
      ),
    );
  }

  Widget emojiMenu() {
    return Container(
      height: 50,
      // color: Colors.red,
      child: Expanded(
        child: GridView.builder(
          itemCount: categoryEmojiList.length,
          scrollDirection: Axis.horizontal,
          physics: ScrollPhysics(),
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Center(
                child: InkWell(
              child: Text(
                categoryEmojiList[index].emoji.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                filteredEmojiList.clear();
                listEmoji.forEach((element) {
                  if (element.category.toString() ==
                      categoryEmojiList[index].category.toString()) {
                    filteredEmojiList.add(element);
                  }
                  setState(() {
                    print(filteredEmojiList.length);
                  });
                });
              },
            ));
          },
        ),
      ),
    );
    // return ListView.builder(
    //     padding: const EdgeInsets.all(8),
    //     itemCount: categoryEmojiList.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return Container(
    //           height: 50,
    //           child: Container(
    //             decoration: BoxDecoration(
    //               border: Border(
    //                   bottom: BorderSide(color: Colors.green[700], width: 2)),
    //             ),
    //             padding: EdgeInsets.all(7),
    //             child: Icon(
    //               Icons.av_timer,
    //               color: Colors.white,
    //             ),
    //           ));
    //     });
    //   return Wrap(
    //     children: <Widget>[
    //       Container(
    //         decoration: BoxDecoration(
    //           border:
    //               Border(bottom: BorderSide(color: Colors.green[700], width: 2)),
    //         ),
    //         padding: EdgeInsets.all(7),
    //         child: Icon(
    //           Icons.av_timer,
    //           color: Colors.white,
    //         ),
    //       ),
    //       Container(
    //         padding: EdgeInsets.all(7),
    //         child: Icon(
    //           Icons.emoji_emotions,
    //           color: Colors.white,
    //         ),
    //       ),
    //     ],
    //   );
  }

  Widget searchBox() {
    return Container(
      margin: EdgeInsets.only(right: 10, top: 10, bottom: 10),
      // padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue[600]),
      ),
      child: TextFormField(
        controller: searchController,
        keyboardType: TextInputType.text,
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
        autofocus: true,
        cursorColor: Colors.green,
        cursorWidth: 2,
        // controller: txt,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search',
            contentPadding: EdgeInsets.only(left: 10, right: 10)),
        onChanged: (val) {
          streamController.add(val);
        },
        //          style: inputText,
      ),
    );
  }

  Widget emojiItems() {
    return Container(
      child: Expanded(
          // padding: EdgeInsets.all(0),
          flex: 3,
          child: GridView.count(
              crossAxisCount: 10,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              children: List.generate(filteredEmojiList.length, (index) {
                return Center(
                  child: workDoneIcons(index),
                );
              }))),
    );
  }

  // Widget allIcons() {
  //   return
  //      Column(
  //       children: [frequentlyusedEmoji(), gettingWorkDoneEmoji()],
  //     );
  // }

  Widget frequentlyusedEmoji() {
    return Container(
      padding: EdgeInsets.all(7),
      child: Text(
        "Frequently Used",
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget frequentlyUsedIcons(index) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(listFrequentlyUsed[index]),
    );
  }

  Widget workDoneIcons(index) {
    return Container(
        padding: EdgeInsets.all(7),
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (!listFrequentlyUsed
                  .contains(filteredEmojiList[index].emoji.toString())) {
                listFrequentlyUsed.add(filteredEmojiList[index].emoji);
              }
            });
          },
          child: new Text(filteredEmojiList[index].emoji),
        ));
  }

  Widget gettingWorkDoneEmoji() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        "Getting Work Done",
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
