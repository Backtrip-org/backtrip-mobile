import 'dart:convert';
import 'dart:io';
import 'package:backtrip/model/chat_message.dart';
import 'package:backtrip/util/backtrip_api.dart';
import 'package:backtrip/util/stored_token.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static Future<List<ChatMessage>> getChatMessages(tripId) async {
    var uri = '${BacktripApi.path}/chat_message/$tripId';
    var headers = {
      HttpHeaders.authorizationHeader: await StoredToken.getToken()
    };
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      return compute(parseChatMessages, response.body);
    } else {
      throw Exception('Failed to load chat messages');
    }
  }

  static List<ChatMessage> parseChatMessages(String responseBody) {
    Iterable data = json.decode(responseBody);
    return data.map((model) => ChatMessage.fromJson(model)).toList();
  }
}