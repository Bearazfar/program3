import 'dart:convert';
import 'package:http/http.dart' as http;
import 'users.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Programe 3 DEmo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/userform': (context) => const UserForm(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: const SideMenu(),
      body: const Center(
        child: Text("Home Page"),
      ),
    );
  }
}


class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    String accountName = "N/A";
    String accountEmail = "N/A";
    String accountUrl =
        "https://apis.wu.ac.th/des/PicPersonFile/5500000009.jpg";
    Users user = Configure.login;

    if (user.id != null) {
      accountName = user.fullname!;
      accountEmail = user.email!;
    }

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(accountName),
            accountEmail: Text(accountEmail),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(accountUrl),
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context); 
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text("Login"),
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                emailInputField(),
                passwordInputField(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      loginUser(email, password);
                    }
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget emailInputField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Email",
        icon: Icon(Icons.email),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your email";
        }
        return null;
      },
      onSaved: (newValue) => email = newValue!,
    );
  }

  Widget passwordInputField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Password",
        icon: Icon(Icons.lock),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your password";
        }
        return null;
      },
      onSaved: (newValue) => password = newValue!,
    );
  }


////Suchakree Longji

  void loginUser(String email, String password) {
    if (email == "a@test.com" && password == "1q2w3e4r") {
      Configure.login.email = email; 
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoggedInHomePage()),
      );
    }
  }
}



class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  late Users user;

  @override
  Widget build(BuildContext context) {
    try {
      user = ModalRoute.of(context)!.settings.arguments as Users;
      print(user.fullname);
    } catch (e) {
      user = Users();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Form"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fnameInputField(),
              emailInputField(),
              passwordInputField(),
              genderFormInput(),
              const SizedBox(
                height: 10,
              ),
              submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget fnameInputField() {
    return TextFormField(
      initialValue: user.fullname,
      decoration: const InputDecoration(
        labelText: "Fullname",
        icon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => user.fullname = newValue,
    );
  }

  Widget emailInputField() {
    return TextFormField(
      initialValue: user.email,
      decoration: const InputDecoration(
        labelText: "Email",
        icon: Icon(Icons.email),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => user.email = newValue,
    );
  }

  Widget passwordInputField() {
    return TextFormField(
      initialValue: user.password,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Password",
        icon: Icon(Icons.lock),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => user.password = newValue,
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          print(user.toJson().toString());
          if (user.id == null) {
            addNewUser(user);
          } else {
            updateData(user);
          }
        }
      },
      child: const Text("Save"),
    );
  }

  Widget genderFormInput() {
    var initGen = "None";
    try {
      if (user.gender != null) {
        initGen = user.gender!;
      }
    } catch (e) {
      initGen = "None";
    }
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Gender",
        icon: Icon(Icons.person),
      ),
      value: initGen,
      items: Configure.gender.map((String val) {
        return DropdownMenuItem(
          value: val,
          child: Text(val),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          user.gender = value;
        });
      },
      onSaved: (newValue) => user.gender = newValue,
    );
  }

  Future<void> addNewUser(Users user) async {
    var url = Uri.http(Configure.server, "users");
    var resp = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );
    var rs = usersFromJson("[${resp.body}]");
    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
  }

  Future<void> updateData(Users user) async {
    var url = Uri.http(Configure.server, "user/${user.id}");
    var resp = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );
    var rs = usersFromJson("[${resp.body}]");
    if (rs.length == 1) {
      Navigator.pop(context, "refresh");
    }
  }
}



class Configure {
  static String server = "172.16.42.179:3000";
  static List<String> gender = ["None", "Male", "Female"];

  static Users login = Users(); 
}

//json-server --host 172.16.42.179 data.json

class LoggedInHomePage extends StatelessWidget {
  const LoggedInHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users List"),
      ),
      body: FutureBuilder<List<Users>>(
        future: fetchUsers(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Suchakree Longji"),
                  subtitle: Text("a@test.com"),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Users>> fetchUsers() async {
    final response = await http.get(Uri.parse('http://172.16.42.179:3000/users'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Users.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
