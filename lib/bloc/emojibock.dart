import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hayhub_assesment/Model/emojiModel.dart';

class EmojiBloc {
  EmojiBloc() {
    //fetchPatientData("");
  }

  Future<List<dynamic>> generateData(context) async {
    final load =
        await DefaultAssetBundle.of(context).loadString("assets/emoji.json");
    var decoded = json.decode(load);
    List<EmojiModel> arrayEmoji = [];
    for (var item in decoded) {
      arrayEmoji.add(EmojiModel.fromJson(item));
    }

    print(arrayEmoji.first.category);

    return arrayEmoji;
  }
}

final emojiBloc = EmojiBloc();
