import 'package:flutter/material.dart';

import '../repositories/github_repository.dart';

class RepositorySearchScreen extends StatefulWidget {
  const RepositorySearchScreen({Key? key}) : super(key: key);

  @override
  State<RepositorySearchScreen> createState() => _RepositorySearchScreenState();
}

class _RepositorySearchScreenState extends State<RepositorySearchScreen> {
  final GlobalKey<FormState> _form = GlobalKey();
  bool _isLoading = false;

  String _accountName = '';

  void _setLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<void> _submit(BuildContext context) async {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();

    _setLoading();

    var service = GithubRepository();

    try {
      var response = await service.search(_accountName);

      Navigator.of(context).pushReplacementNamed(
        '/account-details',
        arguments: response,
      );
    } catch (error) {
      _setLoading();
      final errorMessage = error.toString().replaceAll('Exception:', '').trim();
      if (errorMessage == 'Repository not found!') {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            key: const Key('repository_search_screen-repository_not_found'),
            title: const Text('Não encontrado!'),
            content: const Text('Repositório não encontrado'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Github Repo!")),
      body: _isLoading
          ? const Center(
              key: Key('repository_search_screen-loading'),
              child: CircularProgressIndicator(
                color: Colors.indigo,
              ),
            )
          : Form(
              key: _form,
              child: Container(
                margin: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      key: const Key(
                          'repository_search_screen-repository_field'),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 20.0,
                        ),
                        hintText: 'Qual conta GitHub?',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Informe uma conta GitHub';
                        }
                        return null;
                      },
                      onSaved: (value) => _accountName = value!,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        key: const Key('repository_search_screen-button'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        onPressed: () => _submit(context),
                        child: const Text('PESQUISAR'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
