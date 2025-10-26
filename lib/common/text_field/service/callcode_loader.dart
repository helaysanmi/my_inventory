import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_inventory/common/text_field/model/callcode_model.dart';

class CallcodeLoader {
  static Future<List<CallcodeModel>> loadCallcode(
    BuildContext context,
    String assetPath,
  ) async {
    final String response = await rootBundle.loadString(assetPath);
    final List<dynamic> data = json.decode(response);

    return data.map((json) => CallcodeModel.fromJson(json)).toList();
  }
}
