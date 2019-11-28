import 'package:demo_ecommerce/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  int _id;

  String _idValidator(value) {
    if (value.isEmpty) {
      return "field can not be empty";
    } else if (num.tryParse(value) == null) {
      return "field must be number";
    } else {
      return null;
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<AuthProvider>(context, listen: false).login(_id);
    } catch (error) {
      print(error);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey,
              child: TextFormField(
                autofocus: true,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "User Id",
                ),
                validator: _idValidator,
                onSaved: (value) {
                  setState(() {
                    _id = num.tryParse(value);
                  });
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            _isLoading
                ? CircularProgressIndicator()
                : Container(
                    width: double.infinity,
                    height: 50,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: _handleLogin,
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
