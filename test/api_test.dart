import 'package:flutter_test/flutter_test.dart';
import 'package:user_list/controller/api.dart';
import 'package:user_list/model/status.dart';

void main() {
  test('Test user API calls', () async {
    final newUser = await Api.createUser('Jane', 'Doe', Status.active);

    expect(newUser, isNotNull);
    expect(newUser?.firstName, 'Jane');
    expect(newUser?.lastName, 'Doe');
    expect(newUser?.status, Status.active);

    final updateSuccess = await Api.updateStatus(newUser!.id, Status.locked);
    expect(updateSuccess, isTrue);

    final renameSuccess = await Api.updateUser(newUser.id, 'John', 'Doe');
    expect(renameSuccess, isTrue);

    final users = await Api.fetchUsers();
    final updatedUser = users.firstWhere((user) => user.id == newUser.id);

    expect(users.length, greaterThan(0));
    expect(updatedUser, isNotNull);
    expect(updatedUser.firstName, 'John');
    expect(updatedUser.lastName, 'Doe');
    expect(updatedUser.status, Status.locked);
  });
}
