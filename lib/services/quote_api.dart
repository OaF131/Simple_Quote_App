import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class QuoteApi {
  static const String _baseUrl =
      'https://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en';

  Future
  getQuote() async {
  try {
  final response = await http.get(Uri.parse(_baseUrl));
  if (response.statusCode == 200) {
  final Map<String, dynamic> data = json.decode(response.body);
  final String quoteText = data['quoteText'];
  final String quoteAuthor = data['quoteAuthor'];
  return Quote(text: quoteText, author: quoteAuthor);
  } else {
  throw Exception('Failed to load quote');
  }
  } catch (e) {
  throw Exception('Failed to connect to the API');
  }
}
}