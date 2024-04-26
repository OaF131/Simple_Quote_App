import 'package:flutter/material.dart';
import 'package:simple_quote_app/models/quote.dart';
import 'package:simple_quote_app/services/quote_api.dart';
import 'package:simple_quote_app/widgets/quote_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State
{
  Quote? _currentQuote;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchQuote();
  }

  Future<void> _fetchQuote() async {
    setState(() {
      _isLoading = true;
    });
    try {
      QuoteApi api = QuoteApi();
      var quote = await api.getQuote();
      setState(() {
        _currentQuote = quote;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: const Text('Failed to load a new quote. Check your internet connection.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Quote'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).pushNamed('/history');
            },
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _currentQuote != null
            ? QuoteCard(quote: _currentQuote!)
            : const Text('No quote loaded. Press the button to fetch a quote.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchQuote,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}