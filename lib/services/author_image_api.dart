import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthorImageApi {
  Future<String?> fetchAuthorImage(String authorName) async {
    String url = 'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages&pithumbsize=500&redirects=1&titles=$authorName';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var pages = data['query']['pages'] as Map<String, dynamic>;
        if (pages.isNotEmpty) {
          var page = pages.values.first;
          if (page['thumbnail'] != null) {
            return page['thumbnail']['source'];
          }
        }
      }
    } catch (e) {
      print('Failed to fetch author image: $e');
    }
    return null;
  }
}
