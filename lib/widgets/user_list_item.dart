import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_list/model/status.dart';
import 'package:user_list/model/user.dart';

class UserListItem extends StatelessWidget {
  final User _user;
  final Function(User) _onTap;
  final bool _isLoading;

  const UserListItem(
    this._user,
    this._onTap,
    this._isLoading,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    String imageName;

    switch (_user.status) {
      case Status.active:
        imageName = 'active';
        break;
      case Status.locked:
        imageName = 'locked';
        break;
      default:
        imageName = 'unknown';
    }

    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    String createdAt = dateFormat.format(_user.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: Card(
        elevation: 2,
        child: ListTile(
          dense: false,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          onTap: () => _onTap(_user),
          title: Text(
            '${_user.firstName} ${_user.lastName}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: _isLoading
            ? const SizedBox(
              height: 30.0,
              width: 30.0,
              child: Center(
                child: CircularProgressIndicator()
              ),
            )
            : Image.asset(
                'assets/img/user-$imageName.png',
                fit: BoxFit.contain,
                width: 30,
              ),
          subtitle: Text(
            'Created at: $createdAt',
          ),
        ),
      ),
    );
  }
}
