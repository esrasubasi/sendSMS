import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readsms/readsms.dart';
import 'package:sms_receiver/sms_receiver.dart';
import 'package:tele_connect/sms_read/sms_read_view.dart';
import 'package:tele_connect/sms_read/sms_read_view_model.dart';

void main() {
  runApp(const MyApp());
}

SMSReadViewModel _viewModel = SMSReadViewModel();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
    _viewModel.getPermission().then((value) {
      if (value) {
        _viewModel.plugin.read();
        _viewModel.plugin.smsStream.listen((event) {
          setState(() {
            _viewModel.sms = event.body;
            _viewModel.sender = event.sender;
            _viewModel.time = event.timeReceived.toString();
          });
          _viewModel.onSmsReceived(_viewModel.sms);
          _viewModel.sendSMSMethod();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SMSReadView(),
    );
  }
}
