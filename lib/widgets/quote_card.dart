import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:simple_quote_app/models/quote.dart';
import 'package:simple_quote_app/services/author_image_api.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final AuthorImageApi imageApi = AuthorImageApi();

  QuoteCard({super.key, required this.quote});

  // Обновленная функция для запуска URL
  void _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      bool launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        throw 'Could not launch $url';
      }
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Colors.grey[850], // Тёмно-серый цвет карточки
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: FutureBuilder<String?>(
              future: imageApi.fetchAuthorImage(quote.author),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  return Image.network(snapshot.data!, fit: BoxFit.cover);
                } else if (snapshot.hasError) {
                  return const Icon(Icons.error);
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  quote.text,
                  style: const TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => _launchURL(Uri.parse('https://en.wikipedia.org/wiki/${quote.author.replaceAll(' ', '_')}')),
                  child: Text(
                    '- ${quote.author}',
                    style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
