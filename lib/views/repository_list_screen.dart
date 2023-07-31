import 'package:flutter/material.dart';
import 'package:search_github_repo/models/account.dart';
import 'package:search_github_repo/widgets/repository_item_widget.dart';

class RepositoryListScreen extends StatefulWidget {
  const RepositoryListScreen({Key? key}) : super(key: key);

  @override
  State<RepositoryListScreen> createState() => _RepositoryListScreenState();
}

class _RepositoryListScreenState extends State<RepositoryListScreen> {
  final List _options = [
    {'text': 'REPOSITÓRIOS', 'repositories': [], 'selected': true},
    {'text': 'FAVORITOS', 'repositories': [], 'selected': false},
  ];

  Map get _optionSelected {
    return _options
        .where((option) => option['selected'] == true)
        .toList()
        .first;
  }

  void loadOptions(account) {
    _options.asMap().forEach((index, value) {
      if (_options[index]['text'] == 'REPOSITÓRIOS') {
        _options[index] = {...value, 'repositories': account?.repositories};
      } else {
        _options[index] = {...value, 'repositories': account?.starRepositories};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Account? account =
        ModalRoute.of(context)?.settings.arguments as Account;

    loadOptions(account);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              key: const Key('repository_list_screen-avatar'),
              radius: 18.0,
              backgroundImage: NetworkImage(account!.avatarUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                account.username,
                key: const Key('repository_list_screen-username'),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            key: const Key('repository_list_screen-search_button'),
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(12.0),
                child: ToggleButtons(
                  key: const Key('repository_list_screen-toggle_buttons'),
                  color: Colors.indigo,
                  // fillColor: Colors.indigo[200],
                  fillColor: Theme.of(context).primaryColor,
                  selectedColor: Colors.white,
                  selectedBorderColor: Colors.black,
                  constraints: const BoxConstraints(
                    minHeight: 50.0,
                    minWidth: 150.0,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                  ),
                  onPressed: (int index) {
                    if (_options[index]['selected'] == true) return;

                    setState(() {
                      for (int i = _options.length - 1; i >= 0; i--) {
                        _options[i]['selected'] = !_options[i]['selected'];
                      }
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  children:
                      _options.map((option) => Text(option['text'])).toList(),
                  isSelected: List<bool>.from(
                      _options.map((option) => option['selected']).toList()),
                ),
              ),
            ],
          ),
          Expanded(
            key: Key(
              'repository_list_screen-list_${_optionSelected['text'].toLowerCase()}',
            ),
            child: _optionSelected['repositories'].length > 0
                ? ListView.builder(
                    itemCount: _optionSelected['repositories'].length,
                    padding: const EdgeInsets.all(5.0),
                    itemBuilder: (ctx, i) => RepositoryItem(
                        _optionSelected['repositories'][i],
                        _optionSelected['text']),
                  )
                : const Center(
                    child: Text(
                      'Poxa! Sua lista está vazia.',
                      key: Key('repository_list_screen-empty_list_test'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
