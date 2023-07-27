import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:user_list/main.dart';
import 'package:user_list/model/status.dart';
import 'package:user_list/model/user.dart';
import 'package:user_list/screens/user_info.dart';
import 'package:user_list/widgets/user_list_item.dart';

void main() {
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  testWidgets('Home Widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const UserListApp());

    expect(find.text('User List'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('User Info Widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: UserInfo()));
    await tester.pump(Duration.zero);

    expect(find.text('New User'), findsOneWidget);
    expect(find.byIcon(Icons.save), findsOneWidget);
  });

  testWidgets('User List Item active user test', (WidgetTester tester) async {
    final DateTime now = DateTime.now();
    final DateTime createAt = now.add(const Duration(days: -1));
    final String formattedDate = dateFormat.format(createAt);

    final User activeTestUser = User(
      1,
      'John',
      'Doe',
      Status.active,
      createAt,
      now.add(const Duration(hours: -2)),
    );

    await tester.pumpWidget(MaterialApp(
      home: UserListItem(activeTestUser, (User user) => {}, false))
    );

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.image(const AssetImage('assets/img/user-unknown.png')), findsNothing);
    expect(find.image(const AssetImage('assets/img/user-locked.png')), findsNothing);
    expect(find.image(const AssetImage('assets/img/user-active.png')), findsOneWidget);
    expect(find.text('Created at: $formattedDate'), findsOneWidget);
  });

  testWidgets('User List Item locked user test', (WidgetTester tester) async {
    final DateTime now = DateTime.now();
    final DateTime createAt = now.add(const Duration(days: -3));
    final String formattedDate = dateFormat.format(createAt);

    final User lockedTestUser = User(
      2,
      'Jane',
      'Doe',
      Status.locked,
      createAt,
      now.add(const Duration(hours: -4)),
    );

    await tester.pumpWidget(MaterialApp(
      home: UserListItem(lockedTestUser, (User user) => {}, false))
    );

    expect(find.text('Jane Doe'), findsOneWidget);
    expect(find.image(const AssetImage('assets/img/user-unknown.png')), findsNothing);
    expect(find.image(const AssetImage('assets/img/user-active.png')), findsNothing);
    expect(find.image(const AssetImage('assets/img/user-locked.png')), findsOneWidget);
    expect(find.text('Created at: $formattedDate'), findsOneWidget);
  });

  testWidgets('User List Item loading state test', (WidgetTester tester) async {
    final DateTime now = DateTime.now();
    final DateTime createAt = now.add(const Duration(days: -5));
    final String formattedDate = dateFormat.format(createAt);

    final User lockedTestUser = User(
      3,
      'Donkey',
      'Kong',
      Status.locked,
      createAt,
      now.add(const Duration(hours: -6)),
    );

    await tester.pumpWidget(MaterialApp(
      home: UserListItem(lockedTestUser, (User user) => {}, true))
    );

    expect(find.text('Donkey Kong'), findsOneWidget);
    expect(find.image(const AssetImage('assets/img/user-unknown.png')), findsNothing);
    expect(find.image(const AssetImage('assets/img/user-active.png')), findsNothing);
    expect(find.image(const AssetImage('assets/img/user-locked.png')), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Created at: $formattedDate'), findsOneWidget);
  });
}
