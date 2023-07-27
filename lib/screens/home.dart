import 'package:flutter/material.dart';
import 'package:user_list/controller/api.dart';
import 'package:user_list/model/status.dart';
import 'package:user_list/model/user.dart';
import 'package:user_list/widgets/curved_appbar.dart';
import 'package:user_list/widgets/modals/error_snackbar.dart';
import 'package:user_list/widgets/modals/status_dialog.dart';
import 'package:user_list/widgets/user_list_item.dart';

class UserListHome extends StatefulWidget {
  const UserListHome({super.key});

  final String title = 'User List';

  @override
  State<UserListHome> createState() => _UserListHomeState();
}

class _UserListHomeState extends State<UserListHome> {
  bool _isLoading = true;
  List<User> _users = [];
  int? _updatingUser;

  @override
  void initState() {
    super.initState();
    Api.fetchUsers()
      .then((users) {
        setState(() {
          _users = users;
          _isLoading = false;
        });
      })
      .catchError((e) {
        ErrorSnackbar.show(context, 'Connection error. Please try again!');
        setState(() {
          _isLoading = false;
        });
      });
  }

  void _promptStatusUpdate(User user) {
    if (_updatingUser != null) {
      return;
    }

    Status newStatus = user.status == Status.active
      ? Status.locked
      : Status.active;

    StatusDialog.show(
      context, 
      user,
      () => _updateStatus(user.id, newStatus),
      () => _editUser(user),
    );
  }

  void _updateStatus(int id, Status status) {
    setState(() {
      _updatingUser = id;
    });

    const String errorMessage = 'Failed to update status. Please try again!';

    Api.updateStatus(id, status)
      .then((success) {
        if (!success) {
          ErrorSnackbar.show(context, errorMessage);
          return;
        }

        final List<User> updated = [
          ..._users
            .map((user) => user.id == _updatingUser
              ? user.updated(newStatus: status)
              : user
            )];

        setState(() {
          _users = updated;
        });
      })
      .catchError((e) {
        ErrorSnackbar.show(context, errorMessage);
      })
      .whenComplete(() => setState(() {
        _updatingUser = null;
      }));
  }

  void _editUser(User user) async {
    final User? updated = await Navigator.pushNamed(context, '/user_info', arguments: user) as User?;
    if (updated == null) {
      return;
    }

    final List<User> updatedList = [
      ..._users.map((item) => item.id == updated.id ? updated : item)
    ];

    setState(() {
      _users = updatedList;
    });
  }

  Widget _renderList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return _users.isEmpty
      ? const Center(
        child: Text(
          'No users found',
          style: TextStyle(
            fontSize: 30,
          )
        ),
      )
      : Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 50.0, bottom: 120.0),
          itemCount: _users.length,
          itemBuilder: (context, index) => UserListItem(
            _users[index],
            (user) => _promptStatusUpdate(user),
            _users[index].id == _updatingUser,
          ),
          shrinkWrap: true,
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CurvedAppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _renderList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading || _updatingUser != null
          ? null 
          : () async {
            final User? newUser = await Navigator.pushNamed(context, '/user_info') as User?;
            if (newUser == null) {
              return;
            }

            setState(() {
              _users.insert(0, newUser);
            });
        },
        tooltip: 'Add User',
        child: const Icon(Icons.add),
      ),
    );
  }
}
