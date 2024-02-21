import 'dart:convert';
import 'package:http/http.dart' as http;

class Role {
  final int id;
  final String role;

  Role({required this.id, required this.role});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      role: json['role'], // Change 'name' to 'role' to match the JSON response
    );
  }
}

Future<List<Role>> fetchRoles() async {
  final url = Uri.parse("http://172.24.32.1:8080/user/getUserRole");

  try {
    final response = await http.get(
      url,
      headers: <String, String>{"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      // Decode the response JSON
      List<dynamic> rolesJson = jsonDecode(response.body);
      print("role is ");
      print(rolesJson);

      // Convert JSON to a list of Role objects
      List<Role> roles = rolesJson.map((roleJson) => Role.fromJson(roleJson)).toList();
      print("The only roles are ");
      print(roles);

      return roles;
    } else {
      // Handle other status codes (e.g., 400, 500) here
      throw Exception('Failed to fetch roles: ${response.reasonPhrase}');
    }
  } catch (e) {
    // Handle network errors here
    throw Exception('Failed to fetch roles: $e');
  }
}
