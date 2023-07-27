import 'package:flutter/material.dart';
import 'package:user_list/controller/api.dart';
import 'package:user_list/model/status.dart';
import 'package:user_list/model/user.dart';
import 'package:user_list/widgets/curved_appbar.dart';
import 'package:user_list/widgets/modals/error_snackbar.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);
  
  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  User? _user;
  Status _status = Status.active;
  
  bool _isLoading = false;
  bool _validated = false;

  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      User? user = ModalRoute.of(context)?.settings.arguments as User?;
      setState(() {
        _user = user;
        _firstNameController.text = user?.firstName ?? '';
        _lastNameController.text = user?.lastName ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = _user?.id == null ? 'New User' : 'Edit User';

    return Scaffold(
      appBar: CurvedAppBar(
        title: Text(title),
      ),
      body: _isLoading
        ? const Center(
          child: CircularProgressIndicator(),
        )
        : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 70.0, horizontal: 20.0),
          child: Column(
            children: [
              TextField(
                decoration: _inputDecoration('First name', _firstNameController),
                textCapitalization: TextCapitalization.words,
                controller: _firstNameController,
                onChanged: (value) => setState(() { _validated = false; }),
              ),
              const SizedBox(height: 40),
              TextField(
                decoration: _inputDecoration('Last name', _lastNameController),
                textCapitalization: TextCapitalization.words,
                controller: _lastNameController,
                onChanged: (value) => setState(() { _validated = false; }),
              ),
              const SizedBox(height: 40),
              Visibility(
                visible: _user?.id == null, 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Locked',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      )
                    ),
                    Switch(
                      value: _status == Status.locked,
                      thumbIcon: thumbIcon,
                      activeColor: Colors.red,
                      onChanged: (bool value) { 
                        setState(() {
                          _status = value == true
                            ? Status.locked
                            : Status.active;
                        });
                      }, 
                    ),
                  ],
                ),
              ),
            ],
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : () {
          if (!_isValid) {
            return;
          }

          setState(() {
            _isLoading = true;
          });

          _user?.id == null
            ? _createUser()
            : _updateUser();
        },
        tooltip: 'Save User',
        child: const Icon(Icons.save),
      ),
    );
  }

  final MaterialStateProperty<Icon?> thumbIcon = MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) => states.contains(MaterialState.selected)
      ? const Icon(Icons.lock)
      : null,
  );

  void _createUser() {
    Api.createUser(
      _firstNameController.text,
      _lastNameController.text,
      _status,
    )
      .then((user) {
        Navigator.pop(context, user);
      })
      .onError((error, stackTrace) {
        ErrorSnackbar.show(context, 'Failed to create user. Please try again!');
      })
      .whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
  }

  void _updateUser() {
    String errorMessage = 'Failed to update user. Please try again!';

    Api.updateUser(
      _user!.id,
      _firstNameController.text,
      _lastNameController.text,
    )
      .then((success) {
        if (!success) {
          ErrorSnackbar.show(context, errorMessage);
          return;
        }

        User updatedUser = _user?.renamed(
          newFirstName: _firstNameController.text,
          newLastName: _lastNameController.text,
        );

        Navigator.pop(context, updatedUser);
      })
      .onError((error, stackTrace) {
        ErrorSnackbar.show(context, errorMessage);
      })
      .whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
  }

  InputDecoration _inputDecoration(String label, TextEditingController controller) {
    return InputDecoration(
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 1.0),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
      ),
      labelText: label,
      errorText: controller.text.isEmpty && _validated 
        ? 'This field is required'
        : null,
    );
  }

  bool get _isValid {
    List<bool> validations = [
      _firstNameController.text != '',
      _lastNameController.text != '',
    ];

    setState(() {
      _validated = true;
    });
    
    return validations.every((element) => element);
  }
}
