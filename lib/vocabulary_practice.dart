part of 'main.dart';

// Legacy lesson cards remain usable from the all-lessons library.
class VocabularyWordCard extends StatelessWidget {
  const VocabularyWordCard({super.key, required this.word});
  final Map<String, dynamic> word;
  @override
  Widget build(BuildContext context) => VocabularyPanel(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(word['word'] ?? '',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(
            '${word['pronunciation'] ?? ''} · ${word['part_of_speech'] ?? ''}'),
        Text(word['meaning'] ?? ''),
        Text(word['example'] ?? ''),
        Text('Synonyms: ${(word['synonyms'] as List? ?? []).join(', ')}'),
        Text('Antonyms: ${(word['antonyms'] as List? ?? []).join(', ')}'),
        if (pronunciationAvailable)
          TextButton.icon(
              onPressed: () => pronounce(word['word']),
              icon: const Icon(Icons.volume_up),
              label: const Text('Listen')),
      ]));
}

class VocabularyPracticeCard extends StatefulWidget {
  const VocabularyPracticeCard({super.key, required this.words});
  final List<Map<String, dynamic>> words;
  @override
  State<VocabularyPracticeCard> createState() => _VocabularyPracticeCardState();
}

class _VocabularyPracticeCardState extends State<VocabularyPracticeCard> {
  int index = 0;
  String answer = '';
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    if (widget.words.isEmpty) return const SizedBox.shrink();
    final word = widget.words[index % widget.words.length];
    return VocabularyPanel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Spelling practice',
          style: TextStyle(fontWeight: FontWeight.bold)),
      Text(word['meaning'] ?? ''),
      TextFormField(
          key: ValueKey(index),
          decoration:
              const InputDecoration(labelText: 'Type the vocabulary word'),
          onChanged: (v) => setState(() {
                answer = v;
                checked = false;
              })),
      TextButton(
          onPressed: () => setState(() => checked = true),
          child: const Text('Check Answer')),
      if (checked)
        Text(answer.trim().toLowerCase() ==
                word['word'].toString().toLowerCase()
            ? 'Correct! ${word['example'] ?? ''}'
            : 'Correct spelling: ${word['word']}. ${word['example'] ?? ''}'),
      TextButton(
          onPressed: () => setState(() {
                index++;
                answer = '';
                checked = false;
              }),
          child: const Text('Next word')),
    ]));
  }
}
