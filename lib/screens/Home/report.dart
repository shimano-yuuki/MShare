import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../../app.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _reportController = TextEditingController();
  final _emailController = TextEditingController();

  void _sendEmail() async {
    final Email email = Email(
      body: _reportController.text,
      subject: _nameController.text,
      recipients: ['yuukireirei5@gmail.com'],
      cc: [_emailController.text],
    );
    await FlutterEmailSender.send(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF262626),
      appBar: AppBar(
        backgroundColor: Color(0xFF262626),
        title: Text('通報ページ',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '氏名',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: _reportController,
                decoration: InputDecoration(
                  labelText: '通報内容',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your report';
                  }
                  return null;
                },
              ),
              TextFormField(
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              Builder(
                builder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _sendEmail();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Sending email')));
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(), // SecondPageは遷移先のクラス
                          ),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
