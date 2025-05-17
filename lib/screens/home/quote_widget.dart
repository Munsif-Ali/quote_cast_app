import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/models/quote_model.dart';
import '../../data/services/api_service.dart';

class QuoteWidget extends ConsumerWidget {
  const QuoteWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteAsync = ref.watch(quoteFutureProvider);
    return quoteAsync.when(
      data: (quote) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quote.content,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                '- ${quote.author}',
                style:
                    const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        );
      },
      error: (error, st) {
        return Center(child: Text('Error: $error'));
      },
      loading: () {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('Loading...'),
          ),
        );
      },
    );
  }
}

final quoteFutureProvider = FutureProvider<QuoteModel>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final quote = await apiService.getQuote();
  return quote;
});
