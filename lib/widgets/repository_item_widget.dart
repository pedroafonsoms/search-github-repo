import 'package:flutter/material.dart';
import 'package:search_github_repo/models/repository.dart';

class RepositoryItem extends StatelessWidget {
  final Repository _repository;
  final String _type;

  const RepositoryItem(this._repository, this._type, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key('repository_item-${_type.toLowerCase()}'),
      elevation: 10.0,
      margin: const EdgeInsets.all(10.0),
      child: ListTile(
        leading: CircleAvatar(
          child: _type == 'REPOSITÓRIOS'
              ? const Icon(Icons.check_circle_outlined)
              : const Icon(Icons.star_border),
          backgroundColor: Colors.white,
        ),
        title: Text(
          _repository.name,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text('${_repository.openIssuesCount} issues em aberto'),
        trailing: Text(_repository.language),
      ),
    );
  }
}
