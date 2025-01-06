import 'dart:convert';
import 'package:http/http.dart' as http;

class WhatsAppMessageSender {
  final String apiUrlBase = 'https://graph.facebook.com/v21.0';
  final String fromNumber;
  final String authToken;

  // set authToken and apiUrl in the constructor
  WhatsAppMessageSender(this.authToken, this.fromNumber);


  // create a method sendMessage

  String get apiUrl => '$apiUrlBase/$fromNumber/messages';

  // take the phone number and message as input and send the message


  Future<void> sendMessage({
    required String to,
    required String templateName,
    required String languageCode,
    Map<String, dynamic>? parameters,
  }) async {

    // check if the to number is valid -> it should start from 91 and should be 12 digits 
    // if it is 10 digits then add 91 in the beginning
    if (to.startsWith('0') && to.length == 11) {
      to = '91' + to.substring(1);
    }
    else if (to.startsWith('0') && to.length == 10) {
      to = '91' + to;
    }
    else if (to.length == 10) {
      to = '91' + to;    
    }
    
    if (!to.startsWith('91') && to.length != 12) {
      print('Invalid phone number');
      return;
    }

    final Map<String, dynamic> body = {
      "messaging_product": "whatsapp",
      "to": to,
      "type": "template",
      "template": {
        "name": templateName,
        "language": {
          "code": languageCode,
        },
        if (parameters != null) "components": [
          {
            "type": "body",
            "parameters": parameters.entries.map((entry) {
              return {
                "type": "text",
                "text": entry.value,
              };
            }).toList(),
          }
        ],
      },
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    // check for status code accept like 201 or 200 or 204 etc.

    if (response.statusCode >= 200 && response.statusCode <= 299 ) {
      print('Message sent successfully');
    } else {
      print('Failed to send message: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}