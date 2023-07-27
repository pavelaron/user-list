import 'package:flutter/material.dart';
import 'package:user_list/model/status.dart';
import 'package:user_list/model/user.dart';

class StatusDialog {
  static void show(BuildContext context, User user, Function onAccept, Function onEdit) {
    Status newStatus = user.status == Status.active
      ? Status.locked
      : Status.active;

    String statusButtonText = newStatus == Status.active ? 'Activate' : 'Lock';
    String message = '${user.firstName} ${user.lastName} is currently ${user.status.name}';

    final AlertDialog alert = AlertDialog(
      title: const Text('User Info'),
      content: Text(message),
      actions: [
        TextButton(child: Text('$statusButtonText user'), onPressed: () {
          Navigator.of(context).pop();
          onAccept();
        }),
        TextButton(child: const Text('Edit user info'), onPressed: () {
          Navigator.of(context).pop();
          onEdit();
        }),
        TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop()),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }
}