import 'package:flutter/material.dart';
import '../Utilities/ResponsiveDim.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/loginBackgroundImage.dart';
import '../Widgets/login_container.dart';
import '../Widgets/progress_indicator.dart';
import '../Widgets/radio_box.dart';
import '../Model/RoleModel.dart';
import '../main.dart';

class RoleSelection extends StatefulWidget {
  const RoleSelection({super.key});

  @override
  State<RoleSelection> createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelection> {
  String? _selectedOption;
  int? _selectedRoleId;
  late Future<List<Role>> _rolesFuture; // Future for fetching roles

  @override
  void initState() {
    super.initState();
    _rolesFuture = fetchRoles(); // Initialize the future for fetching roles
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            const LoginBackgroundImage(),
            Center(
              child: LoginContainer(
                children: <Widget>[
                  SizedBox(height: ResponsiveDim.height45),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context); // Navigate back
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Role selection',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ResponsiveDim.font24,
                            fontWeight: FontWeight.bold,
                            fontFamily: "poppins"
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveDim.height20),
                  const ProgressIndicators(currentPage: 1, totalPages: 2),
                  SizedBox(height: ResponsiveDim.height20),
                  const Text(
                    'What do you wish to do in Haat Bazaar?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FutureBuilder<List<Role>>(
                    future: _rolesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Show a loading indicator while fetching roles
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}'); // Show an error message if fetching roles fails
                      } else {
                        if (_selectedOption == null) {
                          // If no role is selected, set the default role here
                          _selectedOption = snapshot.data!.first.role;
                          _selectedRoleId = snapshot.data!.first.id;
                        }
                        return Padding(
                          padding: EdgeInsets.only(left: ResponsiveDim.width45, top: ResponsiveDim.height10),
                          child: RadioBox(
                            options: snapshot.data!.map((role) => role.role).toList(), // Pass the role names
                            selectedOption: _selectedOption,
                            onChanged: (String? roleName) {
                              setState(() {
                                _selectedOption = roleName; // Update the selected option name
                                _selectedRoleId = snapshot.data!.firstWhere((role) => role.role == roleName).id; // Update the selected role ID
                              });
                            },
                          ),
                        );
                      }
                    },
                  ),

                  buildSignInButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSignInButton() {
    return CustomButton(
      buttonText: 'Continue',
      onPressed: () {
        roleId=_selectedRoleId;
        print("selected_id is ");
        print(roleId);
        // Navigate based on the selected role ID
            Navigator.pushNamed(context, 'createUserAccount');

        }
    );
  }
}
