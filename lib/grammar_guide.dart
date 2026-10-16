part of 'main.dart';

const grammarGuideItems = [
  (
    title: 'Nouns',
    hint: 'A noun names a person, place, thing, or idea.',
    prompt: 'Identify the noun in the sentence: The cat is sleeping.',
    example: 'The cat is sleeping. → cat',
    reflection: '“Cat” names an animal. Animal names are nouns, just like names of people, places, things, and ideas.',
    retry: 'Identify the nouns: The teacher gave us homework.',
    choices: ['teacher and homework', 'gave and us', 'The and gave', 'us and The'],
    answer: 0,
    feedback: 'Teacher names a person; homework names schoolwork and is an uncountable noun. Both are nouns.',
  ),
  (
    title: 'Subject pronouns',
    hint: 'Use subject pronouns for the doer.',
    prompt: 'Complete the sentence: _____ are late.',
    example: 'We are late.',
    reflection: '“We” is a subject pronoun. You and they could also fit before are; the context tells us which person or group we mean.',
    retry: 'Choose the subject pronoun: _____ is my best friend.',
    choices: ['Her', 'She', 'Hers', 'Herself'],
    answer: 1,
    feedback: 'She is the subject form among these choices. He or singular they could be used with suitable context; they takes are.',
  ),
  (
    title: 'Object pronouns',
    hint: 'Use object pronouns for the receiver.',
    prompt: 'Choose the correct pronoun: She gave _____ the book. (I / me)',
    example: 'She gave me the book.',
    reflection: 'Use “me” as an object. Object forms also follow prepositions such as to.',
    retry: 'The teacher spoke to _____. (he / him)',
    choices: ['he', 'him'],
    answer: 1,
    feedback: 'Him is the object of the preposition to. He is a subject pronoun.',
  ),
  (
    title: 'Subject–verb agreement',
    hint: 'Singular subjects take singular verbs.',
    prompt: 'Correct the verb: The dog bark.',
    example: 'The dog barks.',
    reflection: '“Dog” is third-person singular, so use “barks” in the present simple. Plural subjects use the base form.',
    retry: 'My friends _____ coffee. (like)',
    choices: ['likes', 'liking', 'like', 'is liking'],
    answer: 2,
    feedback: 'Friends is plural, so use like without the third-person singular -s.',
  ),
  (
    title: 'Joining sentences',
    hint: 'Avoid run-on sentences.',
    prompt: 'Combine the ideas using a conjunction: I was tired. I went home.',
    example: 'I was tired, so I went home.',
    reflection: '“So” shows cause and effect. Choose a conjunction that matches the relationship between the ideas.',
    retry: 'Join these ideas to show contrast: It was raining. I still went to school.',
    choices: [
      'It was raining, so I still went to school.',
      'It was raining, but I still went to school.',
      'It was raining, I still went to school.',
      'It was raining I still went to school.',
    ],
    answer: 1,
    feedback: 'But shows contrast between the rain and going to school anyway. Yet would also work. Use a comma before the conjunction joining these independent clauses.',
  ),
];

class GrammarGuideCard extends StatelessWidget {
  const GrammarGuideCard({super.key});

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Grammar guide', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('Build your skills from simple to complex, one small step at a time.'),
            const SizedBox(height: 8),
            const Text('Hint → Prompt → Example → Reflection → Retry'),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (_) => const GrammarGuideScreen())),
              icon: const Icon(Icons.school_outlined),
              label: const Text('Start 5 guided samples'),
            ),
          ]),
        ),
      );
}

class GrammarGuideScreen extends StatefulWidget {
  const GrammarGuideScreen({super.key});

  @override
  State<GrammarGuideScreen> createState() => _GrammarGuideScreenState();
}

class _GrammarGuideScreenState extends State<GrammarGuideScreen> {
  static const stages = ['Hint', 'Prompt', 'Example', 'Reflection', 'Retry'];
  int itemIndex = 0;
  int stage = 0;
  int? selected;
  bool checked = false;
  bool finished = false;

  void reset() => setState(() {
        itemIndex = 0;
        stage = 0;
        selected = null;
        checked = false;
        finished = false;
      });

  @override
  Widget build(BuildContext context) {
    final item = grammarGuideItems[itemIndex];
    final correct = selected == item.answer;
    final content = [item.hint, item.prompt, item.example, item.reflection, item.retry];
    return Scaffold(
      appBar: AppBar(title: const Text('Guided grammar practice')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(key: ValueKey('$itemIndex-$stage-$finished'), padding: const EdgeInsets.all(20), children: [
            Text(finished ? 'All 5 samples completed' : 'Sample ${itemIndex + 1} of 5 · ${item.title}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: finished ? 1 : (itemIndex * 5 + stage) / 25),
            const SizedBox(height: 20),
            if (finished) ...[
              const Icon(Icons.check_circle_outline, size: 64, color: green),
              const SizedBox(height: 12),
              const Text('You practiced nouns, pronouns, agreement, and sentence connections. Continue with the grammar lessons to build on these skills.'),
              const SizedBox(height: 16),
              FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Return to Grammar')),
              TextButton(onPressed: reset, child: const Text('Practice again')),
            ] else ...[
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (var i = 0; i < stages.length; i++)
                  Chip(label: Text('${i < stage ? '✓ ' : ''}${stages[i]}'),
                      backgroundColor: i == stage ? Theme.of(context).colorScheme.primaryContainer : null),
              ]),
              const SizedBox(height: 16),
              Card(child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(stages[stage], style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Text(content[stage], style: const TextStyle(fontSize: 18, height: 1.5)),
                  if (stage == 1) ...[
                    const SizedBox(height: 12),
                    const Text('Try answering aloud or in your notebook before revealing the example.'),
                  ],
                  if (stage == 3) ...[
                    const SizedBox(height: 12),
                    const Text('Explain in your own words why the example works. Then apply the rule to a new sentence.'),
                  ],
                  if (stage == 4) ...[
                    const SizedBox(height: 16),
                    for (var i = 0; i < item.choices.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SizedBox(width: double.infinity, child: OutlinedButton(
                          onPressed: checked ? null : () => setState(() => selected = i),
                          child: Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(children: [
                              Icon(selected == i ? Icons.radio_button_checked : Icons.radio_button_off),
                              const SizedBox(width: 10),
                              Expanded(child: Text(item.choices[i])),
                            ])),
                        )),
                      ),
                    if (checked)
                      Semantics(liveRegion: true, child: Text(
                        correct ? 'Correct! ${item.feedback}' : 'Not quite. Review the hint: ${item.hint}',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600),
                      )),
                  ],
                ]),
              )),
              const SizedBox(height: 16),
              if (stage < 4)
                FilledButton(onPressed: () => setState(() => stage++),
                    child: Text(stage == 1 ? 'Reveal example' : 'Continue to ${stages[stage + 1]}'))
              else if (!checked)
                FilledButton(onPressed: selected == null ? null : () => setState(() => checked = true),
                    child: const Text('Check answer'))
              else if (!correct)
                FilledButton(onPressed: () => setState(() { selected = null; checked = false; }),
                    child: const Text('Try again'))
              else
                FilledButton(onPressed: () => setState(() {
                  if (itemIndex == grammarGuideItems.length - 1) {
                    finished = true;
                  } else {
                    itemIndex++;
                    stage = 0;
                    selected = null;
                    checked = false;
                  }
                }), child: Text(itemIndex == 4 ? 'Finish practice' : 'Next sample')),
              if (stage > 0)
                TextButton(onPressed: () => setState(() => stage--), child: const Text('Previous step')),
            ],
          ]),
        ),
      ),
    );
  }
}
