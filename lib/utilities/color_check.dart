import 'package:flutter/material.dart';
import 'package:flash_chat/utilities/backend.dart';
import 'dart:math' as math;
import 'dart:async';

class ColorCheck {
  final backend = Backend();

  static Color contrastColor(Color color) {
    if (color == Colors.transparent || color.alpha < 50) {
      return Colors.black87;
    }
    double luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  Future<int> getMessageColor({String loggedInUserEmail}) async {
    int hexColor;
    // if user has already sent messages, retrieve hexColor, otherwise random create new one.
    var userMessages =
        await backend.getUserMessages(loggedInUserEmail: loggedInUserEmail);
    for (var message in userMessages.documents) {
      hexColor = message.data['hexColor'];
    }
    if (hexColor == null) {
      // Generate random color for the user's messages
      bool isCheckPositive = false;
      while (isCheckPositive == false) {
        hexColor = (math.Random().nextDouble() * 0xFFFFFF).toInt() << 0;
        // If already used, generate another one
        isCheckPositive = !(await checkForDuplicates(hexColor: hexColor));
      }
    }
    return hexColor;
  }

  Future<bool> checkForDuplicates({int hexColor}) async {
    bool isDuplicated = false;
    var messages = await backend.getAllMessages();
    for (var message in messages.documents) {
      int hexColorMessage = message.data['hexColor'];
      if (hexColorMessage == hexColor) {
        isDuplicated = true;
        break;
      }
    }
    return isDuplicated;
  }
}
